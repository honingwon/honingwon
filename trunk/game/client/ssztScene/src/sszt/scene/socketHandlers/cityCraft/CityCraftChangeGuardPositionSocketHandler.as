package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftChangeGuardPositionSocketHandler extends BaseSocketHandler
	{
		public function CityCraftChangeGuardPositionSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}		
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_CHANGE_GUARD_POSITION;
		}
		
		public static function send(p1:int,p2:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_CHANGE_GUARD_POSITION);
			pkg.writeShort(p1);
			pkg.writeShort(p2);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}