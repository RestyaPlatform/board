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
ksort($t);
file_put_contents('client/locales/en/translation.json', json_encode($t, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));