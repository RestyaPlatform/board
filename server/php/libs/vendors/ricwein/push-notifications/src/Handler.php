<?php
/**
 * @author Richard Weinhold
 */

namespace ricwein\PushNotification;

use Exception;
use RuntimeException;

/**
 * PushHandler, providing base push operations
 */
abstract class Handler
{
    /**
     * @var string[]
     */
    protected $devices = [];

    public function addDevice(string $token): void
    {
        $this->devices[] = $token;
    }

    /**
     * @param Message $message
     * @return array<string, Exception|null>
     */
    abstract public function send(Message $message): array;

    /**
     * @param array $payload
     * @param int $priority
     * @return array<string, Exception|null>
     */
    abstract public function sendRaw(array $payload, int $priority = Config::PRIORITY_HIGH): array;
}
