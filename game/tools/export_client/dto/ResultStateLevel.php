<?php
require_once (dirname(__FILE__).'/Enum.php');
/**
 * 返回等级
 * @author IBM
 *
 */
final class ResultStateLevel extends Enum 
{
	/**
	 * 成功
	 * @var int
	 */
	const SUCCESS = 0; 
	/**
	 * 异常错误
	 * @var int
	 */
	const EXCEPTION = 1;
	/**
	 * 其它错误
	 * @var int
	 */
	const ERROR = 2 ;
	/**
	 * 警告（数据部分未获取）
	 * @var int
	 */
	const WARNING = 4;
	
	
	protected function init() 
	{ 
		self::Add(self::EXCEPTION);
		self::Add(self::ERROR);
		self::Add(self::WARNING); 
		self::Add(self::SUCCESS);
	}
	
}
?>