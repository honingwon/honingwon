package sszt.common.wareHouse.socket
{
	import sszt.common.wareHouse.WareHouseModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WareHouseUpdateSocketHandler extends BaseSocketHandler
	{
		public function WareHouseUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public function  get wareHouseModule():WareHouseModule
		{
			return _handlerData as WareHouseModule;
		}
		
		override public function getCode():int
		{
			return ProtocolType.DEPOT_ITEM_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var item:ItemInfo;
//			var list:Vector.<ItemInfo> = new Vector.<ItemInfo>();
			var list:Array = new Array();
			var pickType:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				var place:int = _data.readInt();
				item = new ItemInfo();
				item.place = place;
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
				list.push(item);
			}
			wareHouseModule.wareHouseInfo.updates(list);
			
			handComplete();
		}
		
		public static function sendFetch(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.DEPOT_ITEM_UPDATE);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}