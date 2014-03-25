<?php 
   include_once("../common.php");
   require_once(DATACONTROL . '/BMAccount/IsLogin.php');	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>500</title>
<link href="css/base.css" rel="stylesheet"></link>
<script>
<?php
echo ';var OP ='.$_GET['op'];
echo ';var LV ='.$_GET['lv'];
?>
</script>
</head>

<body id="typePage">
<div class="w_980">	
<?php   include_once("head.php");	?>

    <div id="mainBody">
		<div class="left-nav">
			<h2>商品类型管理</h2>
			<ul>
				<li <?php if($_GET['op'] == 1 && $_GET['lv']==1) echo' class="select"';?>><a href="/view/cst/type.php?op=1&lv=1">添加一级类型</a></li>
				<li <?php if($_GET['op'] == 1 && $_GET['lv']==2) echo' class="select"';?>><a href="/view/cst/type.php?op=1&lv=2">添加二级类型</a></li>
				<li <?php if($_GET['op'] == 1 && $_GET['lv']==3) echo' class="select"';?>><a href="/view/cst/type.php?op=1&lv=3">添加三级类型</a></li>
				<li <?php if($_GET['op'] == 2 && $_GET['lv']==1) echo' class="select"';?>><a href="/view/cst/type.php?op=2&lv=1">修改一级类型</a></li>
				<li <?php if($_GET['op'] == 2 && $_GET['lv']==2) echo' class="select"';?>><a href="/view/cst/type.php?op=2&lv=2">修改二级类型</a></li>
				<li <?php if($_GET['op'] == 2 && $_GET['lv']==3) echo' class="select"';?>><a href="/view/cst/type.php?op=2&lv=3">修改三级类型</a></li>
			</ul>
		</div>
        <div class="right-container"><form id="form">
			<div class="searchForm">
                <table class="searchForm">
					<?php 
						$op = $_GET['op'];
						$lv = $_GET['lv'];
						//添加
						if($op==1)
						{
							if($lv != 1)
							{echo 
								'<tr class="ui-form-item">
									<td class="label"><label for="type" class="ui-label">上一级类型</label></td>
									<td>
										<select id="type" name="type">
											<option value="">请选择</option>
										</select>
										<span class="ui-form-explain"></span>
									</td>
								</tr>';}
						}
						else
						{
							echo 
								'<tr class="ui-form-item">
									<td class="label"><label for="type" class="ui-label">需要修改的类型</label></td>
									<td>
										<select id="type" name="type">
											<option value="">请选择</option>
										</select>
										<span class="ui-form-explain"></span>
									</td>
								</tr>';
						}
					?>
					<tr class="ui-form-item">
						<td class="label"><label for="name" class="ui-label">类型名称</label></td>
						<td>
							<input id="name" class="text" type="input" size='25' name="name" />
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
					<tr class="ui-form-item">
						<td class="label"><label for="order" class="ui-label">排序</label></td>
						<td>
							<input id="order" class="text" type="input" size='25' name="order" />
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
                    <tr>
                    	<td></td>
                        <td><button class="b-blue" type="submit">保存</button></td>
                    </tr>
                </table>
			</div>		
		</form></div>
    </div>
</div>
<?php 
   include_once("foot.php");
?>
<script>
<?php
if($_GET['op'] == 1)
{ echo 'seajs.use("500mi/type/1.0.0/typeAdd")';}
else
{ echo 'seajs.use("500mi/type/1.0.0/typeEdit")';}
?>
</script>
</body>
</html>
