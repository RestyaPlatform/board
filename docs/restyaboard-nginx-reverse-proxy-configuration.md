---
description: Restyaboard Configuration, here you can check Configuration of Restyaboard on an NGINX Reverse proxy
---

# Configuration of Restyaboard on an NGINX Reverse proxy

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