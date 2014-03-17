package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubLotteryGetTimesSocketHandler extends BaseSocketHandler
	{
		public function ClubLotteryGetTimesSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_PRAYER_TIMES;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var type:int;
			var value:int;
			for(var i:int = 0; i < len; i++)
			{
				type = _data.readShort();
				value = _data.readShort();
			}
			clubModule.clubInfo.clubLotteryInfo.updateTimes(value);
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_PRAYER_TIMES);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}