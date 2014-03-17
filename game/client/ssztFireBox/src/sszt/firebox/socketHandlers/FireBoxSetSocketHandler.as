package sszt.firebox.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.firebox.FireBoxModule;

	public class FireBoxSetSocketHandler
	{
		
		public static function addFireBoxSocketHandlers(furnaceModule:FireBoxModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new FireBoxBuildSocketHandler(furnaceModule));
			GlobalAPI.socketManager.addSocketHandler(new FireBoxMultiBuildSocketHandler(furnaceModule));
		}
		
		public static function removeFireBoxSocketHandlers():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_FIRE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.ITEM_MULTI_FIRE);
		}
	}
}