package sszt.scene.data.guildPVP
{
	import flash.events.EventDispatcher;
	
	public class GuildPVPInfo extends EventDispatcher
	{
		public var kill:int;
		public var nick:String;
		public var index:int;
		public var rewardItemId:int;
		public var rankList:Array;
		public var time:int;
		public var totalTime:int;
		public var itemList:Array;
		
		public function GuildPVPInfo()
		{
			super();
		}
		
		public function updateRemainTime(time:int,totalTime:int,list:Array,nick:String):void
		{
			this.time = time;
			this.totalTime = totalTime;
			this.itemList = list;
			this.nick = nick;
			dispatchEvent(new GuildPVPInfoUpdateEvent(GuildPVPInfoUpdateEvent.RELOAD_UPDATE));
		}
		
		public function updateGuildNick(nick:String):void
		{			
			this.nick = nick;
			dispatchEvent(new GuildPVPInfoUpdateEvent(GuildPVPInfoUpdateEvent.NICK_UPDATE));
		}
		
		public function updateKillInfo(totalTime:int,kill:int):void
		{
			this.totalTime = totalTime;
			this.kill = kill;
//			this.nick = nick;
			dispatchEvent(new GuildPVPInfoUpdateEvent(GuildPVPInfoUpdateEvent.KILL_UPDATE));
		}
		
		public function updateResultInfo(totalTime:int,index:int,rewardItemId:int,rankList:Array):void
		{
			this.totalTime = totalTime;
			this.index = index;
			this.rewardItemId = rewardItemId;
			this.rankList = rankList;
			dispatchEvent(new GuildPVPInfoUpdateEvent(GuildPVPInfoUpdateEvent.RESULT_UPDATE));
		}
	}
}