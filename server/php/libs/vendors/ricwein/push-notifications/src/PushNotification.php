<?php
/**
 * @author Richard Weinhold
 */

namespace ricwein\PushNotification;

use RuntimeException;

class PushNotification
{
    /**
     * @var array<string, Handler>
     */
    private $handlers;

    /**
     * PushNotification constructor.
     * @param array<string, Handler> $handlers
     */
    public function __construct(array $handlers = [])
    {
        foreach ($handlers as $handler) {
            if (!$handler instanceof Handler) {
                throw new RuntimeException(sprintf('Invalid Handler of type: %s', is_object($handler) ? get_class($handler) : gettype($handler)));
            }
        }

        $this->handlers = $handlers;
    }

    /**
     * @param array<string, string|Handler> $devices
     * @return array<array>
     */
    private function prepareHandlers(array $devices): array
    {
        $handlers = $this->handlers;
        $feedback = [];

        foreach ($devices as $token => $deviceHandler) {

            if (is_string($deviceHandler) && isset($this->handlers[$deviceHandler])) {
                $handlers[$deviceHandler]->addDevice($token);
                continue;
            }

            if ($deviceHandler instanceof Handler) {
                $handlers[] = $deviceHandler;
                $deviceHandler->addDevice($token);
                continue;
            }

            $feedback[$token] = new RuntimeException(sprintf('Invalid Handler of type %s for device: %s', is_object($deviceHandler) ? get_class($deviceHandler) : gettype($deviceHandler), $token), 500);
        }

        return [$handlers, $feedback];
    }

    /**
     * @param Message $message
     * @param array<string, string|Handler> $devices
     * @return Result
     */
    public function send(Message $message, array $devices): Result
    {
        [$handlers, $feedback] = $this->prepareHandlers($devices);
        $handlerFeedback = [];

        /** @var Handler $handler */
        foreach ($handlers as $handler) {
            $handlerFeedback[] = $handler->send($message);
        }

        return new Result(array_merge($feedback, ...$handlerFeedback));
    }

    /**
     * @param array $payload
     * @param array<string, string|Handler> $devices
     * @return Result
     */
    public function sendRaw(array $payload, array $devices): Result
    {
        [$handlers, $feedback] = $this->prepareHandlers($devices);
        $handlerFeedback = [];

        /** @var Handler $handler */
        foreach ($handlers as $handler) {
            $handlerFeedback[] = $handler->sendRaw($payload);
        }

        return new Result(array_merge($feedback, ...$handlerFeedback));
    }
}
