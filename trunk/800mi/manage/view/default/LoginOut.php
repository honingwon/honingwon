<?php
	session_start();
	if(isset($_SESSION['account_ID'])) {
		$_SESSION=array();
        session_destroy();
	 	echo '<SCRIPT>top.location="Login.php";</SCRIPT>';
	}	
?>