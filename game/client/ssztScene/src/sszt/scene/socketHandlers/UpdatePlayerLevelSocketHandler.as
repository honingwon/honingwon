package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.levelUpDeploy.LevelUpDeployTemplateInfo;
	import sszt.core.data.levelUpDeploy.LevelUpDeployTemplateList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class UpdatePlayerLevelSocketHandler extends BaseSocketHandler
	{
		public function UpdatePlayerLevelSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.UPDATE_PLAYER_LEVEL;
		}
		
		override public function handlePackage():void		
		{
			var id:Number = _data.readNumber();
			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				player.doUpgrade(_data.readShort(),_data.readInt(),_data.readInt(),_data.readInt(),_data.readInt());
			}
			if(id == GlobalData.selfPlayer.userId)
			{
				GlobalData.selfPlayer.updateTotalLifeExperiense(_data.readUnsignedInt());
				GlobalData.selfPlayer.updateLifeExp(_data.readUnsignedInt());
				
				for each(var info:LevelUpDeployTemplateInfo in LevelUpDeployTemplateList.deployList)
				{
					if(GlobalData.selfPlayer.level == info.level)
					{
						DeployEventManager.handle(info.deploy);
					}
				}
				
				ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_CHECKSTATE));
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UPGRADE));
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}