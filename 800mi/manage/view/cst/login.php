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
	 		echo '<SCRIPT>top.location="index.php";</SCRIPT>';
		}
		else
			echo'<SCRIPT language="JavaScript">window.alert("'.loginErrormsg1.'");</SCRIPT>';	
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>500</title>
<link href="css/login.css" rel="stylesheet"></link>
<script>
(function(root){
	function btnSubmit()
	{
		var userID = document.getElementById('userId');
		if(userID.value == ""){
			showMsg(false,"请输入用户名！");
			userID.focus();
			return false;
		}
		var pwdID = document.getElementById('password');
		if(pwdID.value == ""){
			showMsg(false,"请输入密码！");
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
	root.btnSubmit = btnSubmit;	
})(this);
</script>
</head>

<body>
<div class="login">
	<div class="web-info">
    	<h2>超市通</h2>
        <dl>
        	<dt>一键完成订单所有操作，免去线上繁琐订货步骤！</dt>
            <dd>1、电话申请入驻超市通</dd>
            <dd>2、登录挑选进货物品</dd>
            <dd>3、提交进货清单</dd>
            <dd>4、坐等收货</dd>
        </dl>        
        <ul>
        	<li class="i1">
            	<h3>超市进货</h3>
                <span>0571-87382079</span>
            </li>
            <li class="i2">
            	<h3>供应商入驻</h3>
                <span>0571-87382079</span>
            </li>
        </ul>
    </div>
    <div class="form-login"><form name="form1" method="post" action="Login.php">
    	<h2>用户登录</h2>
        <div class="field">
        	<label>手机号码/用户名</label>
            <input type="text" class="input" name="userId" id="userId" />
            <label>密码</label>
            <input type="password" class="input pwd" name="password" id="password"/>            
            <p class="rememb"><label><input type="checkbox" />记住 (两周免登录)</label><span id="msg" class="error"></span></p>
            <p class="btn"><button type="submit" onclick ="return btnSubmit();" name="Submit" value="登录">登录</button></p>
			<p style="padding:5px 0 0"><a href="reg.php">免费注册</a></p>
        </div>
    </div></form>
</div>
<div id="footer">
	<p>Copyright© 超市通 2013，All Rights Reserved 浙ICP备12019345</p>
</div>
</body>
</html>
