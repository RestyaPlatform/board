---
description: Restyaboard Apache configuration
---

# Apache configuration

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to configure Restyaboard in Apache.

### What you'll learn

*   How to configure Restyaboard in Apache

## How to configure in Apache?

[https://github.com/RestyaPlatform/board/blob/master/.htaccess](https://github.com/RestyaPlatform/board/blob/master/.htaccess)

1.  Just download and paste `.htaccess` file from the above link
2.  Then access your link

## How to access sub folder in Apache?

**For Accessing your sub folder**

1.  In `https://github.com/RestyaPlatform/board/blob/master/.htaccess#L7` give your sub folder path.
2.  Then restart the server and the Restyaboard folder can be accessible now.

