package sszt.scene.data.personalWar.myInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.ScenePerWarUpdateEvent;
	
	public class PerWarMyWarInfo extends EventDispatcher
	{
		public var attackInfoList:Array;
		public var beAttackedInfoList:Array;
		
		public function PerWarMyWarInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			listSortOn();
			dispatchEvent(new ScenePerWarUpdateEvent(ScenePerWarUpdateEvent.PERWAR_MYWAR_INFO_UPDATE));
		}
		
		public function listSortOn():void
		{
			attackInfoList.sortOn(["killCount"],[Array.CASEINSENSITIVE|Array.NUMERIC|Array.DESCENDING]);
			beAttackedInfoList.sortOn(["killCount"],[Array.CASEINSENSITIVE|Array.NUMERIC|Array.DESCENDING]);
		}
	}
}