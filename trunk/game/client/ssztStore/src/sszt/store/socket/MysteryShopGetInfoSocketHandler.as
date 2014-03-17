package sszt.store.socket
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.store.MysteryShopItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	/**
	 *  神秘商店商品实时信息
	 * @author lxb
	 * 
	 */	
	public class MysteryShopGetInfoSocketHandler extends BaseSocketHandler
	{
		public function MysteryShopGetInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MYSTERY_SHOP_INFO;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			var list:Dictionary = new Dictionary;
			for(var i:int = 0; i < len; i++)
			{
				var place:int = _data.readByte();
				var item:MysteryShopItemInfo = new MysteryShopItemInfo();
				item.place = place;
				item.templateId = _data.readInt();
				item.isExist = _data.readBoolean();
				item.num = _data.readByte();
				item.price = _data.readInt();
				item.payType = _data.readByte();
				list[place] = item;
			}
			GlobalData.mysteryShopInfo.update( list,true);
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MYSTERY_SHOP_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}