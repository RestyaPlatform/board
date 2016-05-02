Logging Interface
=================
``JAXLLogger`` provides all the logging facilities that we will ever require.
When logging to ``STDOUT`` it also colorizes the log message depending upon its severity level.
When logging to a file it can also do periodic log rotation.

log levels
----------

    * JAXL_ERROR (red)
    * JAXL_WARNING (blue)
    * JAXL_NOTICE (yellow)
    * JAXL_INFO (green)
    * JAXL_DEBUG (white)

global logging methods
----------------------
Following global methods for logging are available:

    * ``_error($msg)``
    * ``_warning($msg)``
    * ``_notice($msg)``
    * ``_info($msg)``
    * ``_debug($msg)``
        
_colorize/2
-----------
All the above global logging methods internally use ``_colorize($msg, $verbosity)`` to output colored
log message on the terminal.