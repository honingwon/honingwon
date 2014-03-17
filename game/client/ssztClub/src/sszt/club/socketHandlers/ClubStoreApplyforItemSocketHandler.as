package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreApplyforItemSocketHandler extends BaseSocketHandler
	{
		public function ClubStoreApplyforItemSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_GET;
		}
		
		override public function handlePackage():void
		{
			var data:int = _data.readByte();
			handComplete();
			QuickTips.show(LanguageManager.getWord("ssztl.club.applyforItemComplete"));
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(itemID:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_GET);
			pkg.writeNumber(itemID);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}