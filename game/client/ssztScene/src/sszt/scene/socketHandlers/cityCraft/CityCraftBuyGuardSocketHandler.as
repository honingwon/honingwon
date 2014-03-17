package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftBuyGuardSocketHandler extends BaseSocketHandler
	{
		public function CityCraftBuyGuardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_BUY_GUARD;
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_BUY_GUARD);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}