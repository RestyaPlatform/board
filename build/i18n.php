<?php
/**
 * Task for filling language in JSON
 */
$app_path = dirname(dirname(__FILE__));
require_once ($app_path. DIRECTORY_SEPARATOR . 'server' . DIRECTORY_SEPARATOR . 'php' . DIRECTORY_SEPARATOR . 'config.inc.php');
unset($argv[0]);
$t = array();
foreach($argv as $folder) {
	$files = glob($folder, GLOB_BRACE);
	foreach ($files as $file) {
		$contents = file_get_contents($file);
		if (preg_match_all('/i18next.t\([\"|\'](.*)[\"|\'|\}]\)/msU', $contents, $matches)) {
			foreach($matches[1] as $v) {
				// Quick fix to split and create text from sprintf
				if (preg_match('/i18next.t\([\"|\'](.*)/', $v, $matches)) {
					$t[$matches[1]] = $matches[1];
				}
				// Quick fix to split main text from sprintf
				if (preg_match('/[\'|\"]\,\s*\{/', $v, $matches, PREG_OFFSET_CAPTURE)) {
					$v = substr($v, 0, $matches[0][1]);
				}
				$t[$v] = $v;
				// Quick fix to generate new translation record for count
				if (preg_match('/{{count}}/', $v, $count_matches)) {
					$t[$v . '_plural'] = $v . 's';
				}
			}
		}
	}
}

$database_tables_array = array();
$settings_result = pg_query_params($db_lnk, 'select label, description from settings', array());
while ($settings_row = pg_fetch_assoc($settings_result)) {
	$database_tables_array[$settings_row['label']] = $settings_row['label'];
	if(!empty($settings_row['description'])) {
		$database_tables_array[$settings_row['description']] = $settings_row['description'];	
	}
}
$setting_categories_result = pg_query_params($db_lnk, 'select name, description from setting_categories', array());
while ($setting_categories_row = pg_fetch_assoc($setting_categories_result)) {
	$database_tables_array[$setting_categories_row['name']] = $setting_categories_row['name'];
	if(!empty($setting_categories_row['description'])) {
		$database_tables_array[$setting_categories_row['description']] = $setting_categories_row['description'];	
	}
}
$email_templates_result = pg_query_params($db_lnk, 'select display_name, description from email_templates', array());
while ($email_templates_row = pg_fetch_assoc($email_templates_result)) {
	$database_tables_array[$email_templates_row['display_name']] = $email_templates_row['display_name'];
	if(!empty($email_templates_row['description'])) {
		$database_tables_array[$email_templates_row['description']] = $email_templates_row['description'];	
	}
}

$json = json_decode(file_get_contents($app_path . DIRECTORY_SEPARATOR . 'client' . DIRECTORY_SEPARATOR . 'apps' . DIRECTORY_SEPARATOR . 'apps.json'), true);
$auto_json_arr = array();
foreach($json as $data) {
	$auto_json_arr[$data['name']] = $data['name'];
	$auto_json_arr[$data['description']] = $data['description'];
	if(!empty($data['settings_description'])) {
		$auto_json_arr[$data['settings_description']] = $data['settings_description'];
	}
	if(!empty($data['settings'])) {
		foreach($data['settings'] as $settings_data) {
			$auto_json_arr[$settings_data['label']] = $settings_data['label'];		
		}
	}
}

$translation_arr = array(
	'Admin' => 'Admin',
	'User' => 'User',
	'Owner' => 'Owner',
	'Editor' => 'Editor',
	'Viewer' => 'Viewer',
	'Guest' => 'Guest',
);
$database_translation_arr = array_merge($auto_json_arr, $translation_arr, $database_tables_array);
$t = $t + $database_translation_arr;
ksort($t);
file_put_contents('client/locales/en_US/translation.json', json_encode($t, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));