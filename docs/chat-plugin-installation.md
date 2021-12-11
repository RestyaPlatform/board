---
description: Chat Plugin Installation
---

# Chat Plugin Installation

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install and configure Chat plugin from admin panel in Restyaboard.

### What you'll learn

*   How to install Chat Plugin
*   How to configure Chat Plugin

## How to install Chat Plugin

1.  Download [Chat App](https://restya.com/board/apps/r_chat "Chat app")
2.  Goto Restyaboard installation root directory. e.g., directory: :'/usr/share/nginx/html/restyaboard/'
3.  Unzip the downloaded Chat app to your root directory
4.  Give file permission to unzipped files located in 'client/apps/r\_chat/' pathe.g., 'chmod -R 0777 client/apps/r\_chat/'
5.  Run 'chat.sh' file located in the root directory to install ejabberd on your server e.g., './chat.sh'
6.  Goto 'client/apps/r\_chat/' directory. Configure LDAP using 'app.json' which can be found in 'client/apps/r\_chat/' directory. Or else you can configure it by using 'http://{YOUR\_SERVER\_NAME}/#/apps/r\_chat' path from your Restyaboard server.
7.  Finally,clear the browser cache, and login again to view the installed Chat App on your Restyaboard.

## How to configure Chat Plugin

**DB Host**

*   Enter ejabberd’s database host

**DB Port**

*   Enter ejabberd’s dabase port

**DB Name**

*   Enter ejabberd’s database name

**DB Username**

*   Enter ejabberd’s database username

**DB Password**

*   Enter ejabberd’s database password

**Bosh Service URL**

*   Enter ejabberd’s bosh service url

**Jabber Host**

*   Enter ejabberd’s jabber host

**JAXL DEBUG**

*   Enter ejabberd’s jaxl debug

**Client Resource Name**

*   Enter ejabberd’s client resource name