package sszt.core.data.stall
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	
	public class StallBuyCellInfo extends EventDispatcher
	{
		public var templateId:int;
		public var price:int;
		public var num:int;
		private var _template:ItemTemplateInfo; 
		
		public function StallBuyCellInfo(argTemplateId:int,argPrice:int,argNum:int)
		{
			this.templateId = argTemplateId;
			this.price = argPrice;
			this.num = argNum;
		}
		
		public function getTemplateById():ItemTemplateInfo
		{
			if(_template == null)
			{
				_template = ItemTemplateList.getTemplate(templateId);
			}
			return _template;
		}
	}
}