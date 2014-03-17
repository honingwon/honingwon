package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetItemPlaceUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetItemPlaceUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_ITEM_PLACE_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var petId:Number = _data.readNumber();
			var len:int = _data.readInt();
			var item:ItemInfo;
			var list:Array = [];
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
			
			GlobalData.petBagInfo.updateItems(petId,list);
			
			handComplete();
		}
		
		public static function send(petId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_ITEM_PLACE_UPDATE);
			pkg.writeNumber(petId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}