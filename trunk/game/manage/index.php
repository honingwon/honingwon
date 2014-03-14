<?php
   require_once('view/common.php');
  if(!isset($_SESSION)){
    		session_start();
  }
  if(!isset($_SESSION['account_ID'])) {
	 	echo '<SCRIPT>top.location="'.MANAGER_PATH.'/view/default/Login.php";</SCRIPT>';
  }	
  else
  		echo '<SCRIPT>top.location="'.MANAGER_PATH.'/view/default/Index.php";</SCRIPT>';
?>