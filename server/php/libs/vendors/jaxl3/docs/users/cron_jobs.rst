Cron Jobs
=========
``JAXLClock`` maintains a global clock which is updated after every iteration of the :ref:`main select loop <jaxl-instance>`.
During the clock tick phase, ``JAXLClock`` also dispatches any scheduled cron jobs.

Lets try some cron job scheduling using Jaxl interactive shell:

    >>> ./jaxlctl shell
    jaxl 1>
    jaxl 1> function do_job($params) {
    .......     echo "cron job called";
    ....... }
    jaxl 2>
    jaxl 2> $ref = JAXLLoop::$clock->call_fun_after(
    .......     4000, 
    .......     'do_job', 
    .......     'some_parameters'
    ....... );
    jaxl 3> echo $ref;
    1
    jaxl 4>
    cron job called
    jaxl 5> quit
    >>> 

We just saw a live example of a cron job. Using ``JAXLClock::call_fun_after/3`` we were able to 
call our ``do_job`` function after 4000 microseconds.

.. note::

    Since cron jobs are called inside main select loop, do not execute long running cron jobs using
    ``JAXLClock`` else the main select loop will not be able to detect any new activity on 
    watched file descriptors. In short, these cron job callbacks are blocking.
    
    In future, cron jobs might get executed in a seperate process space, overcoming the above limitation.
    Until then know what your jobs are doing and for how long or execute them in a seperate process space
    yourself. You have been warned !!!
    
one time jobs
-------------
``call_fun_after($time, $callback, $args)``

schedules $callback with $args after $time microseconds

periodic jobs
-------------
``call_fun_periodic($time, $callback, $args)``

schedules periodic $callback with $args after $time microseconds

cancel a job
------------
``cancel_fun_call($ref)``

cancels a previously scheduled $callback

detecting bottlenecks
---------------------
``tc($callback, $args)``

calculate execution time of a $callback with $args
