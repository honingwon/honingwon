<?php

require_once (dirname(__FILE__).'/ExecuteResult.php');
require_once (dirname(__FILE__).'/ResultStateLevel.php');

class DataResult extends ExcuteResult 
{
	public $DataList = array();
	public $DataGroup = array();
	
   	public function __construct($resultState = ResultStateLevel::SUCCESS, $message = "",$tag = NULL,$datalist = array())
   	{
       	parent::__construct($resultState,$message,$tag);
       	$this->DataList = $datalist;       	
   	}
   	
   	/**
   	 * 添加datagroup   	 * @param $datalist 二维数组
   	 */
   	public function addList($datalist = array())
   	{
   		$this->DataGroup[] = $datalist;
   	}
   	
    var $_explicitType = "dto.DataResult";//amfphp+flex remoting专用,作为类识别
}
?>