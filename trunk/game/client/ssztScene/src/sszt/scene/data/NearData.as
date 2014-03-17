package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.data.team.BaseTeamInfo;
	import sszt.scene.data.team.UnteamPlayerInfo;
	import sszt.scene.events.NearDataUpdateEvent;
	
	public class NearData extends EventDispatcher
	{
//		public var teamList:Vector.<BaseTeamInfo>;
//		public var unteamPlayers:Vector.<UnteamPlayerInfo>;
		public var teamList:Array;
		public var unteamPlayers:Array;
		
		public function NearData()
		{
		}
		
//		public function setData(teamList:Vector.<BaseTeamInfo>,unteams:Vector.<UnteamPlayerInfo>):void
		public function setData(teamList:Array,unteams:Array):void
		{
			this.teamList = teamList;
			this.unteamPlayers = unteams;
			dispatchEvent(new NearDataUpdateEvent(NearDataUpdateEvent.SETDATA_COMPLETE));
		}
		
		public function clearData():void
		{
			teamList = null;
			unteamPlayers = null;
		}
		
	}
}