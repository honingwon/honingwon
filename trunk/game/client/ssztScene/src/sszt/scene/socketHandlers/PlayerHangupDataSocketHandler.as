package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class PlayerHangupDataSocketHandler extends BaseSocketHandler
	{
		public function PlayerHangupDataSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_HANGUPDATA;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.hangupData.setConfig(_data.readString());
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function sendConfig(config:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_HANGUPDATA);
			pkg.writeString(config);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}