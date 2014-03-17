package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ClubBuyItemEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class ItemUserShopBuySocketHandler extends BaseSocketHandler
	{
		public function ItemUserShopBuySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PP_ITEM_GUILD_SHOP_BUY;
		}
		
		override public function handlePackage():void
		{
			var isSucc:Boolean = _data.readBoolean();
			if(isSucc)
			{
				var tempObj:Object = {};
				tempObj.itemId = _data.readInt(); //物品id
				tempObj.itemCount = _data.readByte(); //物品数量
				tempObj.itemFinishTime = _data.readInt(); //购买物品最新日期
				GlobalData.clubShopInfo.shopInfo[tempObj.itemId] = tempObj;
				ModuleEventDispatcher.dispatchModuleEvent(new ClubBuyItemEvent(ClubBuyItemEvent.CLUB_BUY_ITEM,{id:tempObj.itemId}));
			}
			
			
			handComplete();
		}
		
		public static function send(shopId:int,count:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PP_ITEM_GUILD_SHOP_BUY);
			pkg.writeInt(shopId);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}