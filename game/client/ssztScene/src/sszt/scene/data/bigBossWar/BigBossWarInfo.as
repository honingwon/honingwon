package sszt.scene.data.bigBossWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class BigBossWarInfo extends EventDispatcher
	{
		public var damageRank:Array;
		public var myDamage:int;
		public var totalDamage:int;
		public var nick:String;
		public var isLive:Boolean;
		public var rewardItemId:int;
		
		public function BigBossWarInfo()
		{
			super();
		}
		
		public function updateDamageInfo(list:Array,myDamage:int,totalDamage:int,nick:String):void
		{
			damageRank = list;
			this.myDamage = myDamage;
			this.totalDamage = totalDamage;
			this.nick = nick;
			dispatchEvent(new BigBossWarInfoUpdateEvent(BigBossWarInfoUpdateEvent.DAMAGE_RANK_UPDATE));
		}
		
		public function updateResultInfo(isLive:Boolean,rewardItemId:int):void
		{
			this.isLive = isLive;
			this.rewardItemId = rewardItemId;
			dispatchEvent(new BigBossWarInfoUpdateEvent(BigBossWarInfoUpdateEvent.RESULT_UPDATE));
		}
	}
}