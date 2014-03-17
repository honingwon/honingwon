package sszt.core.data.task
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.ui.container.accordionItems.IAccordionGroupData;
	import sszt.ui.container.accordionItems.IAccordionItemData;
	
	public class TaskAccordionData extends EventDispatcher implements IAccordionGroupData
	{
		public var title:String;
		/**
		 * IAccordionItemData
		 */		
		public var data:Array;
		
		public var type:int;
		public var isFinish:Boolean;
		
		public function TaskAccordionData(type:int)
		{
			this.type = type;
			this.title = TaskType.getNameByType(type);
			data = [];
		}
		
		public function getTitleString():String
		{
			return title;
		}
		
		public function getItemDatas():Array
		{
			return data;
		}
	}
}