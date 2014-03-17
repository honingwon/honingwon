package sszt.core.socketHandlers.store
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	
	public class ItemBuyBackUpdateSocketHandler extends BaseSocketHandler
	{
		public function ItemBuyBackUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_BUY_BACK_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var item:ItemInfo;
//			var list:Vector.<ItemInfo> = new Vector.<ItemInfo>();
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
			GlobalData.buyBackInfo.updateBuyBack(list);
			
			handComplete();
		}
	}
}