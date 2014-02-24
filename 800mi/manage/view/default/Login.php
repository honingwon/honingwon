<?php
    include_once("../common.php");  
 	require_once(DATACONTROL . '/BMManage/AccountProvider.php');
 	require_once(DATACONTROL . '/BMManage/ModuleManageProvider.php'); 
 	require_once(DATAMODEL . '/BMManage/AccountMDL.php'); 
 	require_once(DATAMODEL. "/dto/Result.php");
 		
	if(isset($_SESSION['account_ID'])) {
	 	echo '<SCRIPT>top.location="Index.php";</SCRIPT>';
	}
	if (isset($_POST['Submit']) && $_POST['Submit'] == loginBtnName)
	{
		
		$result = AccountProvider::getInstance()->Login($_POST['userId'],$_POST['password']);
		
		if($result->Success){			
			$r = ModuleManageProvider::getInstance()->GetModuleRights();
	 		echo '<SCRIPT>top.location="Index.php";</SCRIPT>';
		}
		else
			echo'<SCRIPT language="JavaScript">window.alert("'.loginErrormsg1.'");</SCRIPT>';	
	}
?>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo systemTitle;?></title>
<link href="../css/login.css" rel="stylesheet" type="text/css">
<link href="../css/base.css" rel="stylesheet" type="text/css">
<script>
	function btnSubmit()
	{
		var userID = document.getElementById('userId');
		if(userID.value == ""){
			showMsg(false,"<?php echo loginErrormsg2;?>");
			userID.focus();
			return false;
		}
		var pwdID = document.getElementById('password');
		if(pwdID.value == ""){
			showMsg(false,"<?php echo loginErrormsg3;?>");
			pwdID.focus();
			return false;
		}
		showMsg(true,"");
		return true;
	}

	function showMsg(falg,msg){
		if(!falg){
			document.getElementById('msg').innerHTML =msg;
			document.getElementById('msg').style.visibility="visible";
		}
		else
			document.getElementById('msg').style.visibility="hidden";
	}
</script>
</head>

<body>
<div class="top">
  <a href="javascript:void(0);" class="logo"></a>
</div>
<div class="main">
  <ul><form name="form1" method="post" action="Login.php">
    <li>
        <label for="textfield"><?php echo loginUserName;?>：</label>
        <input class="txt01" type="text" name="userId" id="userId">
    </li>
    <li>
      <label for="textfield2"><?php echo loginUserPWD;?>：</label>
      <input class="txt01" type="password" name="password" id="password">
    </li>
    <li class="login">
      <input class="log"  name="Submit" type="Submit" value="<?php echo loginBtnName;?>" onclick ="return btnSubmit();" />
    </li>
    <li> 
    <div class="errorTip" id="msg" style="visibility:hidden" ><?php echo loginErrormsg1;?></div>
    </li>
    </form>
  </ul>
</div>
<!--<form action="/auth/?_c=auth&_a=test" method="POST">
<textarea name='aa'></textarea>
<input type='submit' value='submit'/>
</form>-->
</body>
</html>
