---
description: Backup and Restore Restyaboard
---

# How to Backup and Restore Restyaboard?

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install and configure Agile WIP Plugin from admin panel.

### What you'll learn

*   How to Backup and Restore particular board or all boards in Restyaboard?
*   How to Backup and Restore Restyaboard Database?
*   How to Backup and Restore Restyaboard user uploaded files?

## How to Backup and Restore particular board or all boards in Restyaboard?

**How to Backup particular board or all boards in Restyaboard?**

*   You can Backup particular board or all boards in Restyaboard by following the instructions from the link [https://blog.sleeplessbeastie.eu/2018/04/02/how-to-backup-and-restore-restyaboard-boards/](https://blog.sleeplessbeastie.eu/2018/04/02/how-to-backup-and-restore-restyaboard-boards/ "Backup and Restore particular board or all boards in Restyaboard")

## How to Backup and Restore Restyaboard Database?

**How to Backup Restyaboard Database?**

*   Backup the `database` by running the below command :
    *   `pg_dump -O -U restya -W restyaboard > "/usr/share/nginx/html/restyaboard_database.sql"`

**How to Restore Restyaboard Database?**

*   For restoring the `database`, please run the following command:
    *   `psql -h localhost -d restyaboard -U restya -W < "/usr/share/nginx/html/restyaboard_database.sql"`

## How to Backup and Restore Restyaboard user uploaded files?

**How to Backup Restyaboard user uploaded files?**

*   Backup the `user uploaded files` by creating the `zip` file from the `media folder` of your Restyaboard files which is in the path `/usr/share/nginx/html/restyaboard` by running the below command:
    *   `cd /usr/share/nginx/html/restyaboard`
    *   `zip -r media.zip media/`

**How to Restore Restyaboard user uploaded files?**

*   For restoring the `user uploaded files`, please `unzip` the `media zip file` in `/usr/share/nginx/html/restyaboard` by running the below command:
    *   `cd /usr/share/nginx/html/restyaboard`
    *   `unzip media.zip`