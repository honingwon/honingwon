package sszt.scene.data.copyIsland.beforeEnter
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	
	public class CIBeforeInfo extends EventDispatcher
	{
		public var resultList:Array;
		public function CIBeforeInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function init():void
		{
			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_INIT));
			checkCanEnter();
		}
		
		public function updateItemInfo(argName:String,argTag:int):void
		{
			var tmpInfo:CIBeforeItemInfo = getResult(argName);
			if(!tmpInfo)return;
			tmpInfo.tag = argTag;
			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_ITEMUPDATE,argName));
			checkCanEnter();
		}
		
		public function checkCanEnter():void
		{
			var tmpCount:int;
			for each(var i:CIBeforeItemInfo  in resultList)
			{
				if(i.tag == 1)
				{
					tmpCount ++;
				}
			}
			if(tmpCount == resultList.length)
			{
				dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_CANENTER));
			}
		}
		
		public function getResult(argName:String):CIBeforeItemInfo
		{
			for each(var i:CIBeforeItemInfo in resultList)
			{
				if(i.name == argName)
				{
					return i;
				}
			}
			return null;
		}
	}
}