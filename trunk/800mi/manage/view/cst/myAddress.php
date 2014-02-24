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
			<form id="form"><div class="searchForm">
				<input type="hidden" name="id" value="<?php if(isset($_GET['id'])) echo $_GET['id']?>"/>
                <table class="searchForm">
					<tr class="ui-form-item">
                        <td class="label"><label for="name" class="ui-label">门店名称：</label></td>
						<td>
							<input value="<?php if(isset($_GET['name'])) echo $_GET['name']?>" id="name" name="name" class="ui-input text" type="text" />
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
					 <tr class="ui-form-item">
                        <td class="label"><label for="city" class="ui-label">所在地区：</label></td>
						<td>
							<select id="city" name="city">
								<option value="">城市</option>
								<option value="杭州市">杭州市</option>
							</select>
							<select id="district" name="district">
								<option value="">区/县</option>
								<option value="滨江区">滨江区</option>
							</select>
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
					<tr class="ui-form-item">
                        <td class="label"><label for="street" class="ui-label">街道地址：</label></td>
						<td>
							<textarea id="street" class="text" type="input" name="street" style="width:325px;height:60px;"><?php if(isset($_GET['street'])) echo $_GET['street']?></textarea>
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
                    <tr class="ui-form-item">
                        <td class="label"><label for="phone" class="ui-label">手机号码：</label></td>
						<td>
							<input value="<?php if(isset($_GET['phone'])) echo $_GET['phone']?>" id="phone" name="phone" class="ui-input text" type="text" />
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
                    <tr>
                    	<td></td>
                        <td><button class="b-blue" type="submit">保存</button></td>
                    </tr>
                </table>
            </div></form>		
			<table class="dataTab">
                <thead>
                    <tr>
                        <th width="15%">门店名称</th>
                        <th width="15%">所在地区</th>
                        <th width="34%">街道地址</th>
                        <th width="12%">手机</th>
                        <th width="9%"></th>
                        <th width="15%" class="t-r">操作</th>
                    </tr>
                </thead>
                <tbody id="addressList">
                    <tr>
                        <td style="text-align:center;color:gray" colspan='6'>无地址，请添加</td>
                    </tr>
                </tbody>
            </table>
		
		</div>
	</div>
</div>
<?php 
   include_once("foot.php");
?>
<script> 
seajs.use("500mi/address/1.0.0/main");
</script>
</body>
</html>
