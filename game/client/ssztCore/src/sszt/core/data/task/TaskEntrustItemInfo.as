package sszt.core.data.task
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.container.accordionItems.IAccordionItemData;
	
	import sszt.core.manager.LanguageManager;
	
	public class TaskEntrustItemInfo extends EventDispatcher implements IAccordionItemData
	{
		public var taskId:int;
		public var dayLeftCount:int;
		/**
		 * 是否正在委托
		 */		
		public var isEntrusting:Boolean;
		/**
		 * 委托任务结束时间
		 */		
		public var entrustEndTime:Date;
		/**
		 * 委托次数
		 */		
		public var entrustCount:int;
		
		public function TaskEntrustItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getAccordionItem(width:int):DisplayObject
		{
			var field:TextField = new TextField();
			field.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			field.filters = [new GlowFilter(0x17380F,1,2,2,10)];
			field.width = width;
			field.height = 20;
			field.mouseEnabled = false;
			field.htmlText = template.title + LanguageManager.getWord("ssztl.common.levelValue2",template.minLevel);
			return field;
		}
		
		public function get template():TaskTemplateInfo
		{
			return TaskTemplateList.getTaskTemplate(taskId);
		}
	}
}