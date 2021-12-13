---
description: Installation in windows using IIS
---

# Install in windows using IIS

## Introduction

[Restyaboard](https://restya.com/board) is an open source alternative to Trello, but with smart additional features like offline sync, diff /revisions, nested comments, multiple view layouts, chat, and more. And since it is self-hosted, data, privacy, and IP security can be guaranteed.

Restyaboard is more like an electronic sticky note for organizing tasks and todos. Apart from this, it is ideal for Kanban, Agile, Gemba board and business process/workflow management. It can be extended with [productive plugins](https://restya.com/board/apps "productive plugins")

Today, several universities, automobile companies, government organizations, etc from across Europe take advantage of Restyaboard.

This document contains information about Installation in Windows using IIS.

### What you'll learn

*   How to install Restyaboard in Windows using IIS?
*   How to download Restyaboard?
*   How to check IIS Folder Permissions?
*   How to install dependencies and compile less/js?
*   How to install php and postgresql?
*   How to setup PHP Extensions?
*   How to setup the Restyaboard Database?
*   How to setup a new site in IIS?
*   How to setup web.config?

## Installation in Windows using IIS

**Please find the steps that I have followed in Windows:**

#### Credits:

[https://gist.github.com/t0mgerman/0f77ac95fdba863ca478b0583aa2b925](https://gist.github.com/t0mgerman/0f77ac95fdba863ca478b0583aa2b925)

#### Tested with:

*   Windows Server 2008 R2
*   IIS 7.5
*   PHP 5.6
*   PostgreSQL 10

#### You will need:

*   Microsoft Web Platform Installer

[https://www.microsoft.com/web/downloads/platform.aspx](https://www.microsoft.com/web/downloads/platform.aspx "Microsoft Web Platform Installer")

*   NodeJS / NPM

[https://nodejs.org/en/](https://nodejs.org/en/ "NodeJS / NPM Installer")

*   PostgreSQL

[https://www.postgresql.org/download/](https://www.postgresql.org/download/ "PostgreSQL Installer")

*   Git for Windows (including Git Bash) - this is optional

[https://gitforwindows.org/](https://gitforwindows.org/ "Git Installer")

#### Steps:

1.  Download Restyaboard
2.  Check IIS Folder Permissions
3.  Install dependencies and compile less/js (npm/grunt)
4.  Install PHP and PostgreSQL if necessary
5.  Check active PHP extensions (setup if necessary)
6.  Setup the Restyaboard Database
7.  Setup a new site in IIS
8.  Configure web.config

## DOWNLOAD RESTYABOARD

**This can be done one of two ways**

#### Via ZIP:

*   Create a new folder for the board on your system. For example: “C:\\inetpub\\wwwroot\\restyaboard” Navigate to

[https://github.com/RestyaPlatform/board/releases](https://github.com/RestyaPlatform/board/releases "Restyaboard Release") and download the latest board-vX.X.X.zip file and Extract this ZIP / copy the contents to the folder you created

#### Via git:

*   Navigate to where you would like the board created
*   in Git Bash: `cd /c/inetpub/wwwroot`
*   in Command Prompt: `cd c:\inetpub\wwwroot`
*   Type `git clone https://github.com/restyaboard/board.git”`
*   if you receive any SSL related errors (if for example you’re behind a corporate firewall) try the following before trying again: `git config –global http.sslVerify false`
*   The folder under wwwroot will be called board. To rename it:
*   Command Prompt: ren board restyaboard
*   Git Bash: mv board restyaboard
*   OR rename it in Explorer.

## IIS Folder Permissions

**Check IIS Folder Permissions**

*   In Windows Explorer, right click your install folder and click **Properties**.
*   Click on the **_Security Tab_**
*   Under the _Group_ or _user names_ box, click the **Edit** button
*   If **IIS\_IUSRS** and **IUSR** are not in the list, add them.
*   Click the **Add** button
*   Enter the account name (as written above), click the **Check Names** - the accounts should resolve. Click **OK**.
*   Tick the _Allow_ box for **full control.** Click **OK**.

## DEPENDENCIES AND COMPILE LESS/JS

**INSTALL DEPENDENCIES AND COMPILE LESS/JS**

*   From Command Prompt or Git Bash
*   Navigate to the install folder
*   If you don’t have `grunt-cli` installed, or you’re not sure type the following: `npm install -g grunt-cli`
*   Type the following commands, pressing enter after each: `npm install` `grunt less` `grunt jst`

**Note:** using the `grunt` command alone should suffice, but I had problems with it on my install relating to eslint, do the above if you come up against the same problem.

## INSTALL PHP AND POSTGRESQL

#### **INSTALL PHP AND POSTGRESQL**

If PHP and PostgreSQL are already on your system, you may not need this step.

#### PHP v5.6+

*   Download and install NodeJS if you don’t already have it
*   Using Web Platform Installer, install the following:
*   PHP 5.6.31
*   This should automatically offer to install the following:
*   Windows Cache Extension 1.3 for PHP 5.3
*   Microsoft Drivers 3.2 for PHP v5.6 for SQL Server in IIS

#### PostgreSQL 10

*   Download and install PostgreSQL using the installer certified by EnterpriseDB:
    *   [https://www.postgresql.org/download/windows/](https://www.postgresql.org/download/windows/)

## Setup PHP Extensions

### Check / Setup PHP Extensions

Restyaboard uses a couple of important PHP extensions for communicating with the PSQL database. Navigate to your PHP install (likely `C:\Program Files (x86)\PHP\v5.6`) and edit your php.ini configuration file. You may need to open Notepad or another editor as Administrator. Towards the end of the file, ensure you have the bolded: \[ExtensionList\] extension=php\_mysql.dll extension=php\_mysqli.dll extension=php\_mbstring.dll **extension=php\_gd2.dll extension=php\_ldap.dll** extension=php\_gettext.dll **extension=php\_curl.dll** extension=php\_exif.dll extension=php\_xmlrpc.dll extension=php\_openssl.dll extension=php\_soap.dll extension=php\_pdo\_mysql.dll extension=php\_pdo\_sqlite.dll **extension=php\_imap.dll** extension=php\_tidy.dll **extension=php\_pgsql.dll extension=php\_pdo\_pgsql.dll** It is the latter two DLLs that are likely not to be referenced. While you’re here, you may want to configure your SMTP server for mail.

## Setup the Restyaboard Database

#### **Setup the Restyaboard Database**

*   Open pgAdmin (installed with PostgreSQL above), and expand the Servers node
*   You will be prompted to login with the password you provided during install
*   Expand the PostgreSQL 10 node
*   Right click “Databases”, hover over “Create” and select 'Database’
*   Enter a database name of 'restyaboard’ and click Save
*   Right click “Login/Group Roles”, hover over Create and select “Login/Group Role”
*   In the “general” tab, provide the name `restya`
*   In the “definition” tab, provide the password `hjVl2!rGd`
*   Right click the newly created “restyaboard” database, and click “Query Tool”

#### Paste the following:

    CREATE USER restya WITH PASSWORD "hjVl2!rGd";
    ALTER DATABASE restyaboard OWNER TO restya;
    GRANT ALL PRIVILEGES ON DATABASE restyaboard TO restya;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO restya;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO restya;
    

With the above pasted, click the lightning bolt or press F5 to execute

*   Use the open (folder) icon in the “Query Tool”ok and double-click through your filesystem folders to find the empty SQL file from your downloaded Restyaboard install. This should be somewhere like:

`c:\inetpub\wwwroot\restyaboard\sql\restyaboard_with_empty_data.sql`

## SETUP A NEW SITE IN IIS

#### **SETUP A NEW SITE IN IIS**

*   With all of the above done open IIS Manager
*   Expand your server node, right click the “Sites” node and click “Add Web Site”
*   The Site Name can be anything you choose
*   For the physical path, navigate to the restyaboard install location
*   Binding settings may vary…
    *   if you have no other sites in IIS Manager, you can leave the Host Name blank and click enter, your site will be live at `http://localhost` for testing.
*   #### If you have “existing sites” on port 80:
    
    *   you may wish to use localhost:2134 (where 2134 is some port of your choosing)
    *   you may wish to use a subdomain, for example: restyaboard.localhost
    *   #### To do this, enter “restyaboard.localhost” in the Host Name box, and be sure to create a hosts file entry for restyaboard.localhost that points to 127.0.0.1
        

the hosts file is located in the `%windir%\system32\drivers\etc`

*   if you have control of DNS within your network or know someone who does, you can enter the Host Name you expect to set-up in DNS i.e. restyaboard.mycompany.com
*   You are limited to adding one binding from the Add New Web Site dialog, but you can add more later using IIS Manager. See **Bindings** in the Features View of your site. For example: my install is accessible from the server on restyaboard.localhost, but also via myserver:myport for the wider network.

## Setup web.config

**Setup web.config** With the site created, navigate to the folder where we installed Restyaboard and add the following web.config file:

        <?xml version="1.0" encoding="UTF-8"?>
        <configuration>
        <system.webServer>
        <rewrite>
            <rules>
                <clear />
                <rule name="iCAL URLs" stopProcessing="true">
                    <match url="^/?ical/(\[0-9\]*)/(\[0-9\]*)/(\[a-zA-Z0-9\]*).ics$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/server/php/ical.php?id={R:1}&amp;user_id={R:2}&amp;hash={R:2}" appendQueryString="false" />
                </rule>
                <rule name="Download URLs" stopProcessing="true">
                    <match url="^/?download/(\[0-9\]*)/(\[a-zA-Z0-9_\\.\]*)$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false" />
                    <action type="Rewrite" url="/server/php/download.php?id={R:1}&amp;hash={R:2}" />
                </rule>
                <rule name="oAuth Callback" stopProcessing="true">
                    <match url="^/?oauth\_callback/(\[a-zA-Z0-9\_\\.\]*)/(\[a-zA-Z0-9_\\.\]*)$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/server/php/oauth_callback.php?plugin={R:1}&amp;code={R:2}" appendQueryString="false" />
                </rule>
                <rule name="oAuth Authorize">
                    <match url="^/?oauth/authorize$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/server/php/authorize.php" />
                </rule>
                <rule name="API URLs" stopProcessing="true">
                    <match url="^/?api/(.*)$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false" />
                    <action type="Rewrite" url="/server/php/R/r.php?_url={R:1}&amp;" />
                </rule>
                <rule name="Site Root to Client" stopProcessing="true">
                    <match url="^$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false" />
                    <action type="Rewrite" url="client/" />
                </rule>
                <rule name="CSS, JS, IMG, Font, Apps, Locales" stopProcessing="false">
                    <match url="^/?(css|js|img|font|apps|locales)/(.*)$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/client/{R:1}/{R:2}" />
                </rule>
                <rule name="Image URLs" stopProcessing="true">
                    <match url="^/?client/img/(\[a-zA-Z_\]*)/(\[a-zA-Z_\]*)/(\[a-zA-Z0-9_\\.\]*)\\??(.*)?$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/server/php/image.php?size={R:1}&amp;model={R:2}&amp;filename={R:3}" appendQueryString="false" />
                </rule>
                <rule name="Favicon" stopProcessing="true">
                    <match url="^/?favicon.ico$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/client/favicon.ico" appendQueryString="false" />
                </rule>
                <rule name="Manifest" stopProcessing="true">
                    <match url="^/?manifest.json$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/client/manifest.json" appendQueryString="false" />
                </rule>
                <rule name="Apple Touch Icon" stopProcessing="true">
                    <match url="^/?apple-touch-icon(.*)$" />
                    <conditions logicalGrouping="MatchAll" trackAllCaptures="false" />
                    <action type="Rewrite" url="/client/apple-touch-icon{R:1}" appendQueryString="false" />
                </rule>
            </rules>
        </rewrite>
        <httpProtocol>
            <customHeaders>
                <add name="Cache-Control" value="public, must-revalidate" />
            </customHeaders>
        </httpProtocol>
        <staticContent>
            <mimeMap fileExtension=".json" mimeType="application/json" />
        </staticContent>
        <handlers>
            <remove name="PHP\_via\_FastCGI" />
            <remove name="WebDAV" />
            <remove name="ExtensionlessUrlHandler-Integrated-4.0" />
            <remove name="OPTIONSVerbHandler" />
            <remove name="TRACEVerbHandler" />
            <add name="ExtensionlessUrlHandler-Integrated-4.0" path="*." verb="*" type="System.Web.Handlers.TransferRequestHandler" preCondition="integratedMode,runtimeVersionv4.0" />
            <add name="PHP\_via\_FastCGI" path="*.php" verb="GET,HEAD,POST,PUT,DELETE" modules="FastCgiModule" scriptProcessor="C:\\Program Files (x86)\\PHP\\v5.6\\php-cgi.exe" resourceType="Either" requireAccess="Script" />
        </handlers>
        <modules>
            <remove name="WebDAVModule" />
        </modules>
    </system.webServer>
    </configuration>
    

Please take a quick look at the add and remove tags for PHP under the handlers node before moving on. Your PHP module MAY be called something different. Depending on your system, the install location of php-cgi.exe could be different too. Just check that the above matches what is on your system before moving on. You can check the name of your PHP handler by navigating to your site in IIS Manager and double-clicking Handler Mappings. You can edit the entry for PHP using IIS Manager here too if you like. Essentially, you need to make sure it is allowing the verbs PUT and DELETE. The above web.config file, broadly speaking, replicates what the .htaccess file accomplishes for Restyaboard in an apache install. But it also mitigates some known issues with IIS installs.

*   WebDAV sometimes prevents RESTful APIs receiving PUT and DELETE requests
*   The PUT and DELETE verbs need to be allowed on a couple of relevant handlers in order for Restyaboard’s API to work. The API is used for nearly every asynchronous task on the front-end, so it is important that this works.

**Attempt to use your newly configured Restyaboard** Using your web browser, navigate to the appropriate location. Hopefully you will see a Restyaboard login screen. The default admin credentials are `admin` and `restya`. **_Note:_** **Upgrading** Upgrades can be performed by overwriting the install folder with files from the latest release and updating the database using the appropriate SQL script. After copying the new files, run `npm install` and `grunt` again, and use pgAdmin to open the database upgrade script. These scripts are located in `restyaboard/sql`
