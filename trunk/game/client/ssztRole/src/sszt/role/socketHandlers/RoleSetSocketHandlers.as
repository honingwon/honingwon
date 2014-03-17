package sszt.role.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.role.RoleModule;
	
	public class RoleSetSocketHandlers extends BaseSocketHandler
	{
		public function RoleSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(roleModule:RoleModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new VeinsInfoSocketHandler(roleModule));
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.VEINS_INFO);
		}
	}
}