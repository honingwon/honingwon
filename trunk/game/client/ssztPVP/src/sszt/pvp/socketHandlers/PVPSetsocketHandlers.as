package sszt.pvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.pvp.PVPModule;
	
	public class PVPSetsocketHandlers extends BaseSocketHandler
	{
		public function PVPSetsocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(pvpModule:PVPModule):void
		{
//			GlobalAPI.socketManager.addSocketHandler(new PVPActiveStartSocketHandler(pvpModule));
			GlobalAPI.socketManager.addSocketHandler(new PVPActiveJoinSocketHandler(pvpModule));
			GlobalAPI.socketManager.addSocketHandler(new PVPActiveQuitSocketHandler(pvpModule));
			GlobalAPI.socketManager.addSocketHandler(new PVPStartSocketHandler(pvpModule));
//			GlobalAPI.socketManager.addSocketHandler(new PVPEndSocketHandler(pvpModule));
//			GlobalAPI.socketManager.addSocketHandler(new PVPActiveFinishSocketHandler(pvpModule));
			GlobalAPI.socketManager.addSocketHandler(new PVPExploitInfoSocketHandler(pvpModule));
		}
		
		public static function remove():void
		{
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_ACTIVE_START);			
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_ACTIVE_JOIN);	
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_ACTIVE_QUIT);	
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_START);	
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_END);	
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_ACTIVE_FINISH);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.PVP_EXPLOIT_INFO);
		}
	}
}