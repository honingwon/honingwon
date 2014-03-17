package sszt.core.data.quickIcon.iconInfo
{
	public class TeamIconInfo
	{
		public var serverId:int;
		public var id:Number;
		public var nick:String;
		public var startTime:int;
		
		public function TeamIconInfo(argServerId:int,argNick:String,argId:Number)
		{
			serverId = argServerId;
			id = argId;
			nick = argNick;
		}
	}
}