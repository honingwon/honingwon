package sszt.ui.container.accordionItems
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class BaseAccordionGroupData extends EventDispatcher implements IAccordionGroupData
	{
		protected var _title:String;
		/**
		 * IAccordionItemData
		 */		
		protected var _itemDatas:Array;
		
		public function BaseAccordionGroupData(title:String,itemDatas:Array)
		{
			_title = title;
			_itemDatas = itemDatas;
		}
		
		public function getTitleString():String
		{
			return _title;
		}
		
		public function getItemDatas():Array
		{
			return _itemDatas;
		}
	}
}