package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class CopyTowerEnterSocketHandler extends BaseSocketHandler
	{
		public function CopyTowerEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_TOWER_ENTER;
		}
		
		public static function send(id:int):void
		{
			GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.waittingForCopy"));
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_TOWER_ENTER);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}