# ElasticSearch plugin installation instructions

## Instructions for elasticsearch plugin configuration

[![How to configure elasticsearch plugin](http://img.youtube.com/vi/4ra-PhePZpg/0.jpg)](http://www.youtube.com/watch?v=4ra-PhePZpg)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_elasticsearch/"
4.  Execute "chmod +x elasticsearch.sh" command
5.  Start elasticsearch by using "./elasticsearch.sh" command
6.  Goto "client/apps/r_elasticsearch/" directory, to configure the plugin using app.json. Or You can also configure it on "http://{YOUR\_SERVER\_NAME}/#/apps/r_elasticsearch" path in your Restyaboard server.
7.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.