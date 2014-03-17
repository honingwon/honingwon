package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftDeleteGuardSocketHandler extends BaseSocketHandler
	{
		public function CityCraftDeleteGuardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_DELETE_GUARD;
		}
		
		public static function send(position:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_DELETE_GUARD);
			pkg.writeShort(position);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}