---
description: Restyaboard installation in Ubuntu using shell script
---

# Installation in Ubuntu using shell script

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document is a step-by-step guide that illustrates how to install Restyaboard in Ubuntu using shell script.

### What you'll learn

*   How to install the Restyaboard in Ubuntu using shell script

## Video Tutorial

For step-by-step instructions on Installation in Ubuntu using shell script, refer [YouTube video](https://www.youtube.com/watch?v=lSPgr5zXXuY "Watch video on Installation in Ubuntu using shell script")

[![Installation in Ubuntu using shell script](ubuntu_installation.png)](https://www.youtube.com/watch?v=lSPgr5zXXuY "Watch video on Installation in Ubuntu using shell script")

## Installation in Ubuntu using shell script

1.  Install script will automatically install required software, you can get the raw code from `https://raw.githubusercontent.com/RestyaPlatform/board/master/restyaboard.sh` and save it as a shell script file. eg.,`restyaboard.sh`
2.  You may use wget to download install script: `wget https://github.com/RestyaPlatform/board/raw/master/restyaboard.sh –no-check-certificate`
3.  In restyaboard.sh, `update PostgreSQL configurations` as you wanted. For intranet or medium security setup, you may leave it as it is. If you edit, you must remember the details
4.  Execute `chmod +x restyaboard.sh` command
5.  Execute restyaboard.sh by using `./restyaboard.sh` command    