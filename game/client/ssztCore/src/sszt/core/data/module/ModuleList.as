package sszt.core.data.module
{
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	
	public class ModuleList
	{
		private static var _list:Dictionary = new Dictionary();
		
		private static function addInfo(info:ModuleInfo):void
		{
			_list[info.moduleId] = info;
		}
		
		public static function setup():void
		{
//			addInfo(new ModuleInfo(ModuleType.SERVERLIST,LanguageManager.getWord("moduleName.serverList")));
//			addInfo(new ModuleInfo(ModuleType.SCENE,LanguageManager.getWord("moduleName.scene")));
//			addInfo(new ModuleInfo(ModuleType.NAVIGATION,LanguageManager.getWord("moduleName.navigation")));
//			addInfo(new ModuleInfo(ModuleType.BAG,LanguageManager.getWord("moduleName.bag")));
//			addInfo(new ModuleInfo(ModuleType.STALL,LanguageManager.getWord("moduleName.stall")));
//			addInfo(new ModuleInfo(ModuleType.STORE,LanguageManager.getWord("moduleName.store")));
//			addInfo(new ModuleInfo(ModuleType.ROLE,LanguageManager.getWord("moduleName.role")));
//			addInfo(new ModuleInfo(ModuleType.TASK,LanguageManager.getWord("moduleName.task")));
//			addInfo(new ModuleInfo(ModuleType.CONSIGN,LanguageManager.getWord("moduleName.consign")));
//			addInfo(new ModuleInfo(ModuleType.CHAT,LanguageManager.getWord("moduleName.chat")));
//			addInfo(new ModuleInfo(ModuleType.SETTING,LanguageManager.getWord("moduleName.setting")));
//			addInfo(new ModuleInfo(ModuleType.SKILL,LanguageManager.getWord("moduleName.skill")));
//			addInfo(new ModuleInfo(ModuleType.FURNACE,LanguageManager.getWord("moduleName.furnace")));
//			addInfo(new ModuleInfo(ModuleType.CLUB,LanguageManager.getWord("moduleName.club")));
//			addInfo(new ModuleInfo(ModuleType.MAIL,LanguageManager.getWord("moduleName.mail")));
//			addInfo(new ModuleInfo(ModuleType.FRIENDS,LanguageManager.getWord("moduleName.friends")));
//			addInfo(new ModuleInfo(ModuleType.ACTIVITY,LanguageManager.getWord("moduleName.activity")));
//			addInfo(new ModuleInfo(ModuleType.RANK,LanguageManager.getWord("moduleName.rank")));
//			addInfo(new ModuleInfo(ModuleType.VIP,LanguageManager.getWord("moduleName.Vip")));
//			addInfo(new ModuleInfo(ModuleType.BOX, LanguageManager.getWord("moduleName.box")));
			
			
			addInfo(new ModuleInfo(ModuleType.SERVERLIST,"服务器列表"));
			addInfo(new ModuleInfo(ModuleType.SCENE,"场景"));
			addInfo(new ModuleInfo(ModuleType.NAVIGATION,"导航"));
			addInfo(new ModuleInfo(ModuleType.BAG,"背包"));
			addInfo(new ModuleInfo(ModuleType.STALL,"摆摊"));
			addInfo(new ModuleInfo(ModuleType.STORE,"商店"));
			addInfo(new ModuleInfo(ModuleType.NPCSTORE,"商店"));
			addInfo(new ModuleInfo(ModuleType.ROLE,"角色"));
			addInfo(new ModuleInfo(ModuleType.TASK,"任务"));
			addInfo(new ModuleInfo(ModuleType.CONSIGN,"市场"));
			addInfo(new ModuleInfo(ModuleType.CHAT,"聊天"));
			addInfo(new ModuleInfo(ModuleType.SETTING,"设置"));
			addInfo(new ModuleInfo(ModuleType.SKILL,"技能"));
			addInfo(new ModuleInfo(ModuleType.FURNACE,"神炉"));
			addInfo(new ModuleInfo(ModuleType.CLUB,"帮会"));
			addInfo(new ModuleInfo(ModuleType.MAIL,"邮件"));
			addInfo(new ModuleInfo(ModuleType.FRIENDS,"好友"));
			addInfo(new ModuleInfo(ModuleType.ACTIVITY,"活动"));
			addInfo(new ModuleInfo(ModuleType.RANK,"排行"));
			addInfo(new ModuleInfo(ModuleType.VIP,LanguageManager.getWord("moduleName.Vip")));
			addInfo(new ModuleInfo(ModuleType.BOX, "淘宝"));
			addInfo(new ModuleInfo(ModuleType.PERSONAL,"个人中心"));
			addInfo(new ModuleInfo(ModuleType.PET,"宠物"));
			addInfo(new ModuleInfo(ModuleType.FIREBOX,"配方"));
			addInfo(new ModuleInfo(ModuleType.MOUNTS,"坐骑"));
			addInfo(new ModuleInfo(ModuleType.DUPLICATESTORE,"副本商店"));
			addInfo(new ModuleInfo(ModuleType.BAGSELL,"出售"));
			addInfo(new ModuleInfo(ModuleType.ONLINEREWARD,"在线奖励"));
			addInfo(new ModuleInfo(ModuleType.LOGINREWARD,"登录奖励"));
			addInfo(new ModuleInfo(ModuleType.SWORDSMAN,"江湖令"));
			addInfo(new ModuleInfo(ModuleType.TARGET,"目标成就"));
			addInfo(new ModuleInfo(ModuleType.PVP1,"单挑王"));
			addInfo(new ModuleInfo(ModuleType.WAREHOUSE,"仓库"));
			addInfo(new ModuleInfo(ModuleType.Exchange,"功勋兑换"));
			addInfo(new ModuleInfo(ModuleType.Challenge,"试炼"));
			addInfo(new ModuleInfo(ModuleType.QUIZ,"答题活动"));
			addInfo(new ModuleInfo(ModuleType.OPENACTIVITY,"开服活动"));
			addInfo(new ModuleInfo(ModuleType.FIRSTRECHARGE,"首冲活动"));
			addInfo(new ModuleInfo(ModuleType.YELLOWBOX,"黄钻礼包"));
			addInfo(new ModuleInfo(ModuleType.SEVENACTIVITY,"七天嘉年华"));
			addInfo(new ModuleInfo(ModuleType.PAYTAGVIEW,"累积充值 "));
			addInfo(new ModuleInfo(ModuleType.CONSUMTAGVIEW,"消费奖励"));
			addInfo(new ModuleInfo(ModuleType.MARRIAGE,"结婚"));
			addInfo(new ModuleInfo(ModuleType.MID_AUTUMN_ACTIVITY,"中秋活动"));
			addInfo(new ModuleInfo(ModuleType.MERGE_SERVER,"合服活动"));
			addInfo(new ModuleInfo(ModuleType.PET_PVP,"宠物斗坛"));
			addInfo(new ModuleInfo(ModuleType.CITY_CRAFT_AUTION,"王城争霸竞拍"));
			addInfo(new ModuleInfo(ModuleType.TEMPLATE,"-模板-"));
		}
		
		public static function getInfo(id:int):ModuleInfo
		{
			return _list[id];
		}
	}
}