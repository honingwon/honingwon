package sszt.scene.data.shenMoWar.myWarInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	
	public class ShenMoWarMyWarInfo extends EventDispatcher
	{
		public var attackInfoList:Array;
		public var beAttackedInfoList:Array;
		
		public function ShenMoWarMyWarInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			listSortOn();
			dispatchEvent(new SceneShenMoWarUpdateEvent(SceneShenMoWarUpdateEvent.SHENMO_MYWAR_INFO_UPDATE));
		}
		
		public function listSortOn():void
		{
			attackInfoList.sortOn(["killCount"],[Array.CASEINSENSITIVE|Array.NUMERIC|Array.DESCENDING]);
			beAttackedInfoList.sortOn(["killCount"],[Array.CASEINSENSITIVE|Array.NUMERIC|Array.DESCENDING]);
		}
	}
}