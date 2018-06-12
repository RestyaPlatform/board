# Manual Installation in CentOs

## Instructions for manual installation in CentOs

[![How to install Restyaboard on CentOs](http://img.youtube.com/vi/EamGEdTH9Ss/0.jpg)](https://youtu.be/EamGEdTH9Ss)

1.  Install script will automatically install required software, you can get the raw code from "https://raw.githubusercontent.com/RestyaPlatform/board/master/restyaboard.sh" and save it as a shell script file. eg.,"restyaboard.sh"
2.  You may use wget for downloading install script: "wget https://github.com/RestyaPlatform/board/raw/master/restyaboard.sh --no-check-certificate"
3.  In restyaboard.sh, update PostgreSQL configurations as you wanted. For intranet or medium security setup, you may leave it  as it is. If you edit, you must remember the details.
4.  Execute "chmod +x restyaboard.sh" command
5.  Execute restyaboard.sh by using "./restyaboard.sh" command