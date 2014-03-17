package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.furnace.FurnaceModule;
	
	public class FurnaceSetSocketHandler extends BaseSocketHandler
	{
		public function FurnaceSetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function addFurnaceSocketHandlers(furnaceModule:FurnaceModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new FurnaceStrengthSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceRebuildSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceReplaceSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceOpenHoleSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceEnchaseSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceRemoveSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceEquipComposeSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceComposeSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceEquipSplitSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceStrengthTransformSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceUpgradeSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceUpLevelSocketHandler(furnaceModule));
//			GlobalAPI.socketManager.addSocketHandler(new FurnaceItemComposeSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceWuHunUpgradeSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceQuenchingSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FurnaceFuseSocketHandler(furnaceModule));
		}
		
		public static function removeFurnaceSocketHandlers():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_STRENG);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_REBUILD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_TAP);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_ENCHASE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_REMOVE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_EQUIP_COMPOSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_COMPOSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_EQUIP_SPLIT);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_STRENGTH_TRANSFORM);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_UPGRADE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_UPLEVEL);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_LUCKY_COMPOSE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_WUHUN_UPGRADE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.QUENCHING);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_FUSE);
		}
	}
}