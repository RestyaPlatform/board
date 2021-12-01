---
description: LDAP Plugin Installation
---

# LDAP Plugin Installation

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install LDAP plugin in the Restyaboard.

### What you'll learn

*   How to install the LDAP plugin in the Restyaboard?

## Video Tutorial

For step-by-step instructions on LDAP Plugin Installation, refer [YouTube video](https://www.youtube.com/watch?v=g5SzFy4n4u4 "Watch video on LDAP Plugin Installation")

[![LDAP Plugin Installation](ldap_installation.png "LDAP Plugin Installation")](https://www.youtube.com/watch?v=g5SzFy4n4u4 "Watch video on LDAP Plugin Installation")  

## LDAP Plugin Installation

1.  Download [LDAP app](https://restya.com/board/apps/r_ldap_login "LDAP app")
2.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
3.  Extract/unzip the downloaded plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
4.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_ldap_login/`
5.  Execute the sql file in `client/apps/r_ldap_login/sql/r_ldap_login.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_ldap_login/sql/r_ldap_login.sql`
6.  Goto `client/apps/r_ldap_login/` directory, to configure the plugin using app.json. Or You can also configure it on `http://{YOUR_SERVER_NAME}/#/apps/r_ldap_login` path in your Restyaboard server.
7.  After the above process, clear the browser cache and login again to view the installed LDAP plugin on your Restyaboard.