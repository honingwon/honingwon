package sszt.scene.data.clubPointWar.mainInfo
{
	import flash.events.EventDispatcher;
	
	import sszt.scene.events.SceneClubPointWarUpdateEvent;

	public class ClubPointWarMainInfo extends EventDispatcher
	{
		public var itemInfoList:Array;
		public var personalKillNum:int;
		public var personalScore:int;
		public var personalContribute:int;
		public var todayHonorNum:int;
		public var allHonorNum:int;
		
		public function ClubPointWarMainInfo()
		{
			itemInfoList = [];
		}
		
		public function update():void
		{
			dispatchEvent(new SceneClubPointWarUpdateEvent(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_UPDATE));
		}
		
		public function updateInfo():void
		{
			dispatchEvent(new SceneClubPointWarUpdateEvent(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_PERSONALINFO_UPDATE));
		}
		
		public function getItem(argClubName:String):ClubPointWarClubItemInfo
		{
			for each(var i:ClubPointWarClubItemInfo in itemInfoList)
			{
				if(i.clubName == argClubName)
				{
					return i;
				}
			}
			return null;
		}
	}
}