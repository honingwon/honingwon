package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubStoreCancelItemRequestSocketHandler extends BaseSocketHandler
	{
		public function ClubStoreCancelItemRequestSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_STORE_CANCEL_ITEM_REQUEST;
		}
		
		override public function handlePackage():void
		{
			//与服务器端约定：如果有数据包返回，那么一定表示取消申请成功
			QuickTips.show(LanguageManager.getWord("ssztl.club.cancelItemRequestComplete"));
			ClubStoreAppliedItemRecordsSocketHandler.send(1);
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(recordId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_STORE_CANCEL_ITEM_REQUEST);
			pkg.writeNumber(recordId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}