# Report View Plugin Installation

## Report View Plugin Installation

1.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
3.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_report_view/`
4.  Execute the sql file in `client/apps/r_report_view/sql/r_report_view.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_report_view/sql/r_report_view.sql`
6.  After above process, clear the browser cache and login again to view the installed Report View plugin on your Restyaboard.