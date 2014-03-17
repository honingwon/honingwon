package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.deviceInfo.ClubDeviceInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubGetDeviceInfoSocketHandler extends BaseSocketHandler
	{
		public function ClubGetDeviceInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_GET_DEVICE_INFO;
		}
		
		override public function handlePackage():void
		{
			var info:ClubDeviceInfo = module.clubInfo.deviceInfo;
			info.shopLevel = _data.readInt();
			info.furnaceLevel = _data.readInt();
			GlobalData.selfPlayer.clubFurnaceLevel = info.furnaceLevel;
			info.shop1Exploit = _data.readInt();
			info.shop2Exploit = _data.readInt();
			info.shop3Exploit = _data.readInt();
			info.shop4Exploit = _data.readInt();
			info.shop5Exploit = _data.readInt();
			info.furnaceExploit = _data.readInt();
			info.update();
			handComplete();
		}
		
		private function get module():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send():void
		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_GET_DEVICE_INFO);
//			GlobalAPI.socketManager.send(pkg);
		}
	}
}