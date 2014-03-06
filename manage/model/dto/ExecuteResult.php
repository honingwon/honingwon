<?php
require_once ('ResultStateLevel.php');
class ExcuteResult
{
    // 成员声明
   	public $ResultState = 0;
   	public $Success = False;
   	public $Message = "";
   	public $Tag;
   	// 构造函数
	public function __construct($resultState = ResultStateLevel::SUCCESS, $message = "",$tag = NULL)
	{
		if( $resultState == ResultStateLevel::SUCCESS || $resultState == ResultStateLevel::WARNING)
			$this->Success = True;
		$this->ResultState = $resultState;
		$this->Message = $message;
		$this->Tag = $tag;
	}
	// 析构函数
	function __destruct() 
	{  
   	}
   	
    var $_explicitType = "dto.ExcuteResult";
}
?>