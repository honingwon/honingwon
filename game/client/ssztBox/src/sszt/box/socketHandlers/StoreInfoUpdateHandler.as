package sszt.box.socketHandlers
{
	import sszt.box.BoxModule;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	
	public class StoreInfoUpdateHandler extends BaseSocketHandler
	{
		public function StoreInfoUpdateHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SM_STORE_INFO_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			
			var item:ItemInfo;
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
				
				boxModule.shenmoStoreInfo.addItem(item);
			}
			
			handComplete();
		}
		
		public function get boxModule():BoxModule
		{
			return _handlerData as BoxModule;
		}
	}
}