<?php
	require_once(dirname(__FILE__)."/../config/config.php");
	
	function sql_connect()
	{
		$GLOBALS['connection'] = new mysqli($GLOBALS['DB_HOST'],$GLOBALS['DB_USER'],$GLOBALS['DB_PASSWORD'],$GLOBALS['DB_NAME'],$GLOBALS['DB_PORT']);
		if(!$GLOBALS['connection']) { 
			throw new Exception(mysqli_connect_errno());
		}
		$GLOBALS['connection']->set_charset($GLOBALS['DB_CHATSET']);
	}
	
	function get_connect(){
		if(!isSet($GLOBALS['connection']) || !$GLOBALS['connection'])
			sql_connect();
		
		return $GLOBALS['connection'];
	}
	
	/**
	 * 执行一行代码（无结果集）
	 * @param $sql
	 */
	function sql_query($sql)
	{
		$link = get_connect();
		
		$r = $link->query($sql);
		
		if($r == false)
		{
			$errno=mysqli_connect_errno();
			if($errno == 2006) {// mysql has gone away， 重新连接一下
				sql_connect();

				$r = $link->query($sql);
				if($r == false) {
					$GLOBALS['connection'] = null ;
					throw new Exception(mysqli_connect_errno. ": " . $errno);
				}
			} else{
				$GLOBALS['connection'] = null ;
				throw new Exception(mysqli_connect_errno. ": " . $errno);
			}
		}
			
		return $r;
	}
	
	/**
	 * 返回一条记录  无记录则返回空字符串""
	 * @param $sql
	 * @return unknown_type
	 */
	function sql_fetch_one($sql)
	{
		$link = get_connect();
		if($link->real_query($sql)){
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
	 * @param $sql
	 * @return unknown_type
	 */
	function sql_fetch_one_cell($sql)
	{
		$link = get_connect();
		if($link->real_query($sql)){
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
	 * 获取记录集
	 * @param $sql
	 * @return unknown_type
	 */
	function sql_fetch_rows($sql)
	{
		$link = get_connect();
		$ret = array();
		if($link->real_query($sql)){
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
	function sql_fetch_tables($sql)
	{
		$link = get_connect();
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
	 * 插入数据
	 * @param $sql
	 * @return unknown_type
	 */
	function sql_insert($sql)
	{
		sql_query($sql);
			
		return sql_fetch_one_cell('select last_insert_id()');
	}
	
	/**
	 * 获取一个对象
	 * @param $table 表名
	 * @param $id 字段值
	 * @param $idname 字段
	 * @return unknown_type 一条记录
	 */
	function sql_fetch_object($table, $id, $idname="id")
	{
		return sql_fetch_one("SELECT * FROM `$table` WHERE `$idname`=$id");
	}
	
	/**
	 * 插入一个对象
	 * @param unknown_type $table
	 * @param unknown_type $obj
	 * @return sql字符串
	 */
	function sql_insert_object($table, $obj)
	{
		if(!$obj)
			return 0;
			
		$sql = "INSERT INTO `$table` ";
		$keys = "(";
		$values = "(";
		$r = "";
		foreach ($obj as $key=>$value)
		{
			$keys .= ( $r . "`".$key."`");
			$values .= ( $r . "'" . $value . "'");
			$r = ",";
		}
		$keys .= ")";
		$values .= ")";
		$sql = $sql . $keys . " VALUES " . $values;
		return sql_insert( $sql);
	}
	
	/**
	 * REPLACE 一个对象p
	 * @param $table
	 * @param $obj
	 * @return sql字符串
	 */
	function sql_replace_object($table, $obj)
	{
		if(!$obj)
			return 0;
			
		$sql = "REPLACE INTO $table ";
		$keys = "(";
		$values = "(";
		$r = "";
		foreach ($obj as $key=>$value)
		{
			$keys .= ( $r . "`" . $key . "`");
			$values .= ( $r . "'" . $value . "'");
			$r = ",";
		}
		$keys .= ")";
		$values .= ")";
		$sql = $sql . $keys . " VALUES " . $values;
		return sql_insert( $sql);
	}
	
	/**
	 * REPLACE 多个对象
	 * @param $table
	 * @param $objs
	 * @return unknown_type
	 */
	function sql_replace_objects($table, $objs)
	{
		if($objs) foreach($objs as $key=>$value)
		{
			sql_replace_object($table, $value);
		}
	}
	
	/**
	 * 是否有记录
	 * @param $sql
	 * @return 是否有记录
	 */
	function sql_check($sql) 
	{
		$r = sql_query($sql);
		
		if (empty($r)) {
			return false;
		}
		
		if (mysql_num_rows($r) > 0) {
			return true;
		} else {
			return false;
		}
	}
?>