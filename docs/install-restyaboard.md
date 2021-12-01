---
description: Restyaboard installation using shell script
---

# Restyaboard Installation

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document is a step-by-step guide that illustrates how to install Restyaboard using shell script and how to manually install Restyaboard.

### What you'll learn

*   How to install the Restyaboard using shell script
*   How to manually install the Restyaboard

## Restyaboard Installation Using Shell Script

1.  Install script will automatically install required software, you can get the raw code from `https://raw.githubusercontent.com/RestyaPlatform/board/master/restyaboard.sh` and save it as a shell script file. eg.,`restyaboard.sh`
2.  You may use `wget` to download install script: `wget https://github.com/RestyaPlatform/board/raw/master/restyaboard.sh –no-check-certificate`
3.  In restyaboard.sh, [update PostgreSQL configurations](https://github.com/RestyaPlatform/board/blob/master/restyaboard.sh#L1315 "Update PostgreSQL configurations") as you wanted. For intranet or medium security setup, you may leave it as it is. If you edit, you must remember the details
4.  Execute `chmod +x restyaboard.sh` command
5.  Execute restyaboard.sh by using `./restyaboard.sh` command
6.  If you face any issue, please [open a ticket in Github](https://github.com/RestyaPlatform/board/issues/new "open a ticket in GitHub") and upload the created `restyaboard_install.log` log file. This will help us to track the issue.

## Restyaboard Manual Installation

1.  **Required software:** nginx, php-fpm (with mbstring, ImageMagick and IMAP), PostgreSQL, GeoIP and jq
2.  Download [latest "ready deployable" version.](https://github.com/RestyaPlatform/board/releases/latest "latest "ready deployable" version") You can directly unzip and upload to your server—without needing to build with grunt.
3.  `sql/restyaboard_with_empty_data.sql` - Database generation script
4.  `server/php/config.inc.php` - Database and other configurations
5.  `media, tmp/cache, server/php/shell/*.sh` & `client/img` - Need write permission for php; can be `chmod 655` or `755` or `777` depending upon server configuration
6.  Setup cron for sending email notification to user, HTTP POST payload to the webhook's configured URL, due date notification email to user and to read configured IMAP email for add card or update card comment `*/5 * * * * /path/to/server/php/shell/main.sh`