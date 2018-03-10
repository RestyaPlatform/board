## Installation Steps

1.  Purchase Chat App
2.  Goto Restyaboard installation root directory. e.g., directory: `/usr/share/nginx/html/restyaboard/`
3.  Unzip the purchased Chat app to your root directory
4.  Give file permission to unzipped files located in `client/apps/r_chat/` pathe.g., `chmod -R 0777 client/apps/r_chat/`
5.  Run the `chat.sh` file located in root directory to install ejabberd on your servere.g., `./chat.sh`
6.  Goto `client/apps/r_chat/` directory. Configure LDAP using `app.json` which can be found in `client/apps/r_chat/` directory. Or else you can configure it by using `http://{YOUR_SERVER_NAME}/#/apps/r_chat` path from your Restyaboard server.

    #### Configuration details

    1.  DB Host - Enter ejabberd's database host
    2.  DB Port - Enter ejabberd's dabase port
    3.  DB Name - Enter ejabberd's database name
    4.  DB Username - Enter ejabberd's database username
    5.  DB Password - Enter ejabberd's database password
    6.  Bosh Service URL - Enter ejabberd's bosh service url
    7.  Jabber Host - Enter ejabberd's jabber host
    8.  JAXL DEBUG - Enter ejabberd's jaxl bebug
    9.  Client Resource Name - Enter ejabberd's client resource name
7.  Finally,clear the browser cache, and login again to view the installed Chat App on your restyaboard.