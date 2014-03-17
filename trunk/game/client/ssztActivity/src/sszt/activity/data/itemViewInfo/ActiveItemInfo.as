package sszt.activity.data.itemViewInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.activity.data.ActiveType;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveTemplateInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	
	public class ActiveItemInfo extends EventDispatcher
	{
		public var activeTemplateInfo:ActiveTemplateInfo;
		private var _count:int;
		
		public function ActiveItemInfo(argTemplateInfo:ActiveTemplateInfo)
		{
			super();
			activeTemplateInfo = argTemplateInfo;
		}
		
		
		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
//			dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.ACTIVE_ITEM_UPDATE));
		}
		
		public function get id():int
		{
			return activeTemplateInfo.id;
		}
		
//		public function canShow():Boolean
//		{
//			if(activeTemplateInfo.type == ActiveType.ACTIVE_TASK)
//			{
//				var task:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(activeTemplateInfo.activeId);
//				var matchCareer:Boolean = ((task.needCareer == -1)||(GlobalData.selfPlayer.career == task.needCareer));
//				if(!matchCareer) return false;
//				if(GlobalData.selfPlayer.level < task.minLevel || GlobalData.selfPlayer.level > task.maxLevel) return false;
//			}
//			return true;
//		}
	}
}