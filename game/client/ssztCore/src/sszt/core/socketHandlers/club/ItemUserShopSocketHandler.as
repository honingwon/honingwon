package sszt.core.socketHandlers.club
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class ItemUserShopSocketHandler extends BaseSocketHandler
	{
		public function ItemUserShopSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PP_ITEM_USER_GUILD_SHOP;
		}
		
		override public function handlePackage():void
		{
			var length:int = _data.readInt();
			
			for(var i:int=0;i<length;i++)
			{
				var tempObj:Object = {};
				tempObj.itemId = _data.readInt(); //物品id
				tempObj.itemCount = _data.readByte(); //物品数量
				tempObj.itemFinishTime = _data.readInt(); //购买物品最新日期
				GlobalData.clubShopInfo.shopInfo[tempObj.itemId] = tempObj;
			}
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PP_ITEM_USER_GUILD_SHOP);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}