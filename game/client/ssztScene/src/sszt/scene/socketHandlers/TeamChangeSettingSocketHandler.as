package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	
	public class TeamChangeSettingSocketHandler extends BaseSocketHandler
	{
		public function TeamChangeSettingSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TEAM_CHANGE_SETTING;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.teamData.autoInTeam = _data.readBoolean();
			sceneModule.sceneInfo.teamData.allocationValue = _data.readByte();
			sceneModule.sceneInfo.teamData.dispatchEvent(new SceneTeamPlayerListUpdateEvent(SceneTeamPlayerListUpdateEvent.CHANGEJOINTYPE));
			handComplete();
		}
		
		public static function sendSetting(autoIn:Boolean,allocationValue:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TEAM_CHANGE_SETTING);
			pkg.writeBoolean(autoIn);
			pkg.writeByte(allocationValue);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}