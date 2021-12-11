---
description: Troubleshooting in Restyaboard
---

# Troubleshooting

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to match users from Trello to the Restyaboard users, how to receive card due date mail notifications for the Restyaboard board users, how to use Restyaboard iOS app in iPhone, how to use Restyaboard in effective method, how to change the ownership of Restyaboard database, how to allow only particular users to Add/Edit labels, how to reset the password of users.

### What you'll learn

*   How to match users from Trello to the Restyaboard users
*   How to receive card due date mail notifications for the Restyaboard board users
*   How to use Restyaboard iOS app in iPhone
*   How to use Restyaboard in effective method
*   How to change the ownership of Restyaboard database
*   How to allow only particular users to Add/Edit labels
*   How to reset the password of users

## Troubleshooting

**Is there any way I can match users from Trello to the Restyaboard users(for example changing the values in the json file?)**

*   it's possible by changing username in members array of the json file.

**Whether members of the board will receive card due date mail notifications**

*   For receiving card due date mail notification, the users should be assigned to the cards.

**How to use Restyaboard iOS app in iPhone**

*   Please follow the instructions from [https://restya.com/board/mobile-app](https://restya.com/board/mobile-app) for using Restyaboard iOS app on your iPhone.

**Is Restyaboard can be installed on Windows or Ubuntu or CentOS**

*   Yes, Restyaboard can be installed on Windows, Ubuntu, CentOS.

**How to use Restyaboard in effective method**

*   Please refer the video [https://www.youtube.com/watch?v=GD8Nmi1600U](https://www.youtube.com/watch?v=GD8Nmi1600U) for the quick introduction of Restyaboard

**For changing the ownership of Restyaboard database**

*   please execute the command

  `GRANT ALL PRIVILEGES ON DATABASE restyaboard TO restya;
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO restya;  
        GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO restya;` 
  

**After installing Restyaboard on CentOS, the login page is not showing**

*   In CentOS, we think disable selinux and reboot the machine may resolve your problem. For disabling selinux, please refer the video [https://www.youtube.com/watch?v=hcnIHZnS1o8?t=150](https://www.youtube.com/watch?v=hcnIHZnS1o8?t=150)

**How to allow only particular users to Add/Edit labels**

*   You can allow the users to Add/Edit label by login as admin and enable the roles for `Add/Delete label` in the `Boards` tab of roles page and it’s link is `restyaboard_url/#/roles`

**How to reset the password of users**

*   You can change the password by clicking `change password` option in the `admin panel` users listing page and it’s link is `restyaboard_url/#/users?page=1`

**After manually installing Restyaboard on Windows using XAMPP, the login page is not showing**

*   Please check if the PostgreSQL has been installed on your windows and PostgreSql has been enabled in the XAMPP.
*   If the PostgreSql is not enabled in XAMPP, please open `php.ini` file in the `XAMPP_folder/php` folder and please find `;extension=php_pdo_pgsql.dll`, `;extension=php_pgsql.dll` and remove `;` from the line and `restart` XAMPP
