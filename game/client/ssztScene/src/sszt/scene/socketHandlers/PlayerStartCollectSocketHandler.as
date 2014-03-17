package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PlayerStartCollectSocketHandler extends BaseSocketHandler
	{
		public function PlayerStartCollectSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_START_COLLECT;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(id:int,templateId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_START_COLLECT);
			pkg.writeInt(id);
			pkg.writeInt(templateId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}