# Task Move on Due Date Plugin Installation

## Task Move on Due Date Plugin Installation

[![How to configure task move on due date plugin](task_move_on_due_date.png)](https://www.youtube.com/watch?v=9R-tr4eJOcs)

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., "/usr/share/nginx/html/restyaboard/"
3.  Give file permission to extracted files. e.g., "chmod -R 0777 client/apps/r_auto_archive_expired_cards/"
4.  Execute the sql file in "client/apps/r_task_move_on_due_date/sql/r_task_move_on_due_date.sql" using the command "psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_task_move_on_due_date/sql/r_task_move_on_due_date.sql"
5.  After above process, clear the browser cache and login again to view the installed plugins on your Restyaboard.