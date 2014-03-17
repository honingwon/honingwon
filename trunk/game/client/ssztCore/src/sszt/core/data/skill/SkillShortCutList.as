package sszt.core.data.skill
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class SkillShortCutList extends EventDispatcher
	{
//		private var _list:Vector.<Array>;
		private var _list:Array;
		
		public function SkillShortCutList()
		{
			super();
//			_list = new Vector.<Array>(16);
			_list = new Array(16);
		}
		
		public function updateShortCut(place:int,type:int,id:int):void
		{
			_list[place] = [type,id];
			dispatchEvent(new SkillShortCutListUpdateEvent(SkillShortCutListUpdateEvent.UPDATE_SHORTCUT,{type:type,place:place}));
		}
		
//		public function getItemList():Vector.<Array>
		public function getItemList():Array
		{
			return _list;
		}
		
		public function getItemIdByPlace(place:int):Array
		{
			return _list[place];
		}
	}
}