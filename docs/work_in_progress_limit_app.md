# Work In Progress Limit Plugin Installation

## Work In Progress Limit Plugin Installation

1.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
3.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_wip_limit/`
4.  Execute the sql file in `client/apps/r_wip_limit/sql/r_wip_limit.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_wip_limit/sql/r_wip_limit.sql`
6.  After above process, clear the browser cache and login again to view the installed Work In Progress Limit plugin on your Restyaboard.