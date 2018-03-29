# XMPP Installation

## Configuration for chat plugin

1.  Purchase Chat App
2.  Goto Restyaboard installation root directory. e.g., directory: :"/usr/share/nginx/html/restyaboard/"
3.  Unzip the purchased Chat app to your root directory
4.  Give file permission to unzipped files located in "client/apps/r_chat/" pathe.g., "chmod -R 0777 client/apps/r_chat/"
5.  Run the "chat.sh" file located in root directory to install ejabberd on your servere.g., "./chat.sh"
6.  Goto "client/apps/r_chat/" directory. Configure LDAP using "app.json" which can be found in "client/apps/r_chat/" directory. Or else you can configure it by using "http://{YOUR_SERVER_NAME}/#/apps/r_chat" path from your Restyaboard server.

## Configuration details


**DB Host**

* Enter ejabberd's database host

**DB Port** 

* Enter ejabberd's dabase port
   
**DB Name**

* Enter ejabberd's database name

**DB Username**

* Enter ejabberd's database username

**DB Password**

* Enter ejabberd's database password

**Bosh Service URL**

* Enter ejabberd's bosh service url

**Jabber Host** 

* Enter ejabberd's jabber host

**JAXL DEBUG**

* Enter ejabberd's jaxl bebug

**Client Resource Name**

* Enter ejabberd's client resource name

Finally,clear the browser cache, and login again to view the installed Chat App on your restyaboard.