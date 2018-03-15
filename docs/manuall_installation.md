# Manual Installation

## Instructions

1.  Download script from "https://github.com/RestyaPlatform/board/releases", and choose the latest version. e.g., "https://github.com/RestyaPlatform/board/releases/download/v0.5.2/board-v0.5.2.zip"
2.  Extract the zip into your apache server root folder. e.g., "/xxx/public_html/"
3.  Create database using the command "psql -U {{YOUR POSTGRES DATABASE USER}} -c 'create database restyaboard'"
4.  Import SQL using the command "psql -h localhost -d restyaboard -U {{YOUR POSTGRES DATABASE USER}} -W < 'restyaboard_with_empty_data.sql'"
5.  Change the database credentials in "server/php/config.inc.php"

        define('R_DB_USER', 'restya');
        define('R_DB_PASSWORD', 'hjVl2!rGd');
   

    
6.  Give write permission to following directories: `media, tmp/cache, server/php/shell/*.sh & client/img;` can be chmod 655 or 755 or 777 depending upon your server configuration
7.  Use this .htaccess to run it in Apache `https://github.com/RestyaPlatform/board/blob/master/.htaccess`
8.  Write following crons in crontab using '`crontab -e`' command

       */5 * * * * /var/www/html/restyaboard/server/php/shell/instant_email_notification.sh
       0 * * * * /var/www/html/restyaboard/server/php/shell/periodic_email_notification.sh
       */30 * * * * /var/www/html/restyaboard/server/php/shell/imap.sh
       */5 * * * * /var/www/html/restyaboard/server/php/shell/webhook.sh
       */5 * * * * /var/www/html/restyaboard/server/php/shell/card_due_notification.sh
   

    