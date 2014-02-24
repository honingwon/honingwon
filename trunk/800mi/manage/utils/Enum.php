<?php
abstract class Enum
{
	private $FValues;
	/**
	 * 添加元素
	 * @param unknown_type $Element
	 * @return unknown_type
	 */
	protected function add($Element) 
	{
		 $this->FValues[$Element] = $Element;
	}
	abstract protected function init();
	
	/**
	 * 获取值
	 * @param $Element
	 * @return unknown_type
	 */
 	public static function get($Element) 
 	{
 		if (array_key_exists($Element, $this->FValues)) 
 		{
 			return ($this->FValues[$Element]);
 		}
 		else 
 		{
 			throw new ENotInEnum("{$Element} is not in enum {__CLASS__}"); //ENotInEnum是一个自定义的异常类。
 		}
 	}
 	/**
 	 * 构造函数
 	 * @param $Element
 	 * @return unknown_type
 	 */
	function __construct($Element) {
		 $this->init();	
		 $this->get($Element);
	}
	/**
	 * 析构函数 
	 * @return unknown_type
	 */
	function __destruct() 
	{ 
		
   	}
}
?>