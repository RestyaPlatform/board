---
description: Restyaboard Elasticsearch Help
---

# Elasticsearch Help

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to use Elasticsearch plugin's search terms in Restyaboard.

### What you'll learn

*   How to use Elasticsearch plugin's search terms in Restyaboard

## Video Tutorial

For step-by-step instructions on Elasticsearch Help, refer [YouTube video](https://www.youtube.com/watch?v=Kkx9-_FIOi0 "Watch video on Elasticsearch Help")

[![[Elasticsearch Help]](elasticsearch_help.png)](https://www.youtube.com/watch?v=Kkx9-_FIOi0 "Watch video on Elasticsearch Help")

## Elasticsearch Help

**board:name**

*   Returns cards within a specific board. You can search by board name, too, such as “board:development” to search only cards on boards with development in the board name.

**created:day**

*   Returns cards created within 24 hours.

**description:, checklist:, comment:, name: and id:**

*   Returns cards matching the text of card descriptions, checklists, comments, or names or id. For example, comment:“FIX IT” will return cards with “FIX IT” in a comment.

**custom field name:custom field value**

*   Returns cards matching the text of custom field name and custom field value and if the custom field name contains space like `Checking Date` with value `2019-07-09`, then you should search like `Checking_Date:2019-07-09`.

**due:day**

*   Returns cards due within 24 hours. **due:week, due:month, and due:overdue** also work as expected. You can search for a specific day range. For example, adding due:14 to search will include cards due in the next 14 days.

**edited:day**

*   Returns cards edited in the last 24 hours. **edited:week and edited:month** also work as expected. You can search for a specific day range. For example, adding edited:21 to the search will include cards edited in the last 21 days.

**has:attachments**

*   Returns cards with attachments.

**has:custom\_fields**

*   Returns cards which are having the custom field with values.

**has:description**

*   Returns cards with description.

**has:members**

*   Returns cards with members.

**is:open and is:archived**

*   Returns cards that are either open or archived. It returns both types by default.

**is:starred**

*   Returns cards which are on starred boards.

**label:name**

*   Returns labeled cards

**list:name**

*   Returns cards within the list named “name”. Or whatever you type besides “name”.

**user:name**

*   Returns cards assigned to a member. user:me will include only your cards.

## View All Cards Across Different Boards in TODO, DOING, DONE lists

*   View cards across different boards with the due date as today in the Todo list with the search term `due:today_todo`.
    
*   View cards across different boards with the due date as today in the Doing list with the search term `due:today_doing`.
    
*   View cards across different boards with the due date as today in the Done list with the search term `due:today_done`.
    
*   View cards across different boards with a due date within the current week in the Todo list with the search term `due:week_todo`.
    
*   View cards across different boards with a due date within the current week in the Doing list with the search term `due:week_doing`.
    
*   View cards across different boards with a due date within the current week in the Done list with the search term `due:week_done`.
    
*   View overall cards across different boards in the Todo list with the search term `due:overall_todo`.
    
*   View overall cards across different boards in the Doing list with the search term `due:overall_doing`.
    
*   View overall cards across different boards in the Done list with the search term `due:overall_done`.