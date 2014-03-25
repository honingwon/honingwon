<?php
require_once 'OpenApiV3.php';
require_once 'config/common.php';
require_once 'config/config.php';

	if (empty($_POST)) $_POST = $_GET;
	
	if(isset($_POST['method']))
		$methods = $_POST["method"];
	else
		exit;
	switch($methods)
	{
//		case "login":
//			$openid  = $_POST["openid"];
//			$openkey = $_POST["openkey"];
//			$pf      = $_POST["pf"];
//			$host 	 = $_POST["host"];
//			$seqid   = "";
//			if(isset($_POST['seqid'])){
//				$seqid = $_POST['seqid'];
//			}
//			$isStop         = $GLOBALS['ISMAINTAIN'];
//			if($isStop == "1"){
//				echo json_encode(array("stop"=>$isStop));
//			}
//			else{
//				$invkey  	= $_POST["invkey"];
//				$itime 		= $_POST["itime"];
//				$iopenid	= $_POST["iopenid"];
//				echo method_Login($openid,$openkey,$pf,$seqid,$invkey,$itime,$iopenid,$host);
//			}
//			break;
		case "buygoods":
			$openid  = $_POST["openid"];
			$openkey = $_POST["openkey"];
			$pf      = $_POST["pf"];
			$pfkey   = $_POST["pfkey"];
			
			$host 	 = $_POST["host"];
			$item    = $_POST["item"];
			$itemnum = $_POST["itemnum"];
			
			$isPayStop        = $GLOBALS['PAYISMAINTAIN'];
			if($isPayStop == "1"){
				echo json_encode(array("ret"=>1,"msg"=>'购买方案调整，给您带来不便深感抱歉！'));
			}
			else
				echo method_Paytoken($openid,$openkey,$pf,$pfkey,$item,$itemnum,$host);
			break;
//		case "finvkey":
//			$openid  = $_POST["openid"];
//			$openkey = $_POST["openkey"];
//			$pf      = $_POST["pf"];
//			$invkey  	= $_POST["invkey"];
//			$itime 		= $_POST["itime"];
//			$iopenid	= $_POST["iopenid"];
//			echo method_checkinvkey($openid,$openkey,$pf,$invkey,$itime,$iopenid);
//			break;
//		case "vip":
//			$openid  = $_POST["openid"];
//			$openkey = $_POST["openkey"];
//			$pf      = $_POST["pf"];
//			$account = $_POST["account"]; 
//			echo method_getVIPinfo($openid,$openkey,$pf,$account);
//			break;
//		case "Renewal":
//			$openid  = $_POST["openid"];
//			$openkey = $_POST["openkey"];
//			$pf      = $_POST["pf"];
//			fun_RenewalLogin($openid,$openkey,$pf);
//			break;
	}
	
	
	/**
	 * 申请购买物品
	 * @param $openid
	 * @param $openkey
	 * @param $pf
	 * @param $pfkey
	 * @param $item
	 * @param $itemnum
	 */
	function method_Paytoken($openid,$openkey,$pf,$pfkey,$item,$itemnum,$host)
	{
		$item_String = common::getItemInfo($item);
		if($item_String == NULL) 
			return json_encode(array("ret"=>1,"msg"=>'出售的物品不存在！'));
		$server_index = $GLOBALS['ZONE_ID'];
		if($server_index == -1)
			return json_encode(array("ret"=>1,"msg"=>'购买异常请联系游戏客服！'));
		$item_JSON = json_decode($item_String,true);
	    if(isset($item_JSON['id']) && isset($item_JSON['price'])){
	    	$itemID    = $item_JSON['id'];
			$itemname  = $item_JSON['name'];
			$itemprice = $item_JSON['price'];
			$itemDesc  = $item_JSON['name'];
			$itemURL   = "http://app100722626.imgcache.qzoneapp.com/app100722626/1000/store/".$item_JSON['url'].".jpg";
			
			$appkey    = $GLOBALS['APPKEY'];
			$appid     = $GLOBALS['APPID'];
			$ts        = time();
			$payitem   = $itemID.'*'.$itemprice.'*'.$itemnum;
			$goodsmeta = $itemname.'*'.$itemDesc;
			$goodsurl  = $itemURL;
			$zoneid    = $server_index;

			$appmode = "2";//1表示用户不可以修改物品数量，2表示用户可以选择购买物品的数量。 默认为2；
			$sdk = new OpenApiV3($appid, $appkey);
			$sdk->setServerName($GLOBALS['SERVER_NAME']);
		
			$param = array(
				'appid' => $appid,
				'appmode' => $appmode,
				'goodsmeta'=>$goodsmeta,
				'goodsurl'=>$goodsurl,
				'openid' => $openid,
				'openkey'=>$openkey,
				'payitem'=>$payitem,
				'pf' => $pf,
				'pfkey'=>$pfkey,
				'ts'=>$ts,
				'zoneid'=>$zoneid
			);
			
			$response =$sdk->api('/v3/pay/buy_goods', $param,'post','https');
			
			if(isSet($response['ret'])){
				$key_token = "";
				
				if($response['ret'] == 0){
					return json_encode(array("ret"=>$response['ret'],
											 "url_params"=>$response['url_params'],
											 "token"=>$response['token']));
				}
				else{
					$errormsg = "返回异常";
					if(isSet($response['msg']))
						$errormsg = $response['msg'];
					return json_encode(array("ret"=>$response['ret'],"msg"=>$errormsg));
				}
			}
			else
		   		return json_encode(array("ret"=>1,"msg"=>'请求异常,请联系客服人员！'));
		}
		else{
			return json_encode(array("ret"=>1,"msg"=>'出售的物品不存在！'));
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
?>