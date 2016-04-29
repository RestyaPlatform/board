HTTP Extensions
===============

Dispatch Rules
--------------
Dispatch rules are convinient way of redirecting callback for a specific request pattern to a custom
methods inside your application. A dispatch rule consists of following 4 match information:

    * ``$callback`` 
    
        reference to a method that will be callback'd when a matching request is received
    
    * ``$pattern`` 
        
        a regular expression for matching on url path
        
    * ``$methods``
    
        (optional) if not specified rule will match for all HTTP Methods.
        if specified, must be an array of HTTP Method in uppercase.
    
    * ``$extra``
    
        (reserved) this is for future where we will allow matching on 
        headers, session, cookies etc.

Below are a few examples of dispatch rules:

.. code-block:: ruby

    $index = array('serve_index_page', '^/');
    $upload_form = array('serve_upload_form', '^/upload', array('GET'));
    $upload_handler = array('handle_upload_form', '^/upload', array('POST'));

Some REST CRUD dispatch rules:

.. code-block:: ruby

    $event_create = array('create_event', '^/event/create/$', array('PUT'));
    $event_read = array('read_event', '^/event/(?P<pk>\d+)/$', array('GET', 'HEAD'));
    $event_update = array('update_event', '^/event/(?P<pk>\d+)/$', array('POST'));
    $event_delete = array('delete_event', '^/event/(?P<pk>\d+)/$', array('DELETE'));

Finally don't forget to active these dispatch rules by doing:

.. code-block:: ruby

    $rules = array($index, $upload_form, $upload_handler, $event_create, $event_read, $event_update, $event_delete);
    $http->dispatch($rules);
