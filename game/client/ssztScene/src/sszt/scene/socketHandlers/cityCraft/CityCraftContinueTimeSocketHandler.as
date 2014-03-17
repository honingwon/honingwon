package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftContinueTimeSocketHandler extends BaseSocketHandler
	{
		public function CityCraftContinueTimeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var leftTime:int  = _data.readInt();
			GlobalData.cityCraftInfo.updateReloadTime(leftTime);
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_CONTINUE_TIME;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_CONTINUE_TIME);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}