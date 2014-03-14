<?php

require_once(dirname(__FILE__).'/../config/config.php');
require_once(dirname(__FILE__)."/Logger.php");

function sql_connectDyn($host,$user,$PWD,$name,$key,$port)
	{
		$GLOBALS[$key] = new mysqli($host,$user,$PWD,$name,$port);
		if(!$GLOBALS[$key]) {
			throw new Exception(mysqli_connect_errno());
		}
		$GLOBALS[$key]->set_charset($GLOBALS['DB_CHATSET']);
	}

	function get_connectDyn($host,$user,$PWD,$name,$key,$port){
		if(!isSet($GLOBALS[$key]) || !$GLOBALS[$key])
		sql_connectDyn($host,$user,$PWD,$name,$key,$port);

		return $GLOBALS[$key];
	}

	/**
	 * 执行一行代码（无结果集）
	 * @param $sql
	 */
	function sql_queryDyn($sql,$host,$user,$PWD,$name,$key,$port)
	{
		$link = get_connectDyn($host,$user,$PWD,$name,$key,$port);
		
		$r = $link->query($sql);
		
		if($r == false)
		{
			$errno=mysqli_connect_errno();
			if($errno == 2006) {// mysql has gone away， 重新连接一下
				sql_connectDyn();

				$r = $link->query($sql);
				if($r == false) {
					$GLOBALS[$key] = null ;
					throw new Exception(mysqli_connect_errno(). ": " . $errno);
				}
			} else{
				$GLOBALS[$key] = null ;
				throw new Exception(mysqli_connect_errno(). ": " . $errno);
			}
		}
			
		return $r;
	}
	
	/**
	 * 获取记录集
	 * @param $sql
	 * @param $host
	 * @param $user
	 * @param $PWD
	 * @param $name
	 * @param $key
	 * @param $port
	 */
	function sql_fetch_rowsDyn($sql,$host,$user,$PWD,$name,$key,$port)
	{
		$link = get_connectDyn($host,$user,$PWD,$name,$key,$port);
		$ret = array();
		$stime = my_microtime_floatDyn();
		if($link->real_query($sql)){
			loginfo($stime,$sql);
			if ($r = $link->store_result()) {
				while( $row = $r->fetch_row()){
					$ret[] = $row;
				}
				$r->close();
				while($link->next_result()){};
			}
		}
		return $ret;
	}
	
	/**
	 * 获取多个结果集
	 * @param $sql
	 */
	function sql_fetch_tablesDyn($sql,$host,$user,$PWD,$name,$key,$port)
	{
		$link = get_connectDyn($host,$user,$PWD,$name,$key,$port);
		$ret = array();
		if($link->multi_query($sql)){
			do{
				if ($r = $link->store_result()) {
		            $tb = array();
					while ($row = $r->fetch_row()) {
		                $tb[] = $row;
		            }
		            $ret[] = $tb;
	            	$r->close();
	        	}
			}
			while($link->next_result());
		}
		return $ret;
	}
	
	/**
	 * 返回一条记录  无记录则返回空字符串
	 * @param $sql
	 * @param $host
	 * @param $user
	 * @param $PWD
	 * @param $name
	 * @param $key
	 * @param $port
	 */
	function sql_fetch_oneDyn($sql,$host,$user,$PWD,$name,$key,$port)
	{
		$link = get_connectDyn($host,$user,$PWD,$name,$key,$port);
		$stime = my_microtime_floatDyn();
		if($link->real_query($sql)){
			loginfo($stime,$sql);
			if ($r = $link->store_result()) {
				$row = $r->fetch_row();
				$r->close();
				while($link->next_result()){};
				return $row;
			}
		}
		return "";
	}
	
	 /**
	  * 返回一个数据
	  * @param unknown_type $sql
	  * @param unknown_type $host
	  * @param unknown_type $user
	  * @param unknown_type $PWD
	  * @param unknown_type $name
	  * @param unknown_type $key
	  * @param unknown_type $port
	  * @return unknown|number
	  */
	function sql_fetch_one_cellDyn($sql,$host,$user,$PWD,$name,$key,$port)
	{
		$link = get_connectDyn($host,$user,$PWD,$name,$key,$port);
		$stime = my_microtime_floatDyn();
		if($link->real_query($sql)){
			loginfo($stime,$sql);
			if ($r = $link->store_result()) {
				$row = $r->fetch_row();
				$r->close();
				while($link->next_result()){};
				return $row[0];
			}
		}
		return 0;
	}
	
	/**
	 * 插入数据  返回是否成功
	 * @param $sql
	 * @param $host
	 * @param $user
	 * @param $PWD
	 * @param $name
	 * @param $key
	 * @param $port
	 */
	function sql_insertNoCellDyn($sql,$host,$user,$PWD,$name,$key,$port)
	{
		$link = get_connectDyn($host,$user,$PWD,$name,$key,$port);
		if(!$link) {
			throw new Exception(mysqli_connect_errno());
		}
		$r = $link->query($sql);				
		$stime = my_microtime_floatDyn();
		loginfo($stime,$sql);
		return $r;
	}
	
	function loginfo($stime,$sql)
	{
		$querytime = my_microtime_floatDyn()- $stime;
		if($querytime > 1000 )
			$GLOBALS['LOGGER']->info("exectime: ".$querytime." ".$sql);
	}
	function my_microtime_floatDyn()
	{
   		list($usec, $sec) = explode(" ", microtime());
   		return ((float)$usec + (float)$sec) * 1000;
	}
?>