package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftEnterSocketHandler extends BaseSocketHandler
	{
		public function CityCraftEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_ENTER;
		}
		
		override public function handlePackage():void
		{
			GlobalData.cityCraftInfo.showGuildEnter();
			handComplete();
		}
		
		//4是攻,5是守		
		public static function send(camp:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_ENTER);
			pkg.writeByte(camp);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}