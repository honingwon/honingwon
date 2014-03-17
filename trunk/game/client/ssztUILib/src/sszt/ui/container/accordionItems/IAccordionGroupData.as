package sszt.ui.container.accordionItems
{
	import flash.events.IEventDispatcher;
	
	public interface IAccordionGroupData extends IEventDispatcher
	{
		function getTitleString():String;
		/**
		 * IAccordionItemData
		 * @return 
		 * 
		 */		
		function getItemDatas():Array;
	}
}