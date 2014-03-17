package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class CopyTeamConfirmSocketHandler extends BaseSocketHandler
	{
		public function CopyTeamConfirmSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_TEAM_CONFIRM;
		}
		
		override public function handlePackage():void
		{
			var ok:int = _data.readInt();
			var deny:int = _data.readInt();
			if(sceneModule.copyEnterAlert)
			{
				sceneModule.copyEnterAlert.updateValue(ok,deny);
			}else
			{
				sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYALERT);
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(value:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_TEAM_CONFIRM);
			pkg.writeBoolean(value);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}