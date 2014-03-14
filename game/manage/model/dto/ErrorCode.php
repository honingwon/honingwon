<?php
require_once (dirname(__FILE__).'/../../utils/Enum.php');
/**
 * 错误代码
 * @author IBM
 *
 */
final class ErrorCode extends Enum 
{
	/**
	 * 系统配置
	 * @var int
	 */
	const SYSTEMCONFIG 				= "PHPC0001"; 
	const GETSYSTEMITEMLIST 		= "PHPC0002";
	const GETITEMATTRIBUTE 			= "PHPC0003";
	const GETSYSTEMSKILL 			= "PHPC0004";
	const GETSYSTEMSKILLARRTIBUTE 	= "PHPC0005";
	const GETSYSTEMSKILLPRECONDITION= "PHPC0006";
	const GETALLMONSTER				= "PHPC0007";
	const GETMONSTERATTRIBUTE		= "PHPC0008";
	const GETCONVERSATION			= "PHPC0009";
	const GETALLTASK				= "PHPC0010";
	const GETTASKCONVERSATION		= "PHPC0011";
	const GETALLTASKITEM			= "PHPC0012";
	const GETALLTASKMONSTER			= "PHPC0013";
	const GETNPCLIST				= "PHPC0014";
	const GETUSERROLES				= "PHPC0015";
	const GETUSERTASKS				= "PHPC0016";
	const GETUSERITEMLIST			= "PHPC0017";
	const GETUSERROLESKILL			= "PHPC0018";
	const GETUSERTASKMONSTERS		= "PHPC0019";
	const GETUSERUSERMAILINBOX		= "PHPC0020";
	const GETUSERUSERMAILOUTBOX		= "PHPC0021";
	const GETSHOPITEM				= "PHPC0022";
	const GETSHOPDesignPaper		= "PHPC0023";
	const GETFriendList				= "PHPC0024";
	const GETITEMTYPES				= "PHPC0025";
	const GETCAREERINFO				= "PHPC0026";
	const GETAREAINFO				= "PHPC0027";
	const GETSHOPINFO				= "PHPC0028";
	const GETUSERITEMMAGIC			= "PHPC0029";
	const GETCHATBULLETIN			= "PHPC0030";
	const GETROLETRAIN				= "PHPC0031";
	const GETTRAINPROJECT			= "PHPC0032";
	const GETTRAINPROJECTITEM		= "PHPC0033";
	const GETACCOUNTCD				= "PHPC0033";
	const GETARENASHOP				= "PHPC0034";
	const GETREPUTATION				= "PHPC0035";
	
	protected function init() 
	{ 
		self::Add(self::SYSTEMCONFIG);
	}
	
}
?>