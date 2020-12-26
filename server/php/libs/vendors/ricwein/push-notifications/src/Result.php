<?php

namespace ricwein\PushNotification;

use Exception;
use ricwein\PushNotification\Exceptions\RequestException;
use ricwein\PushNotification\Exceptions\ResponseReasonException;
use Throwable;

class Result
{
    /**
     * @var array<string, Exception|null>
     */
    private $feedback;

    public function __construct(array $feedback)
    {
        $this->feedback = $feedback;
    }

    /**
     * @return array<Exception|null>
     */
    public function getFeedback(): array
    {
        return $this->feedback;
    }

    /**
     * @return array<Exception>
     */
    public function getFailed(): array
    {
        $failed = [];
        foreach ($this->feedback as $token => $error) {
            if ($error !== null) {
                $failed[$token] = $error;
            }
        }
        return $failed;
    }

    /**
     * @throws Exception
     */
    public function throwOnFirstException(): void
    {
        foreach ($this->feedback as $error) {
            if ($error instanceof Exception) {
                throw $error;
            }
        }
    }

    /**
     * @return array<string>
     */
    public function getInvalidDeviceTokes(): array
    {
        $invalidTokens = [];
        foreach ($this->feedback as $token => $result) {
            if ($result instanceof ResponseReasonException && $result->isInvalidDeviceToken()) {
                $invalidTokens[] = $token;
            }
        }
        return $invalidTokens;
    }

    /**
     * @param string $type
     * @throws Throwable
     */
    public function throwOnFirstExceptionOfType(string $type): void
    {
        foreach ($this->feedback as $error) {
            if ($error instanceof $type) {
                throw $error;
            }
        }
    }

}
