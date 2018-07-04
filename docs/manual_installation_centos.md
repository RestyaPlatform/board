# Installation in CentOS using shell script

## Installation in CentOS using shell script

[![How to install Restyaboard on CentOs](centos_installation.png)](https://youtu.be/hcnIHZnS1o8)

1.  Install script will automatically install required software, you can get the raw code from "https://raw.githubusercontent.com/RestyaPlatform/board/master/restyaboard.sh" and save it as a shell script file. eg.,"restyaboard.sh"
2.  You may use wget for downloading install script: "wget https://github.com/RestyaPlatform/board/raw/master/restyaboard.sh --no-check-certificate"
3.  In restyaboard.sh, update PostgreSQL configurations as you wanted. For intranet or medium security setup, you may leave it  as it is. If you edit, you must remember the details.
4.  Execute "chmod +x restyaboard.sh" command
5.  Execute restyaboard.sh by using "./restyaboard.sh" command
6.  After complete installation of Restyaboard using shell script, please enter your "Restyaboard URL" in the browser, If the Restyaboard page is empty, we think disable selinux and reboot the machine may resolve your problem. For disabling selinux, please refer this video [here](https://youtu.be/hcnIHZnS1o8?t=150 "Selinux Disablie").