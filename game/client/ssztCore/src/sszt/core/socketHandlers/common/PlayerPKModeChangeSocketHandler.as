package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class PlayerPKModeChangeSocketHandler extends BaseSocketHandler
	{
		public function PlayerPKModeChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_PK_MODE_CHANGE;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.PKMode = _data.readByte();
			GlobalData.selfPlayer.PKModeChangeDate = _data.readDate();
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.PK_MODE_CHANGE));
			
			handComplete();
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_PK_MODE_CHANGE);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}