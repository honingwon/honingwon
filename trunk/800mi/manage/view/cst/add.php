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
</head>

<body id="index">
<div class="w_980">	
<?php   include_once("head.php");	?>

    <div id="mainBody">
        <div class="right-container"><form id="form">
			<div class="searchForm">
                <table class="searchForm">
                    <tr class="ui-form-item">
                        <td class="label"><label for="brandId" class="ui-label">品牌</label></td>
						<td>
							<!--<input id="brandId" name="brandId" class="ui-input text" type="text" />-->
							<select id="brandId" name="brandId">
								<option value="">请选择</option>
							</select>
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
					<tr class="ui-form-item">
                        <td class="label"><label for="type3Id" class="ui-label">类型</label></td>
                        <td>
							<!--<input class="text" type="input" size='25' name="type3Id" value=1 />-->
							<select id="type3Id" name="type3Id">
								<option value="">请选择</option>
							</select>
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
					<tr>
                        <td class="label">条形码</td>
                        <td><input class="text" type="input" size='25' name="barcode" /></td>
                    </tr>
					<tr>
                        <td class="label">名称</td>
                        <td><input class="text" type="input" size='25' name="name" /></td>
                    </tr>
					<tr>
                        <td class="label">重量</td>
                        <td><input class="text" type="input" size='25' name="weight" /></td>
                    </tr>
					<tr>
                        <td class="label">开始时间</td>
                        <td><input class="text" type="input" size='25' name="stime" /></td>
                    </tr>
					<tr>
                        <td class="label">结束时间</td>
                        <td><input class="text" type="input" size='25' name="etime" /></td>
                    </tr>
					<tr class="ui-form-item">
                        <td class="label"><label for="fileToUpload" class="ui-label">图片</label></td>
						<td>

							<input size='25' class="text" type="hidden" name="picUrl" id="picUrl" />
							<span id="fileToUploadWrapper">
								<input name="fileToUpload" id="fileToUpload" style="width:150px" type="file" /> 
								<button id="doUpload">上传</button>
							</span>
							<span class="ui-form-explain"></span>
						</td>
                    </tr>
					<tr>
                        <td class="label">数量</td>
                        <td><input class="text" type="input" size='25' name="number" /></td>
                    </tr>
					<tr>
                        <td class="label">单位</td>
                        <td><input class="text" type="input" size='25' name="unit" /></td>
                    </tr>
					<tr>
                        <td class="label">价格</td>
                        <td><input class="text" type="input" size='25' name="price" /></td>
                    </tr>
					
					<tr>
                        <td class="label">优惠价</td>
                        <td><input class="text" type="input" size='25' name="aprice" /></td>
                    </tr>
					<tr>
                        <td class="label">备注</td>
                        <td><input class="text" type="input" size='25' name="remark" /></td>
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
seajs.use("500mi/add/1.0.0/main");
</script>
</body>
</html>
