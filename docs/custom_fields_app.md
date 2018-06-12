# Custom Field plugin installation instructions

## Instructions for custom field plugin configuration

[![How to configure custom field plugin](http://img.youtube.com/vi/Vuctbli0wZQ/0.jpg)](http://www.youtube.com/watch?v=Vuctbli0wZQ)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_custom_fields/"
4.  Execute the sql file in "client/apps/r_custom_fields/sql/r_custom_fields.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_custom_fields/sql/r_custom_fields.sql"
5.  Goto "client/apps/r_custom_fields/" directory, to configure the plugin using app.json.
6.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.

## Creation of custom field

1.  For creating custom field, goto "http://{YOUR\_SERVER\_NAME}/#/apps/r_custom_fields/manage" path in your Restyaboard server and click "Add Field" and fill the details of custom field in the form and check the "Card Front Badge" checkbox for showing the custom field value infornt of the card and then click "Add" 
2.  Now, the custom field will be created. Goto any particular "board" page and click any "card", you can see the "custom field button" in the "modal card" and click the custom field button and give information to the custom field form and click "save" 
3.  Now, the custom field value will be shown in the modal card and if you check the "Card Front Badge" checkbox on the custom field, then it will be shown infront of the card 