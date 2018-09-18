# Download all attachments in Card Plugin Installation

## Download all attachments in Card Plugin Installation

[![How to configure Download all attachments in Card plugin](custom_field_installation.png)](http://www.youtube.com/watch?v=xCf4Thk3AmA)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_download_all_attachments_in_card/"
4.  Add the line "rewrite ^/download/([0-9]*)/([0-9]*)/([a-z0-9]*)$ /server/php/plugins/DownloadAllAttachments/download.php?board_id=$1&card_id=$2&hash=$3 last;" after line 23  in the restyaboard configuration file which is in the "/etc/nginx/conf.d"
5.  After the above process, restart the "Nginx" by executing "systemctl restart nginx". 
5.  Execute the sql file in "client/apps/r_download_all_attachments_in_card/sql/r_download_all_attachments_in_card.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_download_all_attachments_in_card/sql/r_download_all_attachments_in_card.sql"
6.  After above process, clear the browser cache and login again to view the installed Download all attachments in Card plugin on your Restyaboard.

## Creation of Download all attachments in Card

1.  For creating Download all attachments in Card, goto "http://{YOUR\_SERVER\_NAME}/#/roles" path in your Restyaboard server and in the content of the "Users" tab, list of boards will be listed with Download all attachments in Card in the user roles column
2.  Now, for assigning the roles , please click the one of the select option in the user roles column of the particular board