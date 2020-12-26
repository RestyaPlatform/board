<?php

namespace ricwein\PushNotification\Handler;

use ricwein\PushNotification\Config;
use ricwein\PushNotification\Exceptions\RequestException;
use ricwein\PushNotification\Exceptions\ResponseException;
use ricwein\PushNotification\Handler;
use ricwein\PushNotification\Message;
use RuntimeException;

class APNSBinary extends Handler
{
    private const URLS = [
        Config::ENV_PRODUCTION => 'tlsv1.2://gateway.push.apple.com:2195',
        Config::ENV_DEVELOPMENT => 'tlsv1.2://gateway.sandbox.push.apple.com:2195',
    ];

    /**
     * @var string
     */
    private $endpoint;

    /**
     * @var string
     */
    private $certPath;

    /**
     * @var string|null
     */
    private $certPassphrase;

    /**
     * @var int
     */
    private $timeout;

    public function __construct(string $environment, string $certPath, ?string $certPassphrase = null, ?string $url = null, int $timeout = 10)
    {
        if ($url !== null) {
            $this->endpoint = $url;
        } elseif (isset(static::URLS[$environment])) {
            $this->endpoint = static::URLS[$environment];
        } else {
            throw new RuntimeException("Unknown or unsupported environment {$environment}", 500);
        }

        if (!file_exists($certPath) || !is_readable($certPath)) {
            throw new RuntimeException("Certificate not found or not readable for path: {$certPath}", 404);
        }

        $this->certPath = $certPath;
        $this->certPassphrase = $certPassphrase;
        $this->timeout = $timeout;
    }

    public function addDevice(string $token): void
    {
        if (64 !== $length = strlen($token)) {
            throw new RuntimeException("Invalid device-token {$token}, length must be 64 chars but is {$length}.", 500);
        }
        if (!ctype_xdigit($token)) {
            throw new RuntimeException("Invalid device-token {$token}, must be of type hexadecimal but is not.");
        }
        $this->devices[] = $token;
    }

    /**
     * @param Message $message
     * @return array
     * @throws RequestException
     */
    public function send(Message $message): array
    {
        if (count($this->devices) < 1) {
            return [];
        }

        $payload = array_merge_recursive([
            'aps' => [
                'alert' => $message->getTitle() !== null ? ['title' => $message->getTitle(), 'body' => $message->getBody()] : $message->getBody(),
                'badge' => $message->getBadge(),
                'sound' => $message->getSound(),
            ]
        ], $message->getPayload());

        return $this->sendRaw($payload, $message->getPriority());
    }

    /**
     * @param array $payload
     * @param int $priority
     * @return array
     * @throws RequestException
     */
    public function sendRaw(array $payload, int $priority = Config::PRIORITY_HIGH): array
    {
        if (count($this->devices) < 1) {
            return [];
        }

        $arbitrary = ['command' => 2, 'priority' => $priority === Config::PRIORITY_HIGH ? 10 : 5];

        // extract arbitrary settings
        foreach (['expire', 'messageID', 'priority', 'command'] as $key) {
            if (isset($payload[$key])) {
                $arbitrary[$key] = (int)abs($payload[$key]);
                unset($payload[$key]);
            }
        }

        $sslOptions = [
            'local_cert' => $this->certPath,
        ];

        // set cert passphrase if given
        if ($this->certPassphrase !== null) {
            $sslOptions['passphrase'] = $this->certPassphrase;
        }

        // open tcp-stream to server
        $stream = @stream_socket_client(
            $this->endpoint,
            $errno,
            $errstr,
            $this->timeout,
            STREAM_CLIENT_CONNECT | STREAM_CLIENT_PERSISTENT,
            stream_context_create(['ssl' => $sslOptions])
        );

        if (!$stream) {
            throw new RequestException("Error connecting to server: [{$errno}] {$errstr}", 500);
        }

        $content = json_encode($payload, JSON_UNESCAPED_UNICODE);

        try {
            set_error_handler(static function (int $errorCode, string $error): bool {
                if (0 === error_reporting()) {
                    // error was suppressed with the @-operator
                    return false;
                }
                throw new RequestException("Sending to APNS failed: [{$errorCode}] - {$error}");
            });

            $feedback = [];
            foreach ($this->devices as $deviceKey => $deviceToken) {

                // build binary notification
                $notification = $this->packPayload($deviceToken, $content, $arbitrary, $arbitrary['command']);

                // write into stream and apply result onto previous results
                if (false !== fwrite($stream, $notification)) {
                    unset($this->devices[$deviceKey]);
                    $feedback[$deviceToken] = null;
                    continue;
                }

                $feedback[$deviceToken] = new RequestException("Request failed.", 500);
            }

            $this->devices = [];
            return $feedback;

        } finally {
            // remove custom fwrite() error-handler
            restore_error_handler();
            fclose($stream);
        }
    }

    private function packPayload(string $deviceToken, string $payload, array $arbitrary = [], int $version = 1): string
    {
        // set default arbitrary settings
        $arbitrary = array_merge([
            'expire' => 0,
            'messageID' => 0,
            'priority' => 10,
        ], $arbitrary);

        // cleanup device tokens
        $deviceToken = str_replace(' ', '', trim($deviceToken, '<> '));

        switch ($version) {
            case 1:
                $notification = pack('C', 1); // Command 1
                $notification .= pack('N', (int)$arbitrary['messageID']); // notification id
                $notification .= pack('N', ($arbitrary['expire'] > 0 ? time() + $arbitrary['expire'] : 0)); // expiration timestamps
                $notification .= pack('nH*', 32, $deviceToken); // device-token
                $notification .= pack('n', strlen($payload)) . $payload; // payload
                return $notification;

            case 2:
                $notification = pack('CnH*', 1, 32, $deviceToken); // device-token
                $notification .= pack('CnA*', 2, strlen($payload), $payload); // payload
                $notification .= pack('CnN', 3, 4, (int)$arbitrary['messageID']); // notification id
                $notification .= pack('CnN', 4, 4, ($arbitrary['expire'] > 0 ? time() + $arbitrary['expire'] : 0)); // expiration timestamps
                $notification .= pack('CnC', 5, 1, (int)$arbitrary['priority']); // notification priority

                // pack notification into frame
                $frame = pack('C', 2); // Command 2
                $frame .= pack('N', strlen($notification)) . $notification; // notification
                return $frame;
        }

        throw new RuntimeException("Unsupported command version: {$version}", 500);
    }
}
