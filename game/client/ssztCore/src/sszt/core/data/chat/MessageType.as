package sszt.core.data.chat
{
	import sszt.core.manager.LanguageManager;

	public class MessageType
	{
		public static const WORLD:int = 1;									//世界
		
		public static const CMP:int = 2;									//阵营
		
		public static const CLUB:int = 3;									//帮会
		
		public static const GROUP:int = 4;									//组队
		
		public static const CURRENT:int = 5;								//附近
		
		public static const SPEAKER:int = 6;								//喇叭
		
		public static const CITY:int = 7;								//王城
		
		public static const IM:int = 8;                                   	//IM好友
		
		public static const SYSTEM:int = 9;									//系统消息
		
		public static const NOTICE:int = 10;								//系统公告
		
		public static const CHAT:int = 11;									//聊天
		
		public static const SYSTEM_WORLD:int = 12;
		public static const WORLD_CURRENT:int = 13;
		public static const SYSTEM_FLOAT:int = 14;
		
		public static const PRIVATE:int = 100;								//私聊
		
		public function MessageType()
		{
		}
		
		public static function getAllTypes():Array
		{
			return [WORLD,CMP,CLUB,GROUP,CURRENT,SPEAKER,CITY,IM,SYSTEM,NOTICE,CHAT,PRIVATE];
		}
		
		public static function getShowNick(type:int):Boolean
		{
			if(type == SYSTEM || type == NOTICE || type == CHAT)return false;
			return true;
		}
		
		public static function getMessageName(type:int):String
		{
			switch(type)
			{
				case WORLD:return LanguageManager.getWord("ssztl.common.world");
				case CMP:return LanguageManager.getWord("ssztl.common.camp");
				case CLUB:return LanguageManager.getWord("ssztl.common.club");
				case GROUP:return LanguageManager.getWord("ssztl.common.team");
				case CURRENT:return LanguageManager.getWord("ssztl.common.near");
				case SPEAKER:return LanguageManager.getWord("ssztl.common.spark");
				case CITY:return LanguageManager.getWord("ssztl.cityCraft.chatCity");
				case SYSTEM:return LanguageManager.getWord("ssztl.common.system");
				case NOTICE:return LanguageManager.getWord("ssztl.common.notice");
			}
			return "";
		}
	}
}