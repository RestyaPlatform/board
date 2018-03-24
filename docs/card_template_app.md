# Card Template plugin installation instructions

## Instructions for card template plugin configuration

[![How to configure card template plugin](http://img.youtube.com/vi/Hu9hNv9wFyQ/0.jpg)](http://www.youtube.com/watch?v=Hu9hNv9wFyQ)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_card_template/"
4.  Execute the sql file in "client/apps/r_card_template/sql/r_card_template.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_card_template/sql/r_card_template.sql"
5.  Goto "client/apps/r_card_template/" directory, to configure the plugin using app.json.
6.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.