<?php

namespace ricwein\PushNotification\Handler;

use ricwein\PushNotification\Config;
use ricwein\PushNotification\Exceptions\RequestException;
use ricwein\PushNotification\Exceptions\ResponseException;
use ricwein\PushNotification\Exceptions\ResponseReasonException;
use ricwein\PushNotification\Handler;
use ricwein\PushNotification\Message;
use RuntimeException;

class APNS extends Handler
{
    private const URLS = [
        Config::ENV_PRODUCTION => 'https://api.push.apple.com:443/3/device',
        Config::ENV_DEVELOPMENT => 'https://api.development.push.apple.com:443/3/device',
    ];

    /**
     * @var string
     */
    private $endpoint;

    /**
     * @var string
     */
    private $appBundleID;

    /**
     * @var int
     */
    private $port;

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

    public function __construct(string $environment, string $appBundleID, string $certPath, ?string $certPassphrase = null, ?string $url = null, int $timeout = 10)
    {
        if ($url === null && isset(static::URLS[$environment])) {
            $url = static::URLS[$environment];
        } elseif ($url === null) {
            throw new RuntimeException("Unknown or unsupported environment {$environment}", 500);
        }

        if (false === $urlComponents = parse_url($url)) {
            throw new RuntimeException("Invalid endpoint-url given for APNS, failed to parse: {$url}", 500);
        }

        if (!isset($urlComponents['host'])) {
            throw new RuntimeException("Invalid endpoint-url given for APNS, missing host in: {$url}", 500);
        }

        $this->endpoint = sprintf("%s://%s%s", $urlComponents['scheme'] ?? 'https', $urlComponents['host'], $urlComponents['path'] ?? '/3/device');
        $this->port = !empty($urlComponents['port']) ? (int)$urlComponents['port'] : 443;

        if (!file_exists($certPath) || !is_readable($certPath)) {
            throw new RuntimeException("Certificate not found or not readable for path: {$certPath}", 404);
        }

        $this->appBundleID = $appBundleID;
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

    public function sendRaw(array $payload, int $priority = Config::PRIORITY_HIGH): array
    {
        if (count($this->devices) < 1) {
            return [];
        }

        $content = json_encode($payload, JSON_UNESCAPED_UNICODE);

        $headers = [
            sprintf('apns-priority: %d', $priority === Config::PRIORITY_HIGH ? 10 : 5),
            "apns-topic: {$this->appBundleID}",
            "Content-Type: application/json",
        ];

        $options = [
            CURLOPT_PORT => $this->port,
            CURLOPT_HTTPHEADER => $headers,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $content,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => $this->timeout,
            CURLOPT_SSLCERT => $this->certPath,
        ];

        if ($this->certPassphrase !== null) {
            $options[CURLOPT_KEYPASSWD] = $this->certPassphrase;
        }


        $curl = curl_init();
        curl_setopt($curl, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_2_0);

        $feedback = [];
        foreach ($this->devices as $deviceKey => $deviceToken) {

            // cleanup device tokens
            $deviceToken = str_replace(' ', '', trim($deviceToken, '<> '));
            $options[CURLOPT_URL] = "{$this->endpoint}/{$deviceToken}";

            // setup curl for device push notification
            curl_setopt_array($curl, $options);

            // execute request
            $result = curl_exec($curl);

            $httpStatusCode = curl_getinfo($curl, CURLINFO_RESPONSE_CODE);

            // success!
            if ($result !== false && $httpStatusCode === 200) {
                unset($this->devices[$deviceKey]);
                $feedback[$deviceToken] = null;
                continue;
            }

            // error handling
            $errorCode = curl_errno($curl);
            $error = curl_error($curl);

            if ($result === false) {
                if (!empty($error)) {
                    $feedback[$deviceToken] = new RequestException("Request failed with: [{$errorCode}]: {$error}", 500);
                } elseif ($httpStatusCode !== 0) {
                    $feedback[$deviceToken] = new RequestException("Request failed with: HTTP status code {$httpStatusCode}.", 500);
                } else {
                    $feedback[$deviceToken] = new RequestException("Request failed.", 500);
                }
                continue;
            }

            $result = @json_decode($result, true);
            if (isset($result['reason'])) {
                $feedback[$deviceToken] = new ResponseReasonException($result['reason'], $httpStatusCode);
            } else {
                $feedback[$deviceToken] = new ResponseException("Request failed with: [{$errorCode}]: {$error}", $httpStatusCode);
            }
        }

        curl_close($curl);

        $this->devices = [];
        return $feedback;
    }
}
