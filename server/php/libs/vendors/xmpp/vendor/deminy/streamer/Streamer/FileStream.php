<?php

namespace Streamer;

class FileStream extends Stream
{
    public static function create($filename, $mode, $use_include_path = false, $context = null)
    {
        return new static(fopen($filename, $mode, $use_include_path, $context));
    }
}
