HTTP Examples
=============

Writing HTTP Server
-------------------
Intialize an ``HTTPServer`` instance

.. code-block:: ruby

    require_once 'jaxl.php';
    require_once JAXL_CWD.'/http/http_server.php';
    $http = new HTTPServer();

By default ``HTTPServer`` will listen on port 9699. You can pass a port number as first parameter to change this.

Define a callback method that will accept all incoming ``HTTPRequest`` objects

.. code-block:: ruby

    function on_request($request) {
        if($request->method == 'GET') {
            $body = json_encode($request);
            $request->ok($body, array('Content-Type'=>'application:json'));
        }
        else {
            $request->not_found();
        }
    }

``on_request`` callback method will receive a ``HTTPRequest`` object instance.
For this example, we will simply echo back json encoded ``$request`` object for 
every http GET request.

Start http server:

.. code-block:: ruby

    $http->start('on_request');
    
We pass ``on_request`` method as first parameter to ``HTTPServer::start/1``.
If nothing is passed, requests will fail with a default 404 not found error message

Writing REST API Server
-----------------------
Intialize an ``HTTPServer`` instance

.. code-block:: ruby

    require_once 'jaxl.php';
    require_once JAXL_CWD.'/http/http_server.php';
    $http = new HTTPServer();

By default ``HTTPServer`` will listen on port 9699. You can pass a port number as first parameter to change this.

Define our REST resources callback methods:

.. code-block:: ruby

    function index($request) {
        $request->send_response(
            200, array('Content-Type'=>'text/html'), 
            '<html><head/><body><h1>Jaxl Http Server</h1><a href="/upload">upload a file</a></body></html>'
        );
        $request->close();
    }
    
    function upload($request) {
        if($request->method == 'GET') {
            $request->send_response(
                200, array('Content-Type'=>'text/html'),
                '<html><head/><body><h1>Jaxl Http Server</h1><form enctype="multipart/form-data" method="POST" action=""><input type="file" name="file"/><input type="submit" value="upload"/></form></body></html>'
            );
        }
        else if($request->method == 'POST') {
            if($request->body === null && $request->expect) {
                $request->recv_body();
            }
            else {
                // got upload body, save it
                _debug("file upload complete, got ".strlen($request->body)." bytes of data");
                $request->close();
            }
        }
    }
    
Next we need to register dispatch rules for our callbacks above:

.. code-block:: ruby

    $index = array('index', '^/$');
    $upload = array('upload', '^/upload', array('GET', 'POST'));
    $rules = array($index, $upload);
    $http->dispatch($rules);

Start REST api server:

.. code-block:: ruby

    $http->start();

Make an HTTP request
--------------------
