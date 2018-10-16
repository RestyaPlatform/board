# Auto Archive Expired Cards Plugin Installation

## Auto Archive Expired Cards Plugin Installation

[![How to configure auto archive expired cards plugin](auto_archive_expired_cards.png)](http://www.youtube.com/watch?v=dVmgj_EzFsY)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_auto_archive_expired_cards/"
4.  Execute the sql file in "client/apps/r_auto_archive_expired_cards/sql/r_auto_archive_expired_cards.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_auto_archive_expired_cards/sql/r_auto_archive_expired_cards.sql"
5.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.