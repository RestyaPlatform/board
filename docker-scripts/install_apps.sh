#!/bin/bash
mkdir "${ROOT_DIR}/client/apps"
chmod -R go+w "${ROOT_DIR}/client/apps"
APP_JSON_URL="https://raw.githubusercontent.com/RestyaPlatform/board-apps/master/apps.json"

APP_VERSION_URLS=""
APP_VERSION_URLS="${APP_VERSION_URLS} https://github.com/RestyaPlatform/board-apps/releases/download/v1/"
APP_VERSION_URLS="${APP_VERSION_URLS} https://github.com/RestyaPlatform/board-apps/releases/download/v2/"

curl -L -G --silent -o /tmp/apps.json $APP_JSON_URL
echo "Loaded apps.json"
chmod -R go+w "/tmp/apps.json"
for fid in `jq -r '.[] | .id + "-v" + .version + "#" + .price' /tmp/apps.json`
do
	app_name=$(echo ${fid} | cut -d"#" -f1)
	app_price=$(echo ${fid} | cut -d"#" -f2)
	if ([ "$app_price" = "Free" ])
	then
		for sub_url in ${APP_VERSION_URLS}
		do
			APP_URL="$sub_url$app_name.zip"
		    echo $APP_URL
    		if curl --output /dev/null --silent --head --fail "$APP_URL"; then
				#activate for debugging
				#curl -v -L -G  -o /tmp/$app_name.zip $APP_URL
				curl -L -G --silent -o /tmp/$app_name.zip $APP_URL
				echo "Downloaded app <$app_name>. Start unzipping..." 
				unzip /tmp/$app_name.zip -d "${ROOT_DIR}/client/apps"
				echo "<$app_name> unzip operation done"
				rm /tmp/$app_name.zip
			else
			  >&2 echo "App <$app_name> is not available at: $APP_URL"
			fi
		done
	fi
done
rm /tmp/apps.json