.. _jaxl-instance:

JAXL Instance
=============
``JAXL`` instance configure/manage other :ref:`sub-packages <jaxl-instance>`.
It provides an event based callback methodology on various underlying object. Whenever required
``JAXL`` instance will itself perform the configured defaults.

Constructor options
-------------------

    #. ``jid``
    #. ``pass``
    #. ``resource``
    
        If not passed Jaxl will use a random resource value
        
    #. ``auth_type``
    
        DIGEST-MD5, PLAIN (default), CRAM-MD5, ANONYMOUS, X-FACEBOOK-PLATFORM
    
    #. ``host``
    #. ``port``
    #. ``bosh_url``
    #. ``log_path``
    #. ``log_level``
    
        ``JAXL_ERROR``, ``JAXL_WARNING``, ``JAXL_NOTICE``, ``JAXL_INFO`` (default), ``JAXL_DEBUG``
        
    #. ``fb_access_token``
    
        required when using X-FACEBOOK-PLATFORM auth mechanism
        
    #. ``fb_app_key``
    
        required when using X-FACEBOOK-PLATFORM auth mechanism
        
    #. ``force_tls``
    #. ``stream_context``
    #. ``priv_dir``
    
        Jaxl creates 4 directories names ``log``, ``tmp``, ``run`` and ``sock`` inside a private directory
        which defaults to ``JAXL_CWD.'/.jaxl'``. If this option is passed, it will overwrite default private
        directory.
        
        .. note::
        
            Jaxl currently doesn't check upon the permissions of passed ``priv_dir``. Make sure Jaxl library 
            have sufficient permissions to create above mentioned directories.

Available Event Callbacks
-------------------------

Following ``$ev`` are available on ``JAXL`` lifecycle for registering callbacks:

    #. ``on_connect``
    
        ``JAXL`` instance has connected successfully
    
    #. ``on_connect_error``
    
        ``JAXL`` instance failed to connect
    
    #. ``on_stream_start``
    
        ``JAXL`` instance has successfully initiated XMPP stream with the jabber server
    
    #. ``on_stream_features``
    
        ``JAXL`` instance has received supported stream features
    
    #. ``on_auth_success``
    
        authentication successful
    
    #. ``on_auth_failure``
    
        authentication failed
    
    #. ``on_presence_stanza``
    
        ``JAXL`` instance has received a presence stanza
    
    #. ``on_{$type}_message``
    
        ``JAXL`` instance has received a message stanza. ``$type`` can be ``chat``, ``groupchat``, ``headline``, ``normal``, ``error``
    
    #. ``on_stanza_id_{$id}``
    
        Useful when dealing with iq stanza. This event is fired when ``JAXL`` instance has received response to a particular
        xmpp stanza id
    
    #. ``on_{$name}_stanza``
    
        Useful when dealing with custom xmpp stanza
    
    #. ``on_disconnect``
    
        ``JAXL`` instance has disconnected from the jabber server

Available Methods
-----------------

Following methods are available on initialized ``JAXL`` instance object:

    #. ``get_pid_file_path()``
    
        returns path of ``JAXL`` instance pid file
    
    #. ``get_sock_file_path()``
    
        returns path to ``JAXL`` ipc unix socket domain
    
    #. ``require_xep($xeps=array())``
    
        autoload and initialize passed XEP's
    
    #. ``add_cb($ev, $cb, $pri=1)``
    
        add a callback to function ``$cb`` on event ``$ev``, returns a reference of added callback
    
    #. ``del_cb($ref)``
    
        delete previously registered event callback
    
    #. ``set_status($status, $show, $priority)``
    
        send a presence status stanza
    
    #. ``send_chat_msg($to, $body, $thread=null, $subject=null)``
    
        send a message stanza of type chat
    
    #. ``get_vcard($jid=null, $cb=null)``
    
        fetch vcard for bare ``$jid``, passed ``$cb`` will be called with received vcard stanza
    
    #. ``get_roster($cb=null)``
    
        fetch roster list of connected jabber client, passed ``$cb`` will be called with received roster stanza
    
    #. ``start($opts=array())``

        start configured ``JAXL`` instance, optionally accepts two options specified below:

        #. ``--with-debug-shell``
        
            start ``JAXL`` instance and enter an interactive console
        
        #. ``--with-unix-sock``

            start ``JAXL`` instance with support for IPC and remote debugging
    
    #. ``send($stanza)``
    
        send an instance of JAXLXml packet over connected socket
    
    #. ``send_raw($data)``
    
        send raw payload over connected socket
        
    #. ``get_msg_pkt($attrs, $body=null, $thread=null, $subject=null, $payload=null)``
    
    #. ``get_pres_pkt($attrs, $status=null, $show=null, $priority=null, $payload=null)``
    
    #. ``get_iq_pkt($attrs, $payload)``