---
description: Insights Plugin Installation
---

# Insights Plugin Installation

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to install the Insights plugin.

### What you'll learn

*   How to install the Insights plugin in the Restyaboard

## Video Tutorial

For step-by-step instructions on Insights Plugin Installation, refer [YouTube video](https://www.youtube.com/watch?v=anvfjJYM0yw "Watch video on Insights Plugin Installation")

[![Insights Plugin Installation](insights_plugin_installation.png)](https://www.youtube.com/watch?v=anvfjJYM0yw "Watch video on Insights Plugin Installation")

## Insights Plugin Installation

1.  Download [Insights app](https://restya.com/board/apps/r_insights "Insights app")
2.  Goto your Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
3.  Extract/unzip the downloaded plugin zip into the restyaboard installation path.
4.  Give file permission to extracted files. e.g., `chmod -R 0777 client/apps/r_insights/`
5.  Execute the sql file in `client/apps/r_insights/sql/` folder using the command `psql -h localhost -d {DATABASE_NAME} -U {USER_Name} -W < /usr/share/nginx/html/restyaboard/client/apps/r_insights/sql/r_insights.sql`
6.  After the above process, clear the browser cache and login again to view the installed Insights plugin on your Restyaboard.