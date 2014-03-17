package sszt.task.components.container
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import sszt.task.components.container.accordionItems.TAccordionGroup;
	import sszt.ui.container.MAccordion;
	import sszt.ui.container.accordionItems.AccordionGroup;
	import sszt.ui.container.accordionItems.IAccordionGroupData;
	
	public class TAccordion extends MAccordion
	{
		public function TAccordion(data:Array, width:int, showItemCount:int=5, showMutil:Boolean=false, showTitleBg:Boolean=true, showItemSelectedBg:Boolean=true)
		{
			super(data, width, showItemCount, showMutil, showTitleBg, showItemSelectedBg);
		}
		
		override protected function createGroup(data:IAccordionGroupData):AccordionGroup
		{
			return new TAccordionGroup(data.getTitleString(), data.getItemDatas(), _tmpWidth, _showItemCount, _isShowTitleBg, _isShowItemSelectedBg);
		}
	}
}