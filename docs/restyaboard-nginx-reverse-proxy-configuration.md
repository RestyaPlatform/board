---
description: Configuration of Restyaboard on an NGINX Reverse proxy
---

# Configuration of Restyaboard on an NGINX Reverse proxy

## Configuration of Restyaboard on an NGINX Reverse proxy

* For configuring Restyaboard on a Nginx Reverse proxy, you have to set Host header:

**Example**

location / {
  proxy_set_header Host $host;  # important
  proxy_pass http://localhost:8000;
}
