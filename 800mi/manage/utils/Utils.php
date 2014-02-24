<?php
class Utils {
	 
	public static function getServerData($url,$params, $postParams = false) {
		$ret = -100;
		foreach ( $params as $key => $value ) {
			$url .= $key . "=" . $value . "&";
		}
		if ((! empty ( $postParams )) && is_array ( $postParams )) {
			$post_string = http_build_query ( $postParams );
			$context = array ('http' => array ('method' => 'POST', 'header' => 'Content-type: application/x-www-form-urlencoded' . "\r\n" . 'User-Agent : Jimmy' . "\r\n" . 'Content-length: ' . strlen ( $post_string ), 'content' => $post_string ) );
			$stream_context = stream_context_create ( $context );
			$ret = @file_get_contents ( $url, FALSE, $stream_context );
		} else {
			try
			{
				$ret = @file_get_contents ( $url );
			}
			catch(Exception $e){
				$ret = 100;
			}
		}
		return $ret;
			
	}

	//取得客户IP 
	public static function get_client_ip()
	{
		if(!empty($_SERVER["HTTP_CLIENT_IP"])){
			$cip = $_SERVER["HTTP_CLIENT_IP"];
		}
		elseif(!empty($_SERVER["HTTP_X_FORWARDED_FOR"])){
			$cip = $_SERVER["HTTP_X_FORWARDED_FOR"];
		}
		elseif(!empty($_SERVER["REMOTE_ADDR"])){
			$cip = $_SERVER["REMOTE_ADDR"];
		}
		else{
			$cip = "127.0.0.1";
		}
		return $cip;
	}

	//防sql注入字符串验证
	public static function check_input($value)
	{
		// 去除斜杠 
		if (get_magic_quotes_gpc())
		{
			$value = stripslashes($value);
		}
		// 假如不是数字则加引号 
		if (!is_numeric($value))
		{
			$value = "'" . mysql_escape_string($value) . "'";
		}
		return $value;
	}
	
		public static function validateSign($username,$time,$cm,$sign){
			$temp_sign = md5($username.$time.$GLOBALS['PLATFORM_KEY'].$cm);
			if($sign == $temp_sign)
				return true;
			else
				return false;
		}
		
		public static function validatePayTicket($Mode,$PayNum,$PayToUser,$PayMoney,$PayGold,$PayTime,$ticket){
			$temp_sign = md5($GLOBALS['PAY_KEY'].$Mode.$PayNum.$PayToUser.$PayMoney.$PayGold.$PayTime);
			//echo $temp_sign."<br/>";
			if($ticket == $temp_sign)
				return true;
			else
				return false;
		}
		
		/**
		 * 数组转为json
		 * @param unknown_type $arr
		 */
		public static function arrayToJson($arr) { 
			if(function_exists('json_encode')) return json_encode($arr); //Lastest versions of PHP already has this functionality.  
			$parts = array();   
			$is_list = false; 
			//Find out if the given array is a numerical array   
			$keys = array_keys($arr); 
			$max_length = count($arr)-1;  
			if(($keys[0] == 0) and ($keys[$max_length] == $max_length)) {//See if the first key is 0 and last key is length - 1    
				$is_list = true;   
				for($i=0; $i<count($keys); $i++) { //See if each key correspondes to its position       
					if($i != $keys[$i]) { //A key fails at position check.          
						$is_list = false; //It is an associative array.           
						break;      
					}   
				} 
			}    
			foreach($arr as $key=>$value) { 
				if(is_array($value)) { //Custom handling for arrays      
					if($is_list) $parts[] = array2json($value); /* :RECURSION: */       
					else $parts[] = '"' . $key . '":' . array2json($value); /* :RECURSION: */  
				} 
				else {      
					$str = '';          
					if(!$is_list) $str = '"' . $key . '":';           
					//Custom handling for multiple data types           
					if(is_numeric($value)) $str .= $value; //Numbers           
					elseif($value === false) $str .= 'false'; //The booleans          
					elseif($value === true) $str .= 'true';          
					else $str .= '"' . addslashes($value) . '"'; //All other things        
					// :TODO: Is there any more datatype we should be in the lookout for? (Object?)           
					$parts[] = $str;  
				} 
			}   
			$json = implode(',',$parts);   
			if($is_list) return '[' . $json . ']';//Return numerical JSON 
			return '{' . $json . '}';//Return associative JSON 
		}


}
?>