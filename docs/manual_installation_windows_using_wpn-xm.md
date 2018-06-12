# Manual installation in windows using wpn-xm

## Instructions for manual installation in windows using wpn-xm


**Please find the steps that I have followed in Windows XP:**

*  Install nginx, postgresql, adminer, Pickle, Fake Sendmail, WPN-XM - Service Control Panel, WPN-XM Webinterface using 

[https://github.com/WPN-XM/WPN-XM](https://github.com/WPN-XM/WPN-XM "https://github.com/WPN-XM/WPN-XM") at "D:\server"

*  Download latest built file from 

[https://github.com/RestyaPlatform/board/releases](https://github.com/RestyaPlatform/board/releases "https://github.com/RestyaPlatform/board/releases") (board-v0.6.2.zip) and place it in `D:\server\www\restyaboard`

* For Apache: 

`https://github.com/RestyaPlatform/board/blob/master/.htaccess#L7` Change `RewriteBase / to RewriteBase /your_local_folder/`

* For nginx:

`https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf` \- Change root directory in nginx configuration also,
`https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf#L3`  \- Change the server_name to restyaboard.localhost 
`https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf#L21` \- Add your local folder name in rewrite rules

*  Place attached 

[https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf](https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf "https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf") in `D:\server\bin\nginx\conf\domains-enabled`. Notice the changes in fastcgi_pass

## Changes in configuration file 


***Change your config file** `fastcgi_pass unix:/var/run/php5-fpm.sock;` **to** `fastcgi_pass 127.0.0.1:9000;`

**Prepare PostgreSQL with below (this could have been done better):**
    
    D:\server\bin\pgsql\bin>createuser -s -d -r postgres
    D:\server\bin\pgsql\bin>createdb -h localhost -U postgres restyaboard 
    D:\server\bin\pgsql\bin>psql -h localhost -U postgres
    
    CREATE USER restya WITH PASSWORD 'hjVl2!rGd';
    ALTER DATABASE restyaboard OWNER TO restya;   
    GRANT ALL PRIVILEGES ON DATABASE restyaboard TO restya;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO restya;  
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO restya;
    
    D:\server\bin\pgsql\bin>psql -h localhost -d restyaboard -U restya -W < d:\server\www\restyaboard\sql\restyaboard_with_empty_data.sql
    
**Visit** 

[http://localhost/tools/webinterface/index.php?page=config#php-ext](http://localhost/tools/webinterface/index.php?page=config#php-ext "http://localhost/tools/webinterface/index.php?page=config#php-ext") to enable curl, gd2, ldap, mobstring, pdo_pgsql, pgsql extensions.

*  Start nginx, php, postgresql through WPN-XM Service Control Panel. If they're already running, restart them.
*  Restyaboard is up and running at below link

[http://localhost:8084/](http://localhost:8084/ "http://localhost:8084/")