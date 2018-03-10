## Restyaboard Windows


**Please find the steps that I have followed in Windows XP:**

1.  Install nginx, postgresql, adminer, Pickle, Fake Sendmail, WPN-XM - Service Control Panel, WPN-XM Webinterface using [https://github.com/WPN-XM/WPN-XM](https://github.com/WPN-XM/WPN-XM "https://github.com/WPN-XM/WPN-XM") at `D:\server`
2.  Download latest built file from [https://github.com/RestyaPlatform/board/releases](https://github.com/RestyaPlatform/board/releases "https://github.com/RestyaPlatform/board/releases") (board-v0.1.6.zip) and place it in `D:\server\www\restyaboard`

1.  For Apache: `https://github.com/RestyaPlatform/board/blob/master/.htaccess#L7` Change `RewriteBase / to RewriteBase /your_local_folder/`
2.  For nginx: `https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf` \- Change root directory in nginx configuration also, `https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf#L21` \- Add your local folder name in rewrite rules

4.  Place attached [https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf](https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf "https://github.com/RestyaPlatform/board/blob/master/restyaboard.conf") in `D:\server\bin\nginx\conf\domains-enabled`. Notice the changes in fastcgi_pass
5.  Change your config file `fastcgi_pass unix:/var/run/php5-fpm.sock;` to `fastcgi_pass 127.0.0.1:9000;
`root C:/Nginx/html/restyboard;  
`
`index index.html index.php;  

`
`gzip on;  
`
`gzip_disable "msie6";  

`
`gzip_comp_level 6;  
`
`# gzip_comp_level 9;  
`
`gzip_min_length 1100;  
`
`gzip_buffers 16 8k;  
`
`gzip_proxied any;  
`
`# gzip_http_version 1.1;  
`
`gzip_types text/plain application/xml text/css text/js text/xml application/x-javascript  
text/javascript application/json application/xml+rss;  

`
`client_max_body_size 300M;  

`
`rewrite ^/download/([0-9]*)/([a-zA-Z0-9_\.]*)$ /server/php/R/download.php?id=$1&hash=$2 last;  
`
`rewrite ^/ical/([0-9]*)/([a-z0-9]*).ics$ /server/php/R/ical.php?id=$1&hash=$2 last;  
`
`rewrite ^/api/(.*)$ /server/php/R/r.php?_url=$1&$args last;  

`
`location / {  
`
`root C:/Nginx/html/restyboard/client;  
`
`}  

`
`location ~ \.php$ {  
`
`try_files $uri =404;  
`
`include fastcgi_params;  
`
`fastcgi_pass 127.0.0.1:9000;  
`
`fastcgi_index index.php;  
`
`fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  
`
`fastcgi_param PHP_VALUE "upload_max_filesize = 300M \n post_max_size=301M";  
`
`}  

`
`location ~* \.(css|js|less|html|ttf|woff|jpg|jpeg|gif|png|bmp|ico) {  
`
`root C:/Nginx/html/restyboard/client;  
`
`if (-f $request_filename) {  
`
`break;  
`
`}  
`
`rewrite ^/img/([a-zA-Z_]*)/([a-zA-Z_]*)/([a-zA-Z0-9_\.]*)$ /server/php/R/image.php?size=$1&model=$2&filename=$3 last;  
`
`add_header Cache-Control public;  
`
`add_header Cache-Control must-revalidate;  
`
`expires 7d;  
`
`}  

`
`42.  Prepare PostgreSQL with below (this could have been done better):
    
    `D:\server\bin\pgsql\bin>createuser -s -d -r postgres` `D:\server\bin\pgsql\bin>createdb -h localhost -U postgres restyaboard` `D:\server\bin\pgsql\bin>psql -h localhost -U postgres`
    
    `CREATE USER restya WITH PASSWORD 'hjVl2!rGd';``ALTER DATABASE restyaboard OWNER TO restya;`  
    `GRANT ALL PRIVILEGES ON DATABASE restyaboard TO restya;``GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO restya;`  
    `GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO restya;`
    
    `D:\server\bin\pgsql\bin>psql -h localhost -d restyaboard -U restya -W < d:\server\www\restyaboard\sql\restyaboard_with_empty_data.sql`
    
43.  Visit [http://localhost/tools/webinterface/index.php?page=config#php-ext](http://localhost/tools/webinterface/index.php?page=config#php-ext "http://localhost/tools/webinterface/index.php?page=config#php-ext") to enable curl, gd2, ldap, mobstring, pdo_pgsql, pgsql extensions.
44.  Start nginx, php, postgresql through WPN-XM Service Control Panel. If they're already running, restart them.
45.  Restyaboard is up and running at [http://localhost:8084/](http://localhost:8084/ "http://localhost:8084/")