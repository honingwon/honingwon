package sszt.firebox.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.firebox.events.FireBoxEvent;
	
	public class FireBoxMaterialInfo extends EventDispatcher
	{
		public var templateInfoId:int;
		public var needCount:int;
		public var bagCount:int;
		
		public function FireBoxMaterialInfo(argTemplateInfoId:int,argNeedCount:int,argBagCount:int)
		{
			templateInfoId = argTemplateInfoId;
			needCount = argNeedCount;
			bagCount = argBagCount;
		}
		
		public function updateData(argCount:int):void
		{
			bagCount = argCount;
			dispatchEvent(new FireBoxEvent(FireBoxEvent.MATERIAL_CELL_UPDATE));
		}
		
		public function get tempalteInfo():ItemTemplateInfo
		{
			return ItemTemplateList.getTemplate(templateInfoId);
		}
	}
}