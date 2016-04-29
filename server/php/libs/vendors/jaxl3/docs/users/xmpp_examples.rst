XMPP Examples
=============

Echo Bot Client
---------------
include ``jaxl.php`` and initialize a new ``JAXL`` instance:

.. code-block:: ruby

    require 'jaxl.php';
    $client = new JAXL(array(
        'jid' => 'user@domain.tld',
        'pass' => 'password'
    ));

We just initialized a new ``JAXL`` instance by passing our jabber client ``jid`` and ``pass``.

View list of :ref:`available options <jaxl-instance>` that can be passed to ``JAXL`` constructor.

Next we need to register callbacks on events of interest using ``JAXL::add_cb/2`` method as shown below:

.. code-block:: ruby

    $client->add_cb('on_auth_success', function() {
        global $client;
        $client->set_status("available!");  // set your status
        $client->get_vcard();               // fetch your vcard
        $client->get_roster();              // fetch your roster list
    });
    
    $client->add_cb('on_chat_message', function($msg) {
        global $client;
        
        // echo back
        $msg->to = $msg->from;
        $msg->from = $client->full_jid->to_string();
        $client->send($msg);
    });
    
    $client->add_cb('on_disconnect', function() {
        _debug("got on_disconnect cb");
    });

We just registered callbacks on ``on_auth_success``, ``on_chat_message`` and ``on_disconnect`` events 
that will occur inside our configured ``JAXL`` instance lifecycle. 
We also passed a method that will be called (with parameters if any) when the event has been detected.

See list of :ref:`available event callbacks <jaxl-instance>` that we can hook to inside ``JAXL`` instance lifecycle.

Received ``$msg`` parameter with ``on_chat_message`` event callback above, will be an instance of ``XMPPMsg`` which
extends ``XMPPStanza`` class, that allows us easy to use access patterns to common XMPP stanza attributes like 
``to``, ``from``, ``type``, ``id`` to name a few.

We were also able to access our xmpp client full jabber id by calling ``$client->full_jid``. This attribute of
``JAXL`` instance is available from ``on_auth_success`` event. ``full_jid`` attribute is an instance of ``XMPPJid``.

To send our echo back ``$msg`` packet we called ``JAXL::send/1`` which accepts a single parameter which MUST be
an instance of ``JAXLXml``. Since ``XMPPStanza`` is a wrapper upon ``JAXLXml`` we can very well pass our modified 
``$msg`` object to the send method.

Read more about various :ref:`XML Objects <xml-objects>` and how they make writing XMPP applications fun and easy.
You can also :ref:`add custom access patterns <xml-objects>` upon received ``XMPPStanza`` objects. Since all access
patterns are evaluated upon first access and cached for later usage, adding hundreds of custom access patterns that
retrieves information from 100th child of received XML packet will not be an issue.

We will finally start our xmpp client by calling:

.. code-block:: ruby

    $client->start();

See list of :ref:`available options <jaxl-instance>` that can be passed to the ``JAXL::start/2`` method.
These options are particularly useful for debugging and monitoring.

Echo Bot BOSH Client
--------------------
Everything goes same for a cli BOSH client. To run above echo bot client example as a bosh client simply 
pass additional parameters to ``JAXL`` constructor:

.. code-block:: ruby

    require 'jaxl.php';
    $client = new JAXL(array(
        'jid' => 'user@domain.tld',
        'pass' => 'password',
        'bosh_url' => 'http://localhost:5280/http-bind'
    ));

You can even pass custom values for ``hold``, ``wait`` and other attributes.

View list of :ref:`available options <jaxl-instance>` that can be passed to ``JAXL`` constructor.

Echo Bot External Component
---------------------------
Again almost everything goes same for an external component except a few custom ``JAXL`` constructor 
parameter as shown below:

.. code-block:: ruby

    require_once 'jaxl.php';
    $comp = new JAXL(array(
        // (required) component host and secret
        'jid' => $argv[1],
        'pass' => $argv[2],
        
        // (required) destination socket
        'host' => $argv[3],
        'port' => $argv[4]
    ));

We will also need to include ``XEP0114`` which implements Jabber Component XMPP Extension.

.. code-block:: ruby
    
    // (required)
    $comp->require_xep(array(
        '0114' // jabber component protocol
    ));

``JAXL::require_xep/1`` accepts an array of XEP numbers passed as strings.
