package sszt.scene.data.bigBossWar
{
	import flash.events.Event;
	
	public class BigBossWarInfoUpdateEvent extends Event
	{
		public static const DAMAGE_RANK_UPDATE:String = 'damageRankUpdate';
		public static const MY_DAMAGE_UPDATE:String = 'myDamageUpdate';
		public static const RESULT_UPDATE:String = 'resultUpdate';
		
		public function BigBossWarInfoUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}