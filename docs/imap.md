---
description: Restyaboard IMAP Configuration
---

# IMAP

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to configure and use IMAP in Restyaboard.

### What you'll learn

*   How to use IMAP in Restyaboard
*   How to configure IMAP in Restyaboard
*   How to configure the Gmail/G Suite based email for IMAP

## IMAP uses in Restyaboard

**FOR ADDING CARD TO THE BOARD**

*   For adding cards to the board, the board email address will be available on the board page with `Email to board settings` option under the board header `settings` dropdown menu and you can select the `list` and `position` in which you want to insert the card and we have added the below image for `Email to board seeings` menu. ![[image: IMAP Configuration]](board_email_settings.png)
*   Send mail to the email address of the board and the `mail subject` will be the `card name` and the `mail body` contents will be the `card description`.
*   You can add an `attachment` to the `card` by sending `mail` to mail address of the `board` with `attachments in the mail body`.

**FOR POSTING COMMENTS TO THE EXISTING CARD**

*   For posting comments to the existing card, the card email address will be available on the Modal card page inside the dropdown menu of the option `share and more` under the `settings` dropdown menu and we have added the below image for `settings` dropdown menu. ![[image: IMAP Configuration]](card_email_settings.png)
*   Send mail to the email address of the card and the `mail body` will be posted as `comment` in the card.
*   You can add an `attachment` to the `card` by sending `mail` to mail address of the `card` with `attachments in the mail body`.

## IMAP Configuration

**How IMAP used in Restyaboard**

*   To create a card for a board and post a comment for a card through configured imap mail

**IMAP CONFIGURATION**

*   To configure IMAP, goto `http://{YOUR_SERVER_NAME}/#/settings` path in your Restyaboard server and choose `IMAP` tab

![[image: IMAP Configuration]](imap_configuration.png)

*   **Incoming Mail Server**
    
    Mail server (eg., imap.gmail.com)
    
*   **Port**
    
    Mail port (e.g., 993 )
    
*   **Email address**
    
    To add/reply cards via email you must set up a secret email account with IMAP access. This should support plus addressing and has to be dedicated to handle replying through email feature. Suggested email address is `rbreply@yourdomain.tld`

## Gmail/G Suite based email Configuration for IMAP

After configuration of IMAP in Restyaboard, if your IMAP Email address is `Gmail/G Suite` based email, you should enable the access in the link [https://myaccount.google.com/lesssecureapps](https://myaccount.google.com/lesssecureapps) to allow Restyaboard to read your mails in Email to create cards in the board and add comments in the card.
