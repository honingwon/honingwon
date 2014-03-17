package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CopyRandMoneySocketHandler extends BaseSocketHandler
	{
		public function CopyRandMoneySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.COPY_RAND_MONEY;
		}
		
		override public function handlePackage():void
		{
//			sceneModule.sceneInfo.dropItemList.removeItemAll();
//			sceneModule.duplicateMonyeInfo.updateComboTickState();
			sceneModule.duplicateMonyeInfo.randMoneyStop(_data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_RAND_MONEY);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}