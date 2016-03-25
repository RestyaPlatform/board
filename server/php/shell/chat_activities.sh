#!/bin/bash

# lock logic for semaphore - http://mywiki.wooledge.org/BashFAQ/045
path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
lockdir="${path}/chat_activities.lock"
echo >&2 "$(date '+%Y-%m-%d %H:%M:%S') #################################################"
if mkdir "$lockdir"
 then    # directory did not exist, but was created successfully
     echo >&2 "successfully acquired lock: $lockdir"

##########################################################################################################

# -----------------------------------------------------------------
# RESTYABOARD --->
# ==========
php ${path}/chat_activities.php

##########################################################################################################
	rmdir "$lockdir"
 else
     echo >&2 "cannot acquire lock, giving up on $lockdir"
     exit 0
 fi