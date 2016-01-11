<?php
/**
 * Task for filling language in JSON
 */
unset($argv[0]);
$t = array();
foreach($argv as $folder) {
	$files = glob($folder, GLOB_BRACE);
	foreach ($files as $file) {
		$contents = file_get_contents($file);
		if (preg_match_all('/i18next.t\([\"|\'](.*)[\"|\'][\)|\,]/msU', $contents, $matches)) {
			foreach($matches[1] as $v) {
				$t[$v] = $v;
				if (preg_match('/{{count}}/', $v, $count_matches)) {
					$t[$v . '_plural'] = $v . 's';
				}
			}
		}
	}
}
ksort($t);
file_put_contents('client/locales/en/translation.json', json_encode($t, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));