# Board Template

##Instructions
------------

1.  Goto your Restyaboard installation root directory. e.g., directory: "/usr/share/nginx/html/restyaboard/"
2.  Create board template JSON file manually. e.g.,  
``` json
    {
    "name": "Todo", 
    "lists": \[
        "Todo",
        "Doing",
        "Done"
        \]
    }
```
3.  Copy that JSON file and paste it into the workflow_templates folder which is available in "client/js/workflow_templates" directory
4.  Give file permission to that JSON file e.g., "chmod -R 0777 client/js/workflow_templates/{TEMPLATE_FILE}"
5.  After above process, clear the browser cache and login again.
6.  Now you can create board with your customized template.