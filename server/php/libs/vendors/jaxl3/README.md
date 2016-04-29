Jaxl v3.x:
-----------
Jaxl v3.x is a successor of v2.x (and is NOT backward compatible), 
carrying a lot of code from v2.x while throwing away the ugly parts.
A lot of components have been re-written keeping in mind the feedback from
the developer community over the last 4 years. Also Jaxl shares a few
philosophies from my experience with erlang and python languages.

Jaxl is an asynchronous, non-blocking I/O, event based PHP library 
for writing custom TCP/IP client and server implementations. 
From it's previous versions, library inherits a full blown stable support 
for [XMPP protocol stack](https://github.com/abhinavsingh/JAXL/tree/v3.x/xmpp). 
In v3.0, support for [HTTP protocol stack](https://github.com/abhinavsingh/JAXL/tree/v3.x/http) 
has also been added.

At the heart of every protocol stack sits the [Core stack](https://github.com/abhinavsingh/JAXL/tree/v3.x/core).
It contains all the building blocks for everything that we aim to do with Jaxl library. 
Both XMPP and HTTP protocol stacks are written on top of the Core stack. 
Infact the source code of protocol implementations knows nothing 
about the standard (inbuilt) PHP socket and stream methods.

[Examples](https://github.com/abhinavsingh/JAXL/tree/v3.x/examples/)

[Documentation](http://jaxl.readthedocs.org/)

[Group and Mailing List](https://groups.google.com/forum/#!forum/jaxl)

[Create a bug/issue](https://github.com/abhinavsingh/JAXL/issues/new)

[Author](http://abhinavsingh.com/)
