<?php 	
 require_once(DATAMODEL . '/BMAccount/ModuleMDL.php');
    
	if(!isset($_SESSION)){
    		session_start();
	}
	if(!isset($_SESSION['account_ID'])) {
	 	echo '<SCRIPT>top.location="'.MANAGER_PATH.'/index.php";</SCRIPT>';
	}	
?>