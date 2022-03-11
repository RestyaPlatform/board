---
description: Zapier Plugin Installation
---

# Zapier plugin installation instructions

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install the Zapier plugin.

### What you'll learn

*   How to install the Zapier plugin in the Restyaboard

## Video Tutorial

For step-by-step instructions on Zapier Plugin Installation, refer [YouTube video](https://www.youtube.com/watch?v=sMHzwfnlN6g "Watch video on Zapier Plugin Installation")

[![Zapier Plugin Installation](zapier_installation.png "Zapier Plugin Installation")](https://www.youtube.com/watch?v=sMHzwfnlN6g "Watch video on Zapier Plugin Installation")

## Zapier Plugin Installation

1.  Download [Zapier app](https://restya.com/board/apps/r_zapier "Zapier app")
2.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
3.  Extract/unzip the downloaded plugin zip into the Restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
4.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_zapier/`
5.  Goto `client/apps/r_zapier/` directory, to configure the plugin using app.json. Or You can also configure it on `http://{YOUR_SERVER_NAME}/#/apps/r_zapier` path in your Restyaboard server and the configuration values are given in `http://{YOUR_SERVER_NAME}/#/oauth_clients`.
6.  After the above process, clear the browser cache and login again to view the installed Zapier plugin on your Restyaboard.
7.  Launch zapier app from Apps drawer and then configure your `Restyaboard account`.