# Board Roles Plugin Installation

## Board Roles Plugin Installation

[![How to configure Board Roles plugin](custom_field_installation.png)](http://www.youtube.com/watch?v=xCf4Thk3AmA)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_board_roles/"
4.  Execute the sql file in "client/apps/r_board_roles/sql/r_board_roles.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_board_roles/sql/r_board_roles.sql"
6.  After above process, clear the browser cache and login again to view the installed Board Roles plugin on your Restyaboard.

## Creation of Board Roles

1.  For creating Board Roles, goto "http://{YOUR\_SERVER\_NAME}/#/roles" path in your Restyaboard server and in the content of the "Users" tab, list of boards will be listed with board roles in the user roles column
2.  Now, for assigning the roles , please click the one of the select option in the user roles column of the particular board