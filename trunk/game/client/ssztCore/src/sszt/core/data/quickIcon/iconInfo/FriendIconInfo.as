package sszt.core.data.quickIcon.iconInfo
{
	public class FriendIconInfo
	{
		public var serverId:int;
		public var id:Number;
		public var nick:String;
		public var startTime:int;
		
		public function FriendIconInfo(argServerId:int,argId:Number,argNick:String)
		{
			serverId = argServerId;
			id = argId;
			nick = argNick;
		}
	}
}