<?php
/**
 * To create thumbnail for uploaded images
 *
 * PHP version 5
 *
 * @category   PHP
 * @package    Restyaboard
 * @subpackage Core
 * @author     Restya <info@restya.com>
 * @copyright  2014-2016 Restya
 * @license    http://restya.com/ Restya Licence
 * @link       http://restya.com/
 */
require_once 'config.inc.php';
$size = $_GET['size'];
$model = $_GET['model'];
$filename = $_GET['filename'];
$val = $thumbsizes[$model][$size];
list($width, $height) = explode('x', $val);
list($id, $hash, $ext) = explode('.', $filename);
if ($hash == md5(SECURITYSALT . $model . $id . $ext . $size)) {
    $condition = array(
        $id
    );
    if ($model == 'User') {
        $s_result = pg_query_params($db_lnk, 'SELECT profile_picture_path FROM users WHERE id = $1', $condition);
        $row = pg_fetch_assoc($s_result);
        $fullPath = $row['profile_picture_path'];
    } else if ($model == 'Organization') {
        $s_result = pg_query_params($db_lnk, 'SELECT logo_url FROM organizations WHERE id = $1', $condition);
        $row = pg_fetch_assoc($s_result);
        $fullPath = $row['logo_url'];
    } else if ($model == 'Board') {
        $s_result = pg_query_params($db_lnk, 'SELECT background_picture_path FROM boards WHERE id = $1', $condition);
        $row = pg_fetch_assoc($s_result);
        $fullPath = $row['background_picture_path'];
    } else if ($model == 'CardAttachment') {
        $s_result = pg_query_params($db_lnk, 'SELECT path FROM card_attachments WHERE id = $1', $condition);
        $row = pg_fetch_assoc($s_result);
        $fullPath = $row['path'];
    }
    $fullPath = APP_PATH . '/' . $fullPath;
    $is_aspect = false;
    if (!empty($aspect[$model][$size])) {
        $is_aspect = true;
    }
    $mediadir = APP_PATH . '/client/img/' . $size . '/' . $model . '/';
    if (!file_exists($mediadir)) {
        mkdir($mediadir, 0777, true);
    }
    $filename = $id . '.' . $hash . '.' . $ext;
    $writeTo = $mediadir . $filename;
    if (!$width || !$height) {
        header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
        exit;
    }
    if (!($size = getimagesize($fullPath))) {
        header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
        exit;
    }
    list($currentWidth, $currentHeight, $currentType) = $size;
    if (class_exists('imagick')) {
        $new_image_obj = new imagick($fullPath);
        $new_image = $new_image_obj->clone();
        $new_image->setImageColorspace(Imagick::COLORSPACE_RGB);
        $new_image->flattenImages();
        if (!$is_aspect) {
            $new_image->cropThumbnailImage($width, $height);
        } else {
            $new_image->scaleImage($width, $height, false);
        }
        $new_image->writeImage($writeTo);
    } else {
        $target['width'] = $currentWidth;
        $target['height'] = $currentHeight;
        $target['x'] = $target['y'] = 0;
        $types = array(
            1 => 'gif',
            'jpeg',
            'png',
            'swf',
            'psd',
            'wbmp'
        );
        //http://www.php.net/imagecreatefromjpeg#60241 && http://in2.php.net/imagecreatefrompng#73546
        $imageInfo = getimagesize($fullPath);
        $imageInfo['channels'] = !empty($imageInfo['channels']) ? $imageInfo['channels'] : 1;
        $imageInfo['bits'] = !empty($imageInfo['bits']) ? $imageInfo['bits'] : 1;
        $memoryNeeded = round(($imageInfo[0] * $imageInfo[1] * $imageInfo['bits'] * $imageInfo['channels'] / 8 + Pow(2, 16)) * 1.65);
        if (function_exists('memory_get_usage') && memory_get_usage() + $memoryNeeded > (integer)ini_get('memory_limit') * pow(1024, 2)) {
            ini_set('memory_limit', (integer)ini_get('memory_limit') + ceil(((memory_get_usage() + $memoryNeeded) - (integer)ini_get('memory_limit') * pow(1024, 2)) / pow(1024, 2)) . 'M');
        }
        $image = call_user_func('imagecreatefrom' . $types[$currentType], $fullPath);
        ini_restore('memory_limit');
        // adjust to aspect.
        if ($is_aspect) {
            if (($currentHeight / $height) > ($currentWidth / $width)) {
                $width = ceil(($currentWidth / $currentHeight) * $height);
            } else {
                $height = ceil($width / ($currentWidth / $currentHeight));
            }
        } else {
            // Optimized crop adopted from http://in2.php.net/imagecopyresized#71182
            $proportion_X = $currentWidth / $width;
            $proportion_Y = $currentHeight / $height;
            if ($proportion_X > $proportion_Y) {
                $proportion = $proportion_Y;
            } else {
                $proportion = $proportion_X;
            }
            $target['width'] = $width * $proportion;
            $target['height'] = $height * $proportion;
            $original['diagonal_center'] = round(sqrt(($currentWidth * $currentWidth) + ($currentHeight * $currentHeight)) / 2);
            $target['diagonal_center'] = round(sqrt(($target['width'] * $target['width']) + ($target['height'] * $target['height'])) / 2);
            $crop = round($original['diagonal_center'] - $target['diagonal_center']);
            if ($proportion_X < $proportion_Y) {
                $target['x'] = 0;
                $target['y'] = round((($currentHeight / 2) * $crop) / $target['diagonal_center']);
            } else {
                $target['x'] = round((($currentWidth / 2) * $crop) / $target['diagonal_center']);
                $target['y'] = 0;
            }
        }
        if (function_exists('imagecreatetruecolor') && ($temp = imagecreatetruecolor($width, $height))) {
            imagecopyresampled($temp, $image, 0, 0, $target['x'], $target['y'], $width, $height, $target['width'], $target['height']);
        } else {
            $temp = imagecreate($width, $height);
            imagecopyresized($temp, $image, 0, 0, 0, 0, $width, $height, $currentWidth, $currentHeight);
        }
        if (strtolower($ext) == 'png') {
            imagepng($temp, $writeTo);
        } else if (strtolower($ext) == 'jpg' || strtolower($ext) == 'jpeg') {
            imagejpeg($temp, $writeTo, 100);
        } else if (strtolower($ext) == 'gif') {
            imagegif($temp, $writeTo);
        }
        ob_start();
        call_user_func('image' . $types[$currentType], $temp);
        ob_get_clean();
        imagedestroy($image);
        imagedestroy($temp);
    }
    header('Location:' . $_SERVER['REQUEST_URI'] . '?chrome-3xx-fix');
} else {
    header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
}
