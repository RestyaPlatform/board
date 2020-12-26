<?php

namespace ricwein\PushNotification;

abstract class Config
{
    public const PRIORITY_NORMAL = 0b01;
    public const PRIORITY_HIGH = 0b10;

    public const ENV_PRODUCTION = 'prod';
    public const ENV_DEVELOPMENT = 'dev';
    public const ENV_CUSTOM = 'custom';

    public const SOUND_DEFAULT = 'default';
}
