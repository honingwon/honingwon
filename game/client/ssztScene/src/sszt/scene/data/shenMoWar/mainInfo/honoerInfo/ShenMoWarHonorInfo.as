package sszt.scene.data.shenMoWar.mainInfo.honoerInfo
{
	import flash.events.EventDispatcher;
	
	import sszt.scene.events.SceneShenMoWarUpdateEvent;

	public class ShenMoWarHonorInfo extends EventDispatcher
	{
		public var todayKillNum:int;
		public var todayHonorNum:int;
		public var totalkillNum:int;
		public var totalHonorNum:int;
		public var warSceneItemInfoDiList:Array;
//		public var warSceneItemInfoGaoList:Array;
		
		public function ShenMoWarHonorInfo()
		{
		}
		
		public function updateList():void
		{
			listSortOn();
			dispatchEvent(new SceneShenMoWarUpdateEvent(SceneShenMoWarUpdateEvent.SHENMO_HONOR_LIST_UPDATE));
		}
		
		public function updateInfo():void
		{
			dispatchEvent(new SceneShenMoWarUpdateEvent(SceneShenMoWarUpdateEvent.SHENMO_HONOR_INFO_UPDATE));
		}
		
		public function listSortOn():void
		{
			warSceneItemInfoDiList.sortOn(["listId"],[Array.CASEINSENSITIVE|Array.NUMERIC]);
		}
		
		public function getSceneInfo(argListId:Number):ShenMoWarSceneItemInfo
		{
			for each(var i:ShenMoWarSceneItemInfo in warSceneItemInfoDiList)
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