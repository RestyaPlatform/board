# Streamer

Streamer is an Object-Oriented API for PHP streams.

## Why should I use Streams?

A stream is a flow of bytes from one container to the other. You already use streams a lot in PHP, for instance each time you load a file into memory (`file_get_contents()`). You should explicitly use streams each time that:

* You need to access data from a container, but you don't know the size of this container (e.g. reading from STDIN, or a web service using streaming)
* You need to start processing data from a container before the whole transfer is finished (e.g. start zipping a file before it's all in memory)
* You need to save time and memory

## What is Streamer?

PHP has a very elaborate stream API ; unfortunately, it uses functions for most stream operations (except for wrappers - go figure). Streamer is a generic library focusing on offering an object-oriented API to streams, and only that.

## Installation

Streamer is published on [packagist.org](http://packagist.org/packages/deminy/streamer), so you can add it to your `composer.json` file for an easy installation:

```json
{
    "require": {
        "deminy/streamer": "@dev"
    }
}
```

## Example

```php
<?php
use Streamer\Stream;

// basic usage
$stream = new Stream(fopen('smiley.png', 'r'));
$image = '';
while (!$stream->isEOF()) {
  $image .= $stream->read();
}

// pipe dreams!
$stream1 = new Stream(fopen('smiley.png', 'r'));
$stream2 = new Stream(fopen('tmp.png', 'w'));
// copy the contents from the first stream to the second one
$stream1->pipe($stream2);
```

### Credits

Streamer was originally developed by [fzaninotto](https://github.com/fzaninotto/Streamer), which was heavily inspired by other Stream class implementations:

* [Guzzle](https://github.com/guzzle/guzzle/blob/master/src/Guzzle/Common/Stream.php)
* [Joomla's Filesystem Stream](http://api.joomla.org/__filesource/fsource_Joomla-Platform_FileSystem--_librariesjoomlafilesystemstream.php.html)
* [Node.Js Stream API](http://nodejs.org/api/stream.html)
