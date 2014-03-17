package sszt.scene.socketHandlers.cityCraft
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CityCraftDaysInfoSocketHandler extends BaseSocketHandler
	{
		public function CityCraftDaysInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var days:int  = _data.readShort();
			var defNick:String  = _data.readUTF();
			var masterNick:String  = _data.readUTF();
			var atkNick:String = _data.readUTF();
			GlobalData.cityCraftInfo.updateDaysInfo(days,defNick,masterNick,atkNick);
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CITY_CRAFT_DAYS;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CITY_CRAFT_DAYS);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}