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
$database_translation_arr = array(
	'Activation' => 'Activation',
	'We will send this mail, when user registering an account he/she will get an activation request.' => 'We will send this mail, when user registering an account he/she will get an activation request.',
	'Welcome' => 'Welcome',
	'We will send this mail, when user register in this site and get activate.' => 'We will send this mail, when user register in this site and get activate.',
	'Forgot Password' => 'Forgot Password',
	'We will send this mail, when user submit the forgot password form' => 'We will send this mail, when user submit the forgot password form',
	'Change Password' => 'Change Password',
	'We will send this mail to user, when admin change users password.' => 'We will send this mail to user, when admin change users password.',
	'New Board User' => 'New Board User',
	'We will send this mail, when user added for board.' => 'We will send this mail, when user added for board.',
	'Email Notification' => 'Email Notification',
	'We will send this mail, when user activities in this site.' => 'We will send this mail, when user activities in this site.',
	'Due Date Notification' => 'Due Date Notification',
	'We will send this mail, One day before when the card due date end.' => 'We will send this mail, One day before when the card due date end.',
	'System' => 'System',
	'Site Name' => 'Site Name',
	'From Email Address' => 'From Email Address',
	'Reply To Email Address' => 'Reply To Email Address',
	'Label Icon' => 'Label Icon',
	'Contact Email Address' => 'Contact Email Address',
	'Paging Count' => 'Paging Count',
	'Site Timezone' => 'Site Timezone',
	'Default Language' => 'Default Language',
	'Login' => 'Login',
	'Enabled Login Options' => 'Enabled Login Options',
	'Standard' => 'Standard',
	'Server Details' => 'Server Details',
	'Server' => 'Server',
	'Port' => 'Port',
	'Protocol Version' => 'Protocol Version',
	'Base DN' => 'Base DN',
	'Organization' => 'Organization',
	'Connection Details' => 'Connection Details',
	'Account Filter' => 'Account Filter',
	'Bind DN' => 'Bind DN',
	'Bind password' => 'Bind password',
	'Third Party API' => 'Third Party API',
	'Dropbox App Key' => 'Dropbox App Key',
	'Flickr API Key' => 'Flickr API Key',
	'ElasticSearch' => 'ElasticSearch',
	'URL' => 'URL',
	'Index' => 'Index',
	'IMAP' => 'IMAP',
	'IMAP Host' => 'IMAP Host',
	'IMAP Port' => 'IMAP Port',
	'IMAP Email' => 'IMAP Email',
	'IMAP Email Password' => 'IMAP Email Password',
	'Admin' => 'Admin',
	'User' => 'User',
	'Font Awesome class name. Recommended: icon-circle, icon-bullhorn, icon-tag, icon-bookmark, icon-pushpin, icon-star' => 'Font Awesome class name. Recommended: icon-circle, icon-bullhorn, icon-tag, icon-bookmark, icon-pushpin, icon-star',
	'The DNS name or IP address of the server. For example dc.domain.local.' => 'The DNS name or IP address of the server. For example dc.domain.local.',
	'Server port (e.g., 389 for LDAP and 636 for LDAP using SSL)' => 'Server port (e.g., 389 for LDAP and 636 for LDAP using SSL)',
	'Difference betwen LDAPv3 and LDAPv2 ' => 'Difference betwen LDAPv3 and LDAPv2 ',
	'This is your search base for LDAP queries. This should be at least your domain root, for example dc=domain,dc=local You can define this as a Organizational Unit if you want to narrow down the search base. For example: ou=team,ou=company,dc=domain,dc=local' => 'This is your search base for LDAP queries. This should be at least your domain root, for example dc=domain,dc=local You can define this as a Organizational Unit if you want to narrow down the search base. For example: ou=team,ou=company,dc=domain,dc=local',
	'You can use different field from the username here. For pre-windows 2000 style login, use sAMAccountName and for a UPN style login use userPrincipalName.' => 'You can use different field from the username here. For pre-windows 2000 style login, use sAMAccountName and for a UPN style login use userPrincipalName.',
	'Enter a valid user account/DN to pre-bind with if your LDAP server does not allow anonymous profile searches, or requires a user with specific privileges to search.' => 'Enter a valid user account/DN to pre-bind with if your LDAP server does not allow anonymous profile searches, or requires a user with specific privileges to search.',
	'Enter a password for the above Bind DN.' => 'Enter a password for the above Bind DN.',
	'Use encryption (SSL, ldaps:// URL) when connects to server?' => 'Use encryption (SSL, ldaps:// URL) when connects to server?',
	'Enable SSL Connectivity' => 'Enable SSL Connectivity'
);
$t = $t + $database_translation_arr;
ksort($t);
file_put_contents('client/locales/en/translation.json', json_encode($t, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));