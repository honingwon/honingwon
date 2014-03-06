<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php echo systemTitle;?></title>
<script type="text/javascript" src="<?php echo JS_DIR?>/common/jquery.js" ></script>
</head>

<frameset rows="62,*" cols="*" frameborder="no" border="0" framespacing="0">
  <frame src="header.php" name="topFrame" id="topFrame" scrolling="no" noresize="noresize" title="Header" />
  <frameset cols="160,*" frameborder="no" border="0" framespacing="0">
    <frame src="side.php" name="leftFrame" id="leftFrame" noresize="noresize" title="subMenu" />
    <frame src="default.php" name="mainFrame" id="mainFrame" title="mainBody" />
  </frameset>
</frameset>
<noframes>
<body>您所使用的浏览器不支持框架！</body>
</noframes>
</html>
