package sszt.scene.data.personalWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.ScenePerWarUpdateEvent;
	
	public class PerWarMainInfo extends EventDispatcher
	{
		public var warSceneItemInfoDiList:Array;
		
		public function PerWarMainInfo()
		{
		}
		
		public function updateList():void
		{
			listSortOn();
			dispatchEvent(new ScenePerWarUpdateEvent(ScenePerWarUpdateEvent.PERWAR_MAINLIST_UPDATE));
		}
		
		public function listSortOn():void
		{
			warSceneItemInfoDiList.sortOn(["listId"],[Array.CASEINSENSITIVE|Array.NUMERIC]);
		}
		
		public function getSceneItemInfo(argListId:Number):PerWarMainItemInfo
		{
			for each(var i:PerWarMainItemInfo in warSceneItemInfoDiList)
			{
				if(i.listId == argListId)
				{
					return i;
				}
			}
			return null;
		}
	}
}