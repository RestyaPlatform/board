./jaxlctl
=========
Usage: ``./jaxlctl command [options...]``

``jaxlctl`` is a control script that can be seen as a useful tool for:

    * debugging daemons running in the background
    * customize daemons on the fly
    * monitoring daemons
    * as a playground for learning XMPP/HTTP and Jaxl library itself

Type ``./jaxlctl help`` to see list of available commands.

.. note::
    
    Various commands are still experimental. Know what you are doing before
    using them in production. You have been warned !!!

Interactive Shell
------------------

    >>> ./jaxlctl shell
    jaxl 1>
    jaxl 1> // create a test message object
    jaxl 1> $msg = new XMPPMsg(array('to'=>'friend@gmail.com'), 'Hello World!');
    jaxl 2>
    jaxl 2> // object to string conversion
    jaxl 2> print_r($msg->to_string());
    <message to="friend@gmail.com"><body>Hello World!</body></message>
    jaxl 3> 

Debug Running Instances
------------------------

    >>> ./jaxlctl attach XXXXX
    jaxl 1>
    jaxl 1> // create a message to be sent
    jaxl 1> $msg = new XMPPMsg(array('to'=>'friend@gmail.com'), 'Hello World!');
    jaxl 2>
    jaxl 2> // this client is from the echo bot example
    jaxl 2> global $client;
    jaxl 3> 
    jaxl 3> // send the message packet
    jaxl 3> $client->send($msg);
    jaxl 4>
    jaxl 4> // or we can directly do
    jaxl 4> $client->send_chat_msg('friend@gmail.com', 'Hello World!');
    jaxl 5>

Where ``XXXXX`` is the pid of running ``JAXL`` instance.
