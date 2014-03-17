package sszt.core.socketHandlers.box
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class OpenBoxSocketHandler extends BaseSocketHandler
	{
		public function OpenBoxSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SM_OPEN_BOX;
		}
		
		override public function handlePackage():void
		{
//			var len:int = _data.readInt();
//			
//			var item:ItemInfo;
//			for(var i:int = 0; i < len; i++)
//			{
//				item = new ItemInfo();
//				
//				item.place = _data.readInt();
//				item.isExist = _data.readBoolean();
//				if(!item.isExist)
//				{
//					if(item)
//						item.isExist = false;
//				}
//				else
//				{
//					PackageUtil.readItem(item,_data);
//				}
//				
//				boxModule.shenmoStoreInfo.addItem(item);
//			}
			
			handComplete();
		}
		
		public static function sendOpenBox(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SM_OPEN_BOX);
			pkg.writeInt(type);
//			pkg.writeInt(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}