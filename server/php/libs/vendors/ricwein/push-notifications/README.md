# PushNotification

... is a small php-library to wrap Apple (APNS) and Google (FCM) Push-Notifications into a simple syntax.

Examples:

### Android

```php
use ricwein\PushNotification\{PushNotification, Message, Handler};

$message = new Message('message', 'title', ['payload' => 'data']);
$fcm = new Handler\FCM('ExampleGooglePushToken12345678987654321');

$push = new PushNotification(['fcm' => $fcm]);
$push->send($message, ['<device-token>' => 'fcm']);
```

### iOS

> NOTE: The `APNS` Handler uses the *new* apple push servers, which require HTTP2. Therefore, curl with HTTP2 support must be installed. If it's not available, use the *legacy* `APNSBinary` handler instead!

```php
use ricwein\PushNotification\{PushNotification, Message, Handler, Config};

$message = new Message('message', 'title', ['payload' => 'data']);
$apns = new Handler\APNS(Config::ENV_PRODUCTION, 'com.bundle.id', 'cert.pem');
// $legacy = new Handler\APNSBinary(Config::ENV_PRODUCTION, 'cert.pem');

$push = new PushNotification(['apns' => $apns]);
$push->send($message, ['<device-token>' => 'apns']);
```

### mixed

Sending messages to multiple devices of difference operating systems is also simple: 

```php
use ricwein\PushNotification\{PushNotification, Message, Handler, Config};

$message = new Message('message', 'title');
$fcm = new Handler\FCM('ExampleGooglePushToken12345678987654321');
$apns = new Handler\APNS(Config::ENV_PRODUCTION, 'com.bundle.id', 'cert.pem');

$push = new PushNotification(['apns' => $apns, 'fcm' => $fcm]);
$push->send($message, [
    '<ios-device-token1>' => 'apns',
    '<ios-device-token2>' => 'apns',
    '<android-device-token1>' => 'fcm',
    '<android-device-token2>' => 'fcm',
]);
```

## usage

This class uses the root-namespace `ricwein\PushNotification`.

### init

The libraries main class is called `PushNotification` and requires an array of available push-handlers for the constructor. It's possible to set an ID as the handlers array key, to allow assigning devices to the handler later on.

Available push-handler are:

- Apple:   `PushNotification\Handler\APNS`
- Google:  `PushNotification\Handler\FCM`

They're all extending `PushNotification\Handler`

### configuration

Since all push-settings are push-handler specific, the settings are directly applied in the handler constructors.

- APNS:
```php
 APNS(
    string $environment /* (Config::ENV_PRODUCTION / Config::ENV_DEVELOPMENT) */,
    string $appBundleID,
    string $certPath,
    ?string $certPassphrase = null,
    ?string $url = null,
    int $timeout = 10
)
 ```

- FCM:
```php
 FCM(
    string $token,
    string $url = self::FCM_ENDPOINT,
    int $timeout = 10
)
 ```

It's also possible to have multiple push-handlers with different configurations like:

```php
use ricwein\PushNotification\{PushNotification, Message, Handler, Config};

$apnsProd = new Handler\APNS(Config::ENV_PRODUCTION, 'com.bundle.id', 'cert.pem');
$apnsDev = new Handler\APNS(Config::ENV_DEVELOPMENT, 'com.bundle.id', 'cert-dev.pem');
$message = new Message('message', 'title');
$push = new PushNotification(['prod' => $apnsProd, 'dev' => $apnsDev]);

$push->send($message, [
    '<ios-device-token1>' => 'prod',
    '<ios-device-token2>' => 'dev',
]);

```

### sending

Sending is either available for a message object or a raw payload.

- A message object is translated into a native push-notification message with body and title for FCM or APNS before sending.
- A raw payload (array) is sent '*as it is*' which might **not** be a good idea, if you want to mix APNS and FCM in one request. 

```php
$message = new Message('body', 'title');
$message->setSound('test.aiff')->setBadge(2)->setPriority(Config::PRIORITY_NORMAL);
$push->send($message, [...]);
```

### error handling

The `PushNotification::send()` method returns an `Result` object. This usually contains an array of per device errors. If everything succeeded, the entry is null. You can fetch failed device-messages with:

```php
$result = $push->send($message, [...]);
$errors = $result->getFailed(); 
```

Errors are handled as Exeptions, so it's possible to just throw them. To simply just throw the first error if one occurred, call:

```php
$push->send($message, [...])->throwOnFirstException();
```

***Be aware***: Sometimes other failures than usage-errors occur. APNS (HTTP2) can respond with explicit reasons, which will be handled as `ResponseReasonException`. It's a good idea to not just throw them, but handle them other ways. E.g. you might want to delete or update device-tokens which were marked as invalid.

```php
use \ricwein\PushNotification\Exceptions\ResponseReasonException;

foreach($result->getFailed() as $token => $error) {
    if ($error instanceof ResponseReasonException && $error->isInvalidDeviceToken()) {
        // do something with this information.
    }
}
```
