# LDAP Plugin Installation

## LDAP Plugin Installation

[![How to configure ldap plugin](ldap_installation.png)](http://www.youtube.com/watch?v=g5SzFy4n4u4)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_ldap_login/"
4.  Execute the sql file in "client/apps/r_ldap_login/sql/r_ldap_login.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_ldap_login/sql/r_ldap_login.sql"
5.  Goto "client/apps/r_ldap_login/" directory, to configure the plugin using app.json. Or You can also configure it on "http://{YOUR\_SERVER\_NAME}/#/apps/r_ldap_login" path in your Restyaboard server.
6.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.