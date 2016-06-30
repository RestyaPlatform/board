.. _xml-objects:

Xml Objects
===========
Jaxl library works with custom XML implementation which is similar to 
inbuild PHP XML functions but is lightweight and easy to work with.

JAXLXml
-------
``JAXLXml`` is the base XML object. Open up :ref:`Jaxl interactive shell <jaxl-instance>` and try some xml object creation/manipulation:

    >>> ./jaxlctl shell
    jaxl 1> 
    jaxl 1> $xml = new JAXLXml(
    .......     'dummy', 
    .......     'dummy:packet', 
    .......     array('attr1'=>'friend@gmail.com', 'attr2'=>''), 
    .......     'Hello World!'
    ....... );
    jaxl 2> echo $xml->to_string();
    <dummy xmlns="dummy:packet" attr1="friend@gmail.com" attr2="">Hello World!</dummy>
    jaxl 3>

``JAXLXml`` constructor instance accepts following parameters:

    * ``JAXLXml($name, $ns, $attrs, $text)``
    * ``JAXLXml($name, $ns, $attrs)``
    * ``JAXLXml($name, $ns, $text)``
    * ``JAXLXml($name, $attrs, $text)``
    * ``JAXLXml($name, $attrs)``
    * ``JAXLXml($name, $ns)``
    * ``JAXLXml($name)``

``JAXLXml`` draws inspiration from StropheJS XML Builder class. Below are available methods
for modifying and manipulating an ``JAXLXml`` object:

    * ``t($text, $append=FALSE)`` 
            
            update text of current rover
            
    * ``c($name, $ns=null, $attrs=array(), $text=null)`` 
        
            append a child node at current rover
            
    * ``cnode($node)`` 
        
            append a JAXLXml child node at current rover
            
    * ``up()`` 
        
            move rover to one step up the xml tree
            
    * ``top()`` 
            
            move rover back to top element in the xml tree
            
    * ``exists($name, $ns=null, $attrs=array())`` 
            
            checks if a child with $name exists, return child ``JAXLXml`` if found otherwise false. This function returns at first matching child.
    
    * ``update($name, $ns=null, $attrs=array(), $text=null)``
        
            update specified child element
    
    * ``attrs($attrs)`` 
        
            merge new attrs with attributes of current rover
    
    * ``match_attrs($attrs)`` 
            
            pass a kv pair of ``$attrs``, return bool if all passed keys matches their respective values in the xml packet
    
    * ``to_string()``
        
            get string representation of the object

``JAXLXml`` maintains a rover which points to the current level down the XML tree where
manipulation is performed. 

XMPPStanza
----------
In the world of XMPP where everything incoming and outgoing payload is an ``JAXLXml`` instance code can become nasty,
developers can get lost in dirty XML manipulations spreaded all over the application code base and what not. 
XML structures are not only unreadable for humans but even for machine.

While an instance of ``JAXLXml`` provide direct access to XML ``name``, ``ns`` and ``text``, it can become painful and
time consuming when trying to retrieve or modify a particular ``attrs`` or ``childrens``. I was fed up of doing
``getAttributeByName``, ``setAttributeByName``, ``getChild`` etc everytime i had to access common XMPP Stanza attributes.

``XMPPStanza`` is a wrapper on top of ``JAXLXml`` objects. Preserving all the functionalities of base ``JAXLXml``
instance it also provide direct access to most common XMPP Stanza attributes like ``to``, ``from``, ``id``, ``type`` etc.
It also provides a framework for adding custom access patterns.

``XMPPMsg``, ``XMPPPres`` and ``XMPPIq`` extends ``XMPPStanza`` and also add a few custom access patterns like 
``body``, ``thread``, ``subject``, ``status``, ``show`` etc.

Here is a list of default access patterns:

    #. ``name``
    #. ``ns``
    #. ``text``
    #. ``attrs``
    #. ``childrens``
    #. ``to``
    #. ``from``
    #. ``id``
    #. ``type``
    #. ``to_node``
    #. ``to_domain``
    #. ``to_resource``
    #. ``from_node``
    #. ``from_domain``
    #. ``from_resource``
    #. ``status``
    #. ``show``
    #. ``priority``
    #. ``body``
    #. ``thread``
    #. ``subject``
    

