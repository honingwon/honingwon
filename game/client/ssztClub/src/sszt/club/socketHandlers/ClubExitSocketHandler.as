package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubExitSocketHandler extends BaseSocketHandler
	{
		public function ClubExitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_EXIT;
		}
		
		override public function handlePackage():void
		{
			clubModule.disposePanels();
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_EXIT);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
	}
}