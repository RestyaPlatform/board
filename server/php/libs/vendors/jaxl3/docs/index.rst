Welcome to Jaxl's documentation!
================================
Jaxl v3.x is a successor of v2.x (and is NOT backward compatible), 
carrying a lot of code from v2.x while throwing away the ugly parts.
A lot of components have been re-written keeping in mind the feedback from
the developer community over the last 4 years. Also Jaxl now shares a few
philosophies from my experience with erlang and python languages.

Jaxl is an asynchronous, non-blocking I/O, event based PHP library 
for writing custom TCP/IP client and server implementations. 
From it's previous versions, library inherits a full blown stable support 
for XMPP protocol stack. In v3.0, support for HTTP protocol stack was 
also added.

At the heart of every protocol stack sits a Core stack. It contains all the 
building blocks for everything that we aim to do with Jaxl library. Both 
XMPP and HTTP protocol stacks are written on top of the Core stack. Infact 
the source code of protocol implementations knows nothing about the 
standard (inbuilt) PHP socket and stream methods.

Users Guide
------------

.. toctree::
   :maxdepth: 2

   users/getting_started
   users/jaxl_instance
   users/jaxlctl
   users/logging
   users/cron_jobs

XMPP Users Guide:
-----------------

.. toctree::
   :maxdepth: 2
   
   users/xmpp_examples
   users/xml_objects
   users/xmpp_extensions

HTTP Users Guide:
-----------------

.. toctree::
   :maxdepth: 2
   
   users/http_examples
   users/http_extensions
   