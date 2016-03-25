<?php 
class Ejabberd_Wrapper {

	private static $ejabberdHost = JABBER_HOST;
	
	private static function runCommand($argsString) {
		if ($GLOBALS['environment'] == 'dev') {
			er("args to ejabberd: $argsString");
			return true;
		}
		exec('sudo '. JABBER_PATH .' '  . $argsString . ' 2>&1',$output,$status);
		error_log('sudo '. JABBER_PATH.' '  . $argsString . ' 2>&1' . print_r($output,true). print_r($status,true)."\n", 3, 'ejabberd.log');
		error_log("command status: $status", 3, ERROR_LOG);
	    if($status == 0)
	    {
	       error_log("'$argsString' ran successfully\n", 3, ERROR_LOG);
	       return true;
	    }
	    else
	    {
	        error_log("problem runing command $argsString: " . print_r($output,true), 3, ERROR_LOG);
	        return false;
	    }
	}
	
	public static function register ($username, $password) {
		return self::runCommand("register " . escapeshellarg($username) . " " . self::$ejabberdHost . " " . escapeshellarg($password) );	
	}
	
	public static function unregister ($username) {
		return self::runCommand("unregister " . escapeshellarg($username) . " " . self::$ejabberdHost );
	}
	
	public static function ban_account($userName, $reason) {
		return self::runCommand("ban_account " . escapeshellarg($userName) . " " . self::$ejabberdHost . " " . escapeshellarg($reason) );
	}
	
	public static function change_password($userName,$newPass) {
		return self::runCommand("change_password " . escapeshellarg($userName) . " " . self::$ejabberdHost . " " . escapeshellarg($newPass) );
	}
	
	public static function srg_create($groupName, $groupDescription = '') {
		/*
		 * srg_create group host name description display 
		 */
		return self::runCommand("srg_create " . escapeshellarg($groupName) . " " . self::$ejabberdHost . " " . escapeshellarg($groupName) . " " . escapeshellarg($groupDescription) . " " . escapeshellarg($groupName) );
		
	}
	
	public static function srg_delete($groupName) {
		
		return self::runCommand("srg_delete " . escapeshellarg($groupName) . " " . self::$ejabberdHost );
	}
	
	public static function srg_user_add($userName, $groupName) {
		/*
		srg_user_add user host group grouphost 
        Add the JID user@host to the Shared Roster Group 
        */
		return self::runCommand("srg_user_add " . escapeshellarg($userName) . " " . self::$ejabberdHost . " " . escapeshellarg($groupName) . " " . self::$ejabberdHost );
	}
	
	public static function srg_user_del($userName, $groupName) {
		return self::runCommand("srg_user_del " . escapeshellarg($userName) . " " . self::$ejabberdHost . " " . escapeshellarg($groupName) . " " . self::$ejabberdHost );
	}
	
	/*
	 * MUC Stuff (from mod_muc_admin)
	 */
	/*
	 * create_room name service host 
        Create a MUC room name@service in host 
	 */
	public static function create_room($roomName) {
		return self::runCommand("create_room " . escapeshellarg($roomName) . " conference." . self::$ejabberdHost . " " . self::$ejabberdHost);
	}
	/*
	 * destroy_room name service host 
        Destroy a MUC room
	 */
	public static function destroy_room($roomName) {
		return self::runCommand("destroy_room " . escapeshellarg($roomName) . " conference." . self::$ejabberdHost . " " . self::$ejabberdHost );
	}
	
	/*
	 * get_room_occupants name service 
        Get the list of occupants of a MUC room 
	 */
	public static function get_room_occupants($roomName) {
		return self::runCommand("get_room_occupants " . escapeshellarg($roomName) . " conference." . self::$ejabberdHost );;
	}
	
	/*
	 * get_user_rooms name service 
        Get the list of rooms of a user 
	 */
	public static function get_user_rooms($user_real_jid) {
		return self::runCommand("get_user_rooms " . escapeshellarg($user_real_jid) . " conference." . self::$ejabberdHost );;
	}
	
	/*
	 * muc_online_rooms host 
        List existing rooms ('global' to get all vhosts) 
	 */
	public static function muc_online_rooms($host = 'global') {
		return self::runCommand("muc_online_rooms ". escapeshellarg($host));
	}
	/*
	 * send_direct_invitation room password reason users 
        Send a direct invitation to several destinations 
	 */
	public static function send_direct_invitation($room, $password = '',$reason = '', $users = array()) {
		$uString = '';
		foreach ($users as $user) {
			$uString .= escapeshellarg($user) . '@'  . self::$ejabberdHost . ' ';
		}
		return self::runCommand("send_direct_invitation " . $room . "@conference." . self::$ejabberdHost . " " . $password . " " . $reason . " " . $users);
	}
	/*
	 * set_room_affiliation name service jid affiliation
	 * allowed affiliations: array('Owner', 'Admin', 'Member', 'Outcast', 'None')
	 * 
	 */
	public static function set_room_affiliation($groupName, $userName, $affiliation) {
		if (!in_array($affiliation , array('owner', 'admin', 'member', 'outcast', 'none'))) {
			return false;
		}
		return self::runCommand("set_room_affiliation " . $groupName . " " . "conference." . self::$ejabberdHost . " " . $userName . "@" . self::$ejabberdHost . " " . $affiliation);
	}
}