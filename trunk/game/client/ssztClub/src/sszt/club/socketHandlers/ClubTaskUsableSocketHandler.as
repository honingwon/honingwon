package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubTaskUsableSocketHandler extends BaseSocketHandler
	{
		public function ClubTaskUsableSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_TASK_USABLE_UPDATE;
		}
		
		override public function handlePackage():void
		{
			clubModule.clubInfo.clubWorkInfo.isCanAccept = _data.readBoolean();
			clubModule.clubInfo.clubWorkInfo.update();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_TASK_USABLE_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
	}
}