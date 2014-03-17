package sszt.scene.socketHandlers
{
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	
	public class CopyTeamEnterSocketHandler extends BaseSocketHandler
	{
		public function CopyTeamEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_TEAM_ENTER;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			var name:String = _data.readString();
			var type:int = _data.readInt();
			handComplete();
//			if(MapTemplateList.isAcrossBossMap() || !GlobalData.selfScenePlayerInfo.getIsCommon())
//			{
//				return;
//			}
//			MTimerAlert.show(30,MAlert.REFUSE,"队长申请进入"+ name + "副本，您是否立即进入",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.REFUSE,null,copyEnterAlertHandler);
			MTimerAlert.show(30,MAlert.REFUSE,LanguageManager.getWord("ssztl.scene.teamLeaderApplyEnterCopy",name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.REFUSE,null,copyEnterAlertHandler);
			
			function copyEnterAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					if(GlobalData.taskInfo.getTransportTask() != null)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.transporting"));
						return;
					}
					if(GlobalData.copyEnterCountList.isInCopy)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.beInCopy"));
						return;
					}
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					sceneModule.sceneInit.playerListController.getSelf().stopMoving();
					if(type == 0) CopyEnterSocketHandler.send(id);
					else CopyTowerEnterSocketHandler.send(id);
				}
			}
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}