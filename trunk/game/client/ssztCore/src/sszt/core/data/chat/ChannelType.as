package sszt.core.data.chat
{
	import sszt.core.manager.LanguageManager;

	public class ChannelType
	{
		public static const WORLD:int = 1;									//世界
		
		public static const CMP:int = 2;									//阵营
		
		public static const CLUB:int = 3;									//帮会
		
		public static const GROUP:int = 4;									//组队
		
		public static const CURRENT:int = 5;								//附近
		
		public static const SPEAKER:int = 6;								//喇叭
		
		public static const CITY:int = 7;								//王城
		
		public static const IM:int = 8;                                 	//IM好友
		
		public static const PRIVATE:int = 100;								//私聊
		
		public static function getMessageType(channel:int):Array
		{
			switch(channel)
			{
				case WORLD:return [MessageType.WORLD,MessageType.CMP,MessageType.CLUB,MessageType.GROUP,MessageType.CURRENT,MessageType.PRIVATE,MessageType.SPEAKER,MessageType.SYSTEM,MessageType.NOTICE,MessageType.CHAT];
				case CMP:return [MessageType.CMP,MessageType.SYSTEM,MessageType.NOTICE,MessageType.CHAT];
				case CLUB:return [MessageType.CLUB,MessageType.SYSTEM,MessageType.NOTICE,MessageType.CHAT];
				case GROUP:return [MessageType.GROUP,MessageType.SYSTEM,MessageType.NOTICE,MessageType.CHAT];
				case CURRENT:return [MessageType.CURRENT,MessageType.SYSTEM,MessageType.NOTICE,MessageType.CHAT];
//				case CITY:return [MessageType.CITY];
				case PRIVATE:return [MessageType.PRIVATE,MessageType.SYSTEM,MessageType.NOTICE,MessageType.CHAT];
				case SPEAKER:return [MessageType.SPEAKER];
			}
			return [];
		}
		
		public static function getChannelType(messagetype:int):Array
		{
			switch(messagetype)
			{
				case MessageType.WORLD:return [WORLD];
				case MessageType.CMP:return [WORLD,CMP];
				case MessageType.CLUB:return [WORLD,CLUB];
				case MessageType.GROUP:return [WORLD,GROUP];
				case MessageType.CURRENT:return [WORLD,CURRENT];
				case MessageType.PRIVATE:return [WORLD,PRIVATE];
				case MessageType.SPEAKER:return [WORLD,SPEAKER];
//				case MessageType.CITY:return [WORLD,CITY];
				case MessageType.SYSTEM:return [WORLD,CMP,CLUB,GROUP,CURRENT,PRIVATE];
				case MessageType.CHAT:return [WORLD,CMP,CLUB,GROUP,CURRENT,PRIVATE];
				case MessageType.NOTICE:return [WORLD,CMP,CLUB,GROUP,CURRENT,PRIVATE];
			}
			return [];
		}
		
		public static function getChannelName(channel:int):String
		{
			switch(channel)
			{
				case WORLD:return LanguageManager.getWord("ssztl.common.world");
				case CMP:return LanguageManager.getWord("ssztl.common.camp");
				case CLUB:return LanguageManager.getWord("ssztl.common.club");
				case GROUP:return LanguageManager.getWord("ssztl.common.team");
				case CURRENT:return LanguageManager.getWord("ssztl.common.near");
				case PRIVATE:return LanguageManager.getWord("ssztl.common.privateChat");
				case SPEAKER:return LanguageManager.getWord("ssztl.common.spark");
//				case CITY:return LanguageManager.getWord("ssztl.cityCraft.chatCity");
			}
			return "";
		}
		
//		public static function getAllChannel():Vector.<String>
		public static function getAllChannel():Array
		{
			return [LanguageManager.getWord("ssztl.common.world"),
				LanguageManager.getWord("ssztl.common.camp"),
				LanguageManager.getWord("ssztl.common.club"),
				LanguageManager.getWord("ssztl.common.team"),
				LanguageManager.getWord("ssztl.common.near"),
				LanguageManager.getWord("ssztl.common.spark")];
//				LanguageManager.getWord("ssztl.cityCraft.chatCity")
		}
	}
}