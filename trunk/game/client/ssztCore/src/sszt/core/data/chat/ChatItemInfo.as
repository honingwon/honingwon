package sszt.core.data.chat
{

	public class ChatItemInfo
	{
		public var clientId:int;
		
		public var serverId:int;						//发送人服务器ID
		public var type:int;
		public var vipType:int;
		public var fromId:Number;
		public var fromNick:String;
		public var fromSex:int;
		public var toId:Number;
		public var toNick:String;
		public var message:String;
		
		public var itemList:Array;
		
		public var requoteChannels:Array;
		
		public var career:int;
		
//		private static var _pattern1:RegExp = /\&/g;							//去掉 &gt;的&
//		private static var _pattern2:RegExp = /\</g;  							//信息的html格式删除
//		private static var _pattern3:RegExp = /\>/g;
//		private static var _pattern4:RegExp = /\\'/g;
//		private static var _pattern5:RegExp = /\\"/g;
//		private static var _pattern6:RegExp = /\\r/g;
//		private static var _pattern7:RegExp = /\\n/g;
		
		public function ChatItemInfo()
		{
			itemList = [];
			requoteChannels = [];
		}
		
//		public static function replaceInput(content:String):String
//		{
//			content = content.replace(_pattern1,"&amp;");
//			content = content.replace(_pattern2,"&lt;");
//			content = content.replace(_pattern3,"&gt;");
//			content = content.replace(_pattern4,"&ldquo;");
//			content = content.replace(_pattern5,"&rdquo;");
//			content = content.replace(_pattern6,"");
//			content = content.replace(_pattern7,"");
//			return content;
//		}
		
		public function isNonRequote():Boolean
		{
			return requoteChannels.length == 0;
		}
		
		public function isRequoteByChannel(channel:int):Boolean
		{
			return requoteChannels.indexOf(channel) > -1;
		}
		
		public function removeARequote(channel:int):Boolean
		{
			var index:int = requoteChannels.indexOf(channel);
			if(index > -1)
			{
				requoteChannels.splice(index,1);
				return true;
			}
			return false;
		}
	}
}