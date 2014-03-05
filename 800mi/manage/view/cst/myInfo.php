<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>500</title>
<link href="css/base.css" rel="stylesheet"/>
<script>
<?php 
if(isset($_GET['op']) )
	echo "var OP='edit'";
else
	echo "var OP='add'";
?>
</script>
</head>

<body id="page-myaddress">
<div class="w_980">
<?php   include_once("head.php");	?>	
	
    <div id="mainBody">
	
	<?php   include_once("side.php");	?>	
		
		<div class="right-container">
		myinfo
		
		</div>
	</div>
</div>
<?php 
   include_once("foot.php");
?>
<script> 
seajs.use("500mi/myinfo/1.0.0/main");
</script>
</body>
</html>
