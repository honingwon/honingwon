package sszt.box.socketHandlers
{
	import sszt.box.BoxModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class StoreItemInitSocketHandler extends BaseSocketHandler
	{
		public function StoreItemInitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SM_SOTRE_ITEM_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var item:ItemInfo;
			var pickType:int = 0;
//			var list:Array = [];
			boxModule.shenmoStoreInfo.clearList();
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
//			GlobalData.bagInfo.updateItems(list);
			handComplete();
		}
		
		public static function sendInitInfo():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SM_SOTRE_ITEM_UPDATE);
//			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get boxModule():BoxModule
		{
			return _handlerData as BoxModule;
		}
	}
}