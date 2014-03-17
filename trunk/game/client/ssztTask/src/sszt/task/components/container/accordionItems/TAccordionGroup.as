package sszt.task.components.container.accordionItems
{
	import sszt.ui.container.accordionItems.AccordionGroup;
	import sszt.ui.container.accordionItems.AccordionGroupItemView;
	import sszt.ui.container.accordionItems.AccordionGroupTitleView;
	import sszt.ui.container.accordionItems.IAccordionItemData;
	
	public class TAccordionGroup extends AccordionGroup
	{
		public function TAccordionGroup(title:String, itemValues:Array, width:int, showItemCount:int, showTitleBg:Boolean=true, showItemSelectedBg:Boolean=true)
		{
			super(title, itemValues, width, showItemCount, showTitleBg, showItemSelectedBg);
		}
		
		override protected function createTitleView(title:String,width:int,showBg:Boolean):AccordionGroupTitleView
		{
			return new TAccordionGroupTitleView(title,width,showBg);
		}
		
		override protected function createItemView(info:IAccordionItemData,width:int):AccordionGroupItemView
		{
			return new TAccordionGroupItemView(info,width,_showItemSelectedBg);
		}
	}
}