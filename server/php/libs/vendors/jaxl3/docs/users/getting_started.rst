Getting Started
===============

Requirements
------------
No external component or library is required.
You simply need a standard PHP installation to work with Jaxl.

Library has been developed and tested extensively on 
linux operating systems. But there is no reason why it should
not work on other OS. File an `issue <https://github.com/abhinavsingh/JAXL/issues/new>`_ if you face any glitches.

Download & Install
------------------
Download a stable tagged v3.x release from `https://github.com/abhinavsingh/JAXL/tags <https://github.com/abhinavsingh/JAXL/tags>`_

You can also checkout git branch and switch to a tag of your choice:

    >>> git clone git://github.com/abhinavsingh/JAXL.git
    >>> cd JAXL/
    >>> git tag -l
    >>> git checkout some-tag-name

To install Jaxl library globally, simply append path of the downloaded ``JAXL`` folder
to ``include_path`` directive inside your ``php.ini``. This will allow us to use Jaxl 
library simply by doing:

``require 'jaxl.php';`` 

Alternately, if you don't want to edit ``php.ini`` or in case you don't have 
access to the ini file, simply use:

``require '/full/path/to/JAXL/jaxl.php';``

to start using Jaxl library.

Library Structure
-----------------
Jaxl library comprises of following packages:

    * ``jaxl-core``
        
            contains generic networking and eventing components
            
    * ``jaxl-xmpp``
        
            contains xmpp rfc implementation
            
    * ``jaxl-xmpp-xep``
        
            contains various xmpp xep implementation
            
    * ``jaxl-http``
        
            contains http rfc implementation
            
    * ``jaxl-docs``
        
            this documentation comes from this package
            
    * ``jaxl-tests``
        
            test suites for all the above packages

Inside Jaxl everything that you will interact with will be an object which 
will emit events and callbacks which we will be able to catch in our applications 
for custom processing and routing. Listed below are a few main objects:

    #. Core Stack
    
      * ``JAXLLoop``
        
            main select loop
            
      * ``JAXLClock``
        
            timed job/callback dispatcher
            
      * ``JAXLEvent``
        
            event registry and emitter
            
      * ``JAXLFsm``
        
            generic finite state machine
            
      * ``JAXLSocketClient``
        
            generic tcp/udp client
            
      * ``JAXLSocketServer``
        
            generic tcp/udp server
            
      * ``JAXLXmlStream``
        
            streaming XML parser
            
      * ``JAXLXml``
        
            custom XML object implementation
            
      * ``JAXLLogger``
        
            logging facility
    
    #. XMPP Stack
    
      * ``XMPPStream``
        
            base xmpp rfc implementation
            
      * ``XMPPStanza``        
        
            provides easy access patterns over xmpp stanza (wraps ``JAXLXml``)
            
      * ``XMPPIq``            
        
            xmpp iq stanza object (extends ``XMPPStanza``)
            
      * ``XMPPMsg``           
        
            xmpp msg stanza object (extends ``XMPPStanza``)
            
      * ``XMPPPres``          
        
            xmpp pres stanza object (extends ``XMPPStanza``)
            
      * ``XMPPXep``           
        
            abstract xmpp extension (extended by XEP implementations)
            
      * ``XMPPJid``           
        
            xmpp jid object
        
    #. HTTP Stack
        
      * ``HTTPServer``        
        
            http server implementation
            
      * ``HTTPClient``        
        
            http client implementation
            
      * ``HTTPRequest``       
        
            http request object
            
      * ``HTTPResponse``      
        
            http response object

Questions, Bugs and Issues
--------------------------
If you have any questions kindly post them on `google groups <https://groups.google.com/forum/#!forum/jaxl>`_. Groups are the quickest
way to get an answer to your questions which is actively monitored by core developers.

If you are facing a bug or issue, please report that it on `github issue tracker <https://github.com/abhinavsingh/JAXL/issues/new>`_.
You can even :ref:`contribute to the library <developer-introduction>` if you already have fixed the bug.
