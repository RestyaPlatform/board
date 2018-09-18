# General Plugin Installaion

## General Instructions for Plugin Configuration

[![General plugin installaion](plugin_installation.png)](https://www.youtube.com/watch?v=AWqxxY9zG7g)

Please click the image for watching General Plugin Installaion in Restyaboard

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., If you purchase the Dashboard charts plugin then you need to give file permission extracted files which are in "client/apps/r_chart/" path. e.g., "chmod -R 0777 client/apps/r_chart/"
4.  Run the sql file in the apps sql folder.
5.  Goto "http://{YOUR\_SERVER\_NAME}/#/apps/{YOUR_PLUGIN}" path in your Restyaboard server to configure the plugin.
6.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.

## Instructions for Specific Plugin Configuration

1.  Some plugins are having shell script to install its required softwares. e.g., ElasticSearch and Chat. For ElasticSearch plugin, elasticsearch.sh file wrapped with zip and for Chat plugins, chat.sh file wrapped with zip
2.  It'll be available on your restyaboard root directory after extracted the plugin zip. And also give permisison to that script file using "chmod +x {SHELL_SCRIPT_FILE}"
3.  Execute the script file on terminal using "./{SHELL_SCRIPT_FILE}"
4.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.