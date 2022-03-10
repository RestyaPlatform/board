---
description: Restyaboard Configuration, here you can check Configuration of Restyaboard on an NGINX
---

# Configuration of Restyaboard on an NGINX

## Configuration of Restyaboard on an NGINX Reverse proxy

* For configuring Restyaboard on a Nginx Reverse proxy, you have to set Host header:

**Example**
```
location / {
  proxy_set_header Host $host;  # important
  proxy_pass http://localhost:8000;
}
```

## Configuration of rate limiting on Nginx

* You can limit the request on the Nginx configuration by adding limit request on the configuration file

**Example**
```
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s;
```

* Also, you need to add the limit request on the `location` block

**Example**
```
location / {
  limit_req zone=mylimit;
}
```

## Configuration of Diagnose with password authentication

* You can enable the password authentication for the diagnose page by adding the below lines

**Example**
```
  location /diagnose.php {
    auth_basic "Restricted Area";
    auth_basic_user_file  /usr/share/nginx/html/.htpasswd;
    try_files $uri =404;
    include fastcgi_params;
    fastcgi_pass	unix:/run/php/php7.4-fpm.sock;
    fastcgi_index   index.php;
    fastcgi_param	SCRIPT_FILENAME $document_root$fastcgi_script_name;
  }
```

* You can configure the password authentication for the diagnose page in the Apache server by following the instructions from the [link](https://stackoverflow.com/a/8275094)

* You can check the status of the Restyaboard in the diagnose and you can access the diagnose page using the username `restya`, password `restya123`

* You can also configure the different password in the Nginx server configuration for the diagnose page by following the instructions from the link [https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/)

* You can also configure the different password in the Apache server configuration for the diagnose page by following the instructions from the link [https://www.web2generators.com/apache-tools/htpasswd-generator](https://www.web2generators.com/apache-tools/htpasswd-generator)