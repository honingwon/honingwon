package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class PlayerGetDropItemSocketHandler extends BaseSocketHandler
	{
		public function PlayerGetDropItemSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_GET_DROPITEM;
		}
		
		override public function handlePackage():void
		{
//			pkg.WriteInt(dropid);
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function sendGetDrop(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_GET_DROPITEM);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}