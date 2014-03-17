package sszt.core.data.quickIcon.iconInfo
{
	public class ClubIconInfo
	{
		public var clubId:Number;
		public var clubName:String;
		public var serverId:int;
		public var nick:String;
		public var startTime:int;
		
		public function ClubIconInfo(argClubId:Number,argServerId:int,argNick:String,argClubName:String)
		{
			clubId = argClubId;
			serverId = argServerId;
			nick = argNick;
			clubName = argClubName;
		}
	}
}