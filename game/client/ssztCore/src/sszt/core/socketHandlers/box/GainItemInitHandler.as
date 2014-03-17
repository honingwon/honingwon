package sszt.core.socketHandlers.box
{
//	import sszt.box.BoxModule;
//	import sszt.box.components.GainPanel;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.box.BoxType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToBoxData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class GainItemInitHandler extends BaseSocketHandler
	{
		public function GainItemInitHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
//			var id:int = _data.readInt();
//			var itemTemplate:ItemTemplateInfo = ItemTemplateList.getTemplate(id);
//			var type:int = _data.readInt();
//
//			if(itemTemplate)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.box.boxOpenByItem",itemTemplate.name,BoxType.getBoxNameByType(type/3+1)));
//			}
			var len:int = _data.readInt();
			var item:ItemInfo;
			var itemList:Array = [];
			var pickType:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				item = new ItemInfo();
				
				item.place = _data.readInt();
				item.isExist = _data.readBoolean();
				if(!item.isExist)
				{
					if(item)
						item.isExist = false;
				}
				else
				{
					pickType = _data.readByte();
					PackageUtil.readItem(item,_data);
				}
				
				itemList.push(item);
			}
			GlobalData.boxMsgInfo.gainItemList = itemList;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GAIN_ITEM_UPDATE,new ToBoxData(5,-1,itemList)));
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.SM_GAIN_ITEM_INIT;
		}
		
//		public function get boxModule():BoxModule
//		{
//			return _handlerData as BoxModule;
//		}
	}
}