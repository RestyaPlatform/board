---
description: Task Move on Due Date Plugin Installation
---

# Task Move on Due Date Plugin Installation

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install Task Move on Due Date plugin.

### What you'll learn

*   How to install Task Move on Due Date Plugin

## Video Tutorial

For step-by-step instructions on Task Move on Due Date Plugin Installation, refer [YouTube video](https://www.youtube.com/watch?v=BR6bBZ1nkrg "Watch video on Task Move on Due Date Plugin Installation")

[![Task Move on Due Date Plugin Installation](task_move_on_due_date.png)](https://www.youtube.com/watch?v=BR6bBZ1nkrg "Watch video on Task Move on Due Date Plugin Installation")

## Task Move on Due Date Plugin Installation

1.  Download [Task Move on Due Date app](https://restya.com/board/apps/r_task_move_on_due_date "Task Move on Due Date app")
2.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
3.  Extract/unzip the downloaded plugin zip into the restyaboard installation path. e.g., `/usr/share/nginx/html/restyaboard/`
4.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_task_move_on_due_date/`
5.  Execute the sql file in `client/apps/r_task_move_on_due_date/sql/r_task_move_on_due_date.sql` using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -w < /usr/share/nginx/html/restyaboard/client/apps/r_task_move_on_due_date/sql/r_task_move_on_due_date.sql`
6.  After the above process, clear the browser cache and login again to view the installed Task Move on Due Date plugin on your Restyaboard.