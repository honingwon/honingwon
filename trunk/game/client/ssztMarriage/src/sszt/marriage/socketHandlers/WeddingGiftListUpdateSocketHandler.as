package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.marriage.WeddingCashGiftItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.marriage.MarriageModule;
	
	public class WeddingGiftListUpdateSocketHandler extends BaseSocketHandler
	{
		public function WeddingGiftListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.WEDDING_SEE_GIFT_LIST;
		}
		
		override public function handlePackage():void
		{
			var list:Array = [];
			var item:WeddingCashGiftItemInfo;
			var len:int = _data.readShort();
			var i:int;
			for(i = 0; i < len; i++)
			{
				item = new WeddingCashGiftItemInfo();
				item.nick = _data.readUTF();
				item.copper = _data.readInt();
				item.yuanbao =_data.readInt();
				item.state = _data.readBoolean();
				list.push(item);
			}
			module.marriageInfo.updateWeddingGiftList(list);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.WEDDING_SEE_GIFT_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get module():MarriageModule
		{
			return _handlerData as MarriageModule;
		}
	}
}