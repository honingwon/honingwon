package sszt.core.data.quickIcon.iconInfo
{
	public class DoubleSitIconInfo
	{
		public var serverId:int;
		public var id:Number;
		public var nick:String;
		public var x:int;
		public var y:int;
		public var startTime:int;
		
		public function DoubleSitIconInfo(argNick:String,argServerId:int,argId:Number,argX:int,argY:int)
		{
			id = argId;
			serverId = argServerId;
			nick = argNick;
			x = argX;
			y = argY;
		}
	}
}