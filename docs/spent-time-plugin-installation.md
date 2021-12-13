---
description: Spent Time Tracking Plugin Installation
---

# Spent Time Tracking Plugin Installation

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install the Spent Time Tracking plugin.

### What you'll learn

*   How to install the Spent Time Tracking plugin in the Restyaboard

## Video Tutorial

For step-by-step instructions on Spent Time Tracking Plugin Installation, refer [YouTube video](https://www.youtube.com/watch?v=MOKS-N00aD0 "Watch video on Spent Time Tracking Plugin Installation")

[![Spent Time Tracking Plugin Installation](spent_time.png)](https://www.youtube.com/watch?v=MOKS-N00aD0 "Watch video on Spent Time Tracking Plugin Installation")  

## Spent Time Tracking Plugin Installation

1.  Download [Spent Time Tracking app](https://restya.com/board/apps/r_spent_time "Spent Time Tracking app")
2.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
3.  Extract/unzip the downloaded plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
4.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_spent_time/`
5.  Execute the sql file in `client/apps/r_spent_time/sql/r_spent_time.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_spent_time/sql/r_spent_time.sql`
6.  After the above process, clear the browser cache and login again to view the installed Spent Time Tracking plugin on your Restyaboard.