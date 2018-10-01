# Download all attachments in Card Plugin Installation

## Download all attachments in Card Plugin Installation

**Requirement**
-   `PHP ZIP` should be installed for downloading all attachments of the card in the zip file format.

1.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
3.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_download_all_attachments_in_card/`
4.  Execute the sql file in `client/apps/r_download_all_attachments_in_card/sql/r_download_all_attachments_in_card.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_download_all_attachments_in_card/sql/r_download_all_attachments_in_card.sql`
5.  Add the line `rewrite ^/download/([0-9]*)/([0-9]*)/([a-z0-9]*)$ /server/php/plugins/DownloadAllAttachments/download.php?board_id=$1&card_id=$2&hash=$3 last;` after `line 23`  in the `restyaboard configuration file` which is in the `/etc/nginx/conf.d` folder and restart the `Nginx` by `systemctl restart nginx`
6.  After above process, clear the browser cache and login again to view the installed `Download all attachments in Card plugin on your Restyaboard`.

## How it works

1.  If the card has the attachments, then  infront of the card, there is an `download icon` for downloading all attachments of the card.
2.  In the `modal card` page, near the `Attachment` header there will be `download icon` for downloading all attachments of the card.