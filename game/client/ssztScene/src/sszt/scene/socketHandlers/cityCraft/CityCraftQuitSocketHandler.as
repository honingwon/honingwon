package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftQuitSocketHandler extends BaseSocketHandler
	{
		public function CityCraftQuitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var res:int  = _data.readByte();
			var time:int = _data.readInt();
			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_QUIT;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_QUIT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}