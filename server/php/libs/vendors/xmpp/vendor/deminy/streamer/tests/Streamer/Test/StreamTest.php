<?php

namespace Streamer\Test;

use Streamer\Stream;

class StreamTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @expectedException Streamer\Exception\InvalidArgumentException
     */
    public function testConstructorRequiresAValidResource()
    {
        $stream = new Stream('hello');
    }

    public function testGetResourceReturnsThePHPResource()
    {
        $handle = fopen('php://temp', 'r+');
        $stream = new Stream($handle);
        $this->assertEquals($handle, $stream->getResource());
    }

    public function testGetMetadataReturnsTheCompleteStreamMetadata()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $expected = array(
            'wrapper_type' => 'PHP',
            'stream_type' => 'TEMP',
            'mode' => 'w+b',
            'unread_bytes' => 0,
            'seekable' => true,
            'uri' => 'php://temp'
        );
        $this->assertEquals($expected, $stream->getMetadata());
    }

    public function testGetMetadataForKeyReturnsAMetadataElementIfExists()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertEquals('TEMP', $stream->getMetadataForKey('stream_type'));
    }

    public function testGetMetadataForKeyReturnsNullIfMetadataElementDoesNotExist()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertNull($stream->getMetadataForKey('foo'));
    }

    public function testGetUriReturnsStreamUri()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertEquals('php://temp', $stream->getUri());
    }

    public function testGetStreamTypeReturnsStreamType()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertEquals('TEMP', $stream->getStreamType());
    }

    public function testGetWrapperTypeReturnsWrapperType()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertEquals('PHP', $stream->getWrapperType());
    }

    public function testGetWrapperDataReturnsStreamWrapperDataIfExists()
    {
        $this->markTestIncomplete();
        // needs a custom wrapper to mock wrapperdata
    }

    public function testGetWrapperDataReturnsNullIfStreamHasNoWrapperData()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertNull($stream->getWrapperData());
    }

    public function testIsLocalReturnsTrueIfStreamIsLocal()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertTrue($stream->isLocal());
    }

    public function testIsLocalReturnsFalseIfStreamIsNotLocal()
    {
        $this->markTestIncomplete();
        // needs a custom wrapper to avoid actually using http, which slows down tests
    }

    protected static function getModesAndVariants($modes)
    {
        $binaryModes = array_map(
            function($el) {
                return $el . 'b';
            },
            $modes
        );
        $windowsModes = array_map(
            function($el) {
                return $el . 't';
            },
            $modes
        );
        $allModes = array();
        foreach ($modes as $mode) {
            $allModes[] = array($mode);
        }
        foreach ($binaryModes as $mode) {
            $allModes[] = array($mode);
        }
        foreach ($windowsModes as $mode) {
            $allModes[] = array($mode);
        }
        
        return $allModes;
    }

    public static function readableStreamModesProvider()
    {
        return self::getModesAndVariants(array('r', 'r+', 'w+', 'a+', 'x+', 'c+'));
    }
    
    /**
     * @dataProvider readableStreamModesProvider
     */
    public function testIsReadableReturnsTrueIfStreamIsReadable($mode)
    {
        $filename = tempnam(sys_get_temp_dir(), 'foo');
        if (strpos($mode, 'x') !== false) {
            $filename .= 'bar';
        }
        $stream = new Stream(fopen('file://' . $filename, $mode));
        $this->assertTrue($stream->isReadable());
        $stream->close();
        unlink($filename);
    }

    public static function nonReadableStreamModesProvider()
    {
        return self::getModesAndVariants(array('w', 'a', 'x', 'c'));
    }

    /**
     * @dataProvider nonReadableStreamModesProvider
     */
    public function testIsReadableReturnsFalseIfStreamIsNotReadable($mode)
    {
        $filename = tempnam(sys_get_temp_dir(), 'foo');
        if (strpos($mode, 'x') !== false) {
            $filename .= 'bar';
        }
        $stream = new Stream(fopen('file://' . $filename, $mode));
        $this->assertFalse($stream->isReadable());
        $stream->close();
        unlink($filename);
    }

    public static function writableStreamModesProvider()
    {
        return self::getModesAndVariants(array('r+', 'w', 'w+', 'a', 'a+', 'x', 'x+', 'c', 'c+'));
    }

    /**
     * @dataProvider writableStreamModesProvider
     */
    public function testIsWritableReturnsTrueIfStreamIsWritable($mode)
    {
        $filename = tempnam(sys_get_temp_dir(), 'foo');
        if (strpos($mode, 'x') !== false) {
            $filename .= 'bar';
        }
        $stream = new Stream(fopen('file://' . $filename, $mode));
        $this->assertTrue($stream->isWritable());
        $stream->close();
        unlink($filename);
    }


    public static function nonWritableStreamModesProvider()
    {
        return self::getModesAndVariants(array('r'));
    }

    /**
     * @dataProvider nonWritableStreamModesProvider
     */
    public function testIsWritableReturnsFalseIfStreamIsNotWritable($mode)
    {
        $filename = tempnam(sys_get_temp_dir(), 'foo');
        if (strpos($mode, 'x') !== false) {
            $filename .= 'bar';
        }
        $stream = new Stream(fopen('file://' . $filename, $mode));
        $this->assertFalse($stream->isWritable());
        $stream->close();
        unlink($filename);
    }

    public function testIsSeekableReturnsTrueForSeekableStreams()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertTrue($stream->isSeekable());
    }

    public function testIsSeekableReturnsFalseForNonSeekableStreams()
    {
        $stream = new Stream(fopen('php://output', 'w'));
        $this->assertFalse($stream->isSeekable());
    }

    public function testIsOpenReturnsTrueOnOpenStreams()
    {
        $stream = new Stream(fopen('php://output', 'r'));
        $this->assertTrue($stream->isOpen());
    }

    public function testIsOpenReturnsFalseOnClosedStreams()
    {
        $stream = new Stream(fopen('php://output', 'r'));
        $stream->close();
        $this->assertFalse($stream->isOpen());
    }
    
    public function testGetBufferSizeReturnsBufferSize()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $this->assertEquals(4096, $stream->getBufferSize());
        $stream->setBufferSize(100);
        $this->assertEquals(100, $stream->getBufferSize());
    }
    
    /**
     * @expectedException Streamer\Exception\LogicException
     */
    public function testReadThrowsExceptionOnClosedStreams()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $stream->close();
        $stream->read();
    }

    /**
     * @expectedException Streamer\Exception\LogicException
     */
    public function testReadThrowsExceptionOnNonReadbleStreams()
    {
        $stream = new Stream(fopen('file://' . tempnam(sys_get_temp_dir(), 'foo'), 'w'));
        $stream->read();
    }
    
    public function testReadReturnsDataFromTheStream()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'foo');
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertEquals('foo', $stream->read());
    }

    public function testReadDoesNotCloseTheStream()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'foo');
        rewind($handle);
        $stream = new Stream($handle);
        $stream->read();
        $this->assertTrue($stream->isOpen());
    }

    public function testReadAcceptsALengthParameter()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'bar');
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertEquals('ba', $stream->read(2));
    }

    public function testReadContinuesFromTheCurrentPosition()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite(
            $handle,
            'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et ' .
            'dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ' .
            'ex ea commodo consequat.'
        );
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertEquals(
            'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore',
            $stream->read(100)
        );
        $this->assertEquals(
            ' et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ',
            $stream->read(100)
        );
        $this->assertEquals('aliquip ex ea commodo consequat.', $stream->read(100));
    }
    
    public function testReadReturnsEmptyStringWhenAtTheEndOfStream()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'bar');
        rewind($handle);
        $stream = new Stream($handle);
        $stream->read(3);
        $this->assertEquals('', $stream->read());
    }
    
    /**
     * @expectedException Streamer\Exception\LogicException
     */
    public function testGetLineThrowsExceptionOnNonReadbleStreams()
    {
        $stream = new Stream(fopen('file://' . tempnam(sys_get_temp_dir(), 'foo'), 'w'));
        $stream->getLine();
    }

    public function testGetLineReturnsDataFromTheStream()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, "foo");
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertEquals('foo', $stream->getLine());
    }

    public function tesGetLineDoesNotCloseTheStream()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'foo');
        rewind($handle);
        $stream = new Stream($handle);
        $stream->getLine();
        $this->assertTrue($stream->isOpen());
    }

    public function testGetLineStopsAtNewlineString()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, "foo\nbar");
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertEquals('foo', $stream->getLine());
    }

    public function testGetLineAcceptsALengthParameter()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, "foobar");
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertEquals('foo', $stream->getLine(3));
    }

    public function testGetLineAcceptsANewlineParameter()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, "foobar");
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertEquals('foo', $stream->getLine(null, 'b'));
    }

    public function testGetLineReturnsEmptyStringWhenAtTheEndOfStream()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'bar');
        rewind($handle);
        $stream = new Stream($handle);
        $stream->read(3);
        $this->assertEquals('', $stream->getLine());
    }

    public function testIsEOFReturnsFalseIfStreamIsNotAtEnd()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'foobar');
        rewind($handle);
        $stream = new Stream($handle);
        $this->assertFalse($stream->isEOF());
    }

    public function testIsEOFReturnsTrueIfStreamIsAtEnd()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'foobar');
        rewind($handle);
        $stream = new Stream($handle);
        $stream->read();
        $this->assertTrue($stream->isEOF());
    }
    
    public function testGetContentReturnsFullContentRegardlessOfBufferSize()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'foobar');
        rewind($handle);
        $stream = new Stream($handle);
        $stream->setBufferSize(1);
        $this->assertEquals('foobar', $stream->getContent());
    }

    public function testGetContentDoesNotCloseTheStream()
    {
        $handle = fopen('php://temp', 'r+');
        fwrite($handle, 'foobar');
        rewind($handle);
        $stream = new Stream($handle);
        $stream->getContent();
        $this->assertTrue($stream->isOpen());
    }

    /**
     * @expectedException Streamer\Exception\LogicException
     */
    public function testWriteThrowsExceptionOnClosedStreams()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $stream->close();
        $stream->write('foo');
    }

    /**
     * @expectedException Streamer\Exception\LogicException
     */
    public function testWriteThrowsExceptionOnNonWritableStreams()
    {
        $stream = new Stream(fopen('file://' . tempnam(sys_get_temp_dir(), 'foo'), 'r'));
        $stream->write('foo');
    }

    public function testWriteAddsDataToTheStream()
    {
        $handle = fopen('php://temp', 'w+');
        $stream = new Stream($handle);
        $stream->write('foo');
        $stream->rewind();
        $this->assertEquals('foo', $stream->read());
    }

    public function testWriteReturnsTheNumberOfAddedBytes()
    {
        $handle = fopen('php://temp', 'w+');
        $stream = new Stream($handle);
        $this->assertEquals(3, $stream->write('foo'));
    }

    public function testWriteAcceptsALengthParameter()
    {
        $handle = fopen('php://temp', 'w+');
        $stream = new Stream($handle);
        $stream->write('foo', 2);
        $stream->rewind();
        $this->assertEquals('fo', $stream->read());
    }

    public function testPipeCopiesONeStreamToTheOther()
    {
        $handle1 = fopen('php://temp', 'r+');
        fwrite($handle1, 'foobar');
        rewind($handle1);
        $stream1 = new Stream($handle1);
        $handle2 = fopen('php://temp', 'r+');
        $stream2 = new Stream($handle2);
        $stream1->pipe($stream2);
        $stream2->rewind();
        $this->assertEquals('foobar', $stream2->read());
    }

    public function testPipeReturnsTheNumberOfCopiedBytes()
    {
        $handle1 = fopen('php://temp', 'r+');
        fwrite($handle1, 'foobar');
        rewind($handle1);
        $stream1 = new Stream($handle1);
        $handle2 = fopen('php://temp', 'r+');
        $stream2 = new Stream($handle2);
        $this->assertEquals(6, $stream1->pipe($stream2));
    }
    
    /**
     * @expectedException Streamer\Exception\LogicException
     */
    public function testCloseThrowsExceptionOnClosedStreams()
    {
        $stream = new Stream(fopen('php://temp', 'r+'));
        $stream->close();
        $stream->close();
    }

    public function testCloseClosesStream()
    {
        $this->markTestIncomplete();
        // dunno how to test that
    }
}
