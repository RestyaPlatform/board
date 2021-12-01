---
description: User Role to Board Role Mapper Plugin Installation
---

# Board Roles Plugin Installation

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install User Role to Board Role Mapper Plugin and how to assign the board roles to the user roles in the Restyaboard from admin panel.

### What you'll learn

*   How to install User Role to Board Role Mapper Plugin?
*   How to assign the board roles to the user roles in the Restyaboard?

## Board Roles Plugin Installation

1.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
2.  Extract/unzip the purchased plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
3.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_board_roles/`
4.  Execute the sql file in `client/apps/r_board_roles/sql/r_board_roles.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_board_roles/sql/r_board_roles.sql`
6.  After above process, clear the browser cache and login again to view the installed Board Roles plugin on your Restyaboard.

## Creation of Board Roles

1.  For creating Board Roles, goto `http://{YOUR\_SERVER\_NAME}/#/roles` path in your Restyaboard server and in the content of the `Users` tab, list of boards will be listed with board roles in the user roles column
2.  Now, for assigning the roles , please click the one of the select option in the user roles column of the particular board