---
description: Mail server configuration in Restyaboard
---

# Mail server configuration

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about how to troubleshoot problems receiving email, how to configure external SMTP server, how to troubleshoot emails received in spam folder issue, how to troubleshoot email issues in Azure hosting

### What you'll learn

*   How to troubleshoot problems receiving email
*   How to configure external SMTP server
*   How to troubleshoot emails received in spam folder issue
*   How to troubleshoot email issues in Azure hosting

## Troubleshooting

In Restyaboard, emails are sent using PHP’s inbuilt mail() function which inturn relies on system’s mail server, usually, sendmail program on Linux.

#### Receiving emails in Linux based setup

*   Restyaboard’s install script installs `Postfix` MTA (Mail Transfer Agent) which is a modern replacement for sendmail and has compatible interface. So, usually you should receive emails on Linux based setup without any issues. But, emails may be delivered to spam folder and or you may want to make use of external SMTP server. Those concerns are addressed in other sections below.
    

#### Receiving emails in Windows based setup

*   In Windows machine, you’ll need additional program that mimics sendmail functions. If you setup Apache/nginx/PHP using multiple installer programs such as WPN-XM, they usually comes with such feature.
    
*   Alternatively, you may also use external SMTP server as mentioned in [php.ini based approach to setup external SMTP (for Windows)](https://stackoverflow.com/questions/112190/php-ini-smtp-how-do-you-pass-username-password/6941390#6941390 "php.ini based approach to setup external SMTP (for Windows)")
    

#### Popular sendmail alternative for Windows

*   [Fake sendmail for Windows](https://www.glob.com.au/sendmail/ "Fake sendmail for Windows")

#### Multi installers to setup PHP on Windows that come with sendmail feature

*   [WPN-XM](https://wpn-xm.org/ "WPN-XM")
*   [Wamp.NET](https://www.wamp.net/ "Wamp.NET")

## Configuring external SMTP server

Sometimes you may want to make use of external SMTP server to send mails. One popular approach in PHP ecosystem is to use mailer scripts such as PHPMailer and Swift Mailer to hook to external SMTP server. As Restyaboard’s original goal was to keep the codebase lighter and faster without any bloat, it didn’t include any of such script based solutions.

#### Postfix based approach to setup external SMTP (for Linux)

*   In Linux, for setting up external SMTP, can directly enter in Postfix. For more details, [refer to Stack Overflow post on how to configure Postfix](https://stackoverflow.com/questions/112190/php-ini-smtp-how-do-you-pass-username-password/31084190#31084190 "refer to Stack Overflow post on how to configure Postfix")
    

#### php.ini based approach to setup external SMTP (for Windows)

*   In Windows, for setting up external SMTP, can directly enter in php.in. For more details, [refer to Stack Overflow post on how to configure php.ini](https://stackoverflow.com/questions/112190/php-ini-smtp-how-do-you-pass-username-password/6941390#6941390 "refer to Stack Overflow post on how to configure php.ini")
    

#### References related to external SMTP server

*   Restyaboard issue [#1397: Suggestion: Using SMTP Library](https://github.com/RestyaPlatform/board/issues/1397 "#1397: Suggestion: Using SMTP Library")
*   Restyaboard issue [#450: SMTP server support](https://github.com/RestyaPlatform/board/issues/450#issuecomment-196814831 "#450: SMTP server support")

## Troubleshooting emails received in spam folder issue

When emails are being sent from local machine and or intranet setup, most mail solutions such as Gmail may flag them as spam and will send them to spam folder. Unfortunately there is no good solution to handle this situation. You may however ask all users of such Restyaboard instance to set up filters in Gmail so that mails are sent to inbox instead of spam.

If you use external server hosting and still receive emails in spam folder, you may follow Google’s suggested best practices

#### Solving spam issues using SPF, DKIM and DMARC

*   As noted above, if you use external hosting setup (not intranet or Laptop), you may follow [Google’s suggestion to use SPF, DKIM and DMARC](https://support.google.com/a/answer/33786?hl=en "Google’s suggestion to use SPF, DKIM and DMARC"). Note that for this to work, you’ll also need a domain name.
    

#### Guides to assist in setting up SPF, DKIM and DMARC

*   [How To Create a SPF Record For Your Domain with Google Apps](https://www.digitalocean.com/community/tutorials/how-to-create-a-spf-record-for-your-domain-with-google-apps "How To Create a SPF Record For Your Domain with Google Apps")
    
*   [How do I setup SPF on my (DigitalOcean) droplet?](https://www.digitalocean.com/community/questions/how-do-i-setup-spf-on-my-droplet "How do I setup SPF on my (DigitalOcean) droplet?")
    
*   [How To Install and Configure DKIM with Postfix on Debian Wheezy](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy "How To Install and Configure DKIM with Postfix on Debian Wheezy")
    
*   [DKIM on DNS panel DigitalOcean](https://www.digitalocean.com/community/questions/dkim-on-dns-panel-digitalocean "DKIM on DNS panel DigitalOcean")
    

#### Testing SPF, DKIM and DMARC setup

You may use below online free tool to test your report

*   [Domain Health Check](https://mxtoolbox.com/domain "Domain Health Check")
    

If there are no problems reported, most likely the emails will be received in inbox.

#### Caveats

*   Please note that for some cases, setting up SPF, DKIM and DMARC may not still work as mail systems use lot of heuristics to determine spam and can flag system mails as spam.

## Troubleshooting email issues in Azure hosting

By default, Azure hosting blocks all outgoing mails. So, even if you use Linux VM on Azure, emails won’t be sent.

#### Possible solutions for Azure hosting

*   Contact Azure support
    
*   Use external SMTP server
    

#### References related to Azure hosting email issue

*   Restyaboard issue [#1771: Can't send email from Azure hosting](https://github.com/RestyaPlatform/board/issues/1771 "#1771: Can't send email from Azure hosting")
