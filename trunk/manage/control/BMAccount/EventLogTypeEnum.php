<?php
require_once (UTILS . '/Enum.php');

/**
 * 系统操作日志类型枚举
 * BASEMANGE  后台基础数据
 *  CARDMANAGE   卡库
 *  GAMEONE    游戏1--幻龙骑士
 */
final class EventLogTypeEnum extends Enum 
{
	/**
	 * 后台基础数据
	 * @var int
	 */
	const BASEMANGE = 1; 
	/**
	 * 卡库
	 * @var int
	 */
	const CARDMANAGE = 2;
	/**
	 * 游戏1--幻龙骑士
	 * @var int
	 */
	const GAMEONE = 10 ;
	
	
	protected function init() 
	{ 
		self::Add(self::BASEMANGE);
		self::Add(self::CARDMANAGE);
		self::Add(self::GAMEONE); 
	}
	
}
?>