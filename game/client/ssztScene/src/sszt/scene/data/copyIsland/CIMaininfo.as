package sszt.scene.data.copyIsland
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	
	public class CIMaininfo extends EventDispatcher
	{
		public var stage:int;
		public var leftTime:int;
		public var singleExp:int;
		public var singleLifeExp:int;
		public var allExp:int;
		public var allLifeExp:int;
		
		public var maxStage:int;
		
		public var allMonsterCount:int;
		public var leftMonsterCount:int;
		public var nextMapId:int;
		public static const COPY_ISLAND_ID:int = 517044;
		public function CIMaininfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_MAININFO_UPDATE));
		}
		
		public function updateTime():void
		{
			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_LEFTTIME_UPDATE));
		}
		
		public function updateMonsterCount():void
		{
			dispatchEvent(new SceneCopyIslandUpdateEvent(SceneCopyIslandUpdateEvent.COPY_ISLAND_MONSTERCOUNT));
		}
	}
}