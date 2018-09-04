# iCal Feed for User Plugin Installation

## iCal Feed for User Plugin Installation

1.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
3.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_icaluser/`
4.  Execute the sql file in `client/apps/r_icaluser/sql/r_icaluser.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_icaluser/sql/r_icaluser.sql`
5.  Add the line `rewrite ^/ical/([0-9]*)/([a-z0-9]*).ics$ /server/php/plugins/IcalUser/ical.php?user_id=$1&hash=$2 last;` after `line 23`  in the `restyaboard configuration file` which is in the `/etc/nginx/conf.d` folder and restart the `Nginx` by `systemctl restart nginx`
6.  After above process, clear the browser cache and login again to view the installed iCal Feed for User plugin on your Restyaboard.

## How it works

1.  After login, please click the user profile or user icon in the footer menu and click the `profile` options and it will direct to the        user profile page.
2.  Now click the tab `Cards` and under the tab content, you can see the `Copy iCal User Feed` button.
3.  After clicking the button, the dropdown will appear and the `iCal feed URL` will be in the input and you can copy the url and enter it in the URL for Google calendar option.

