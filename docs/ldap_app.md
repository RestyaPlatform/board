# LDAP plugin installation instructions

## Instructions for ldap plugin configuration

[![How to configure ldap plugin](http://img.youtube.com/vi/hUDezmbD59k/0.jpg)](http://www.youtube.com/watch?v=hUDezmbD59k)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_ldap_login/"
4.  Execute the sql file in "client/apps/r_ldap_login/sql/r_ldap_login.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_ldap_login/sql/r_ldap_login.sql"
5.  Goto "client/apps/r_ldap_login/" directory, to configure the plugin using app.json. Or You can also configure it on "http://{YOUR\_SERVER\_NAME}/#/apps/r_ldap_login" path in your Restyaboard server.
6.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.