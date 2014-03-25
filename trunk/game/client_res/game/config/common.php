<?php
//------------------------------------------------		
// Created : 2013-08-09 20:20:18	
// Description: 根据商店表格式化成QQ购买信息	
// Warning:  由程序自动生成，请不要随意修改！	
//------------------------------------------------		
	class common {	
		private function __construct()	
		{}	
		private static $items  = array(  	
											9001=>'{"id":9001 ,"name":"100银两","glod":100,"price":100,"url":"206100"}', 	
											9002=>'{"id":9002 ,"name":"1000银两","glod":1000,"price":1000,"url":"206101"}', 	
											9003=>'{"id":9003 ,"name":"5000银两","glod":5000,"price":5000,"url":"206102"}', 	
											9004=>'{"id":9004 ,"name":"20000银两","glod":20000,"price":20000,"url":"206103"}' 	
	
										   );	
		public static function getItemInfo($id)	
		{	
			return self::$items[$id];	
		}	
	}	
?>	
