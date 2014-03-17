package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.alert.NoAlertType;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	import sszt.scene.components.doubleSit.DoubleSitIntroducePanel;
	import sszt.scene.components.doubleSit.DoubleSitPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.socketHandlers.PlayerInviteSitSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class DoubleSitMediator extends Mediator
	{
		public static const NAME:String = "DoubleSitMediator";
		
		public function DoubleSitMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.SCENE_SHOWDOUBLESIT,
				SceneMediatorEvent.SCENE_SHOWDOUBLESITINTRO,
				SceneMediatorEvent.SEND_DOUBLESIT_INVITE,
				SceneMediatorEvent.TIME_SIT_TASK_WARN
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SceneMediatorEvent.SCENE_SHOWDOUBLESIT:
					showDoubleSit();
					break;
				case SceneMediatorEvent.SCENE_SHOWDOUBLESITINTRO:
					showDoubleSitIntro();
					break;
				case SceneMediatorEvent.SEND_DOUBLESIT_INVITE:
					var data:Object = notification.getBody();
					inviteSit(data["serverId"],data["nick"],data["id"]);
					break;
				case SceneMediatorEvent.TIME_SIT_TASK_WARN:
				{
					alertTaskWarnning();
					break;
				}
			}
		}
		
		public function showDoubleSit():void
		{
			if(sceneModule.doubleSitPanel == null)
			{
				sceneModule.doubleSitPanel = new DoubleSitPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.doubleSitPanel);
				sceneModule.doubleSitPanel.addEventListener(Event.CLOSE,doubleSitCloseHandler);
			}
		}
		private function doubleSitCloseHandler(evt:Event):void
		{
			if(sceneModule.doubleSitPanel)
			{
				sceneModule.doubleSitPanel.removeEventListener(Event.CLOSE,doubleSitCloseHandler);
				sceneModule.doubleSitPanel = null;
			}
		}
		
		public function showDoubleSitIntro():void
		{
			if(sceneModule.doubleSitIntroPanel == null)
			{
				sceneModule.doubleSitIntroPanel = new DoubleSitIntroducePanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.doubleSitIntroPanel);
				sceneModule.doubleSitIntroPanel.addEventListener(Event.CLOSE,doubleSitIntroCloseHandler);
			}
		}
		private function doubleSitIntroCloseHandler(evt:Event):void
		{
			if(sceneModule.doubleSitIntroPanel)
			{
				sceneModule.doubleSitIntroPanel.removeEventListener(Event.CLOSE,doubleSitIntroCloseHandler);
				sceneModule.doubleSitIntroPanel = null;
			}
		}
		
		/**
		 * 邀请打坐
		 * @param nick
		 * @param id
		 * 
		 */		
		public function inviteSit(serverId:int,nick:String,id:Number = -1):void
		{
			if(sceneInfo.playerList.isDoubleSit())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.alreadyInDoubleSit"));
				return;
			}
			var player:BaseRoleInfo;
			if(id != -1)
			{
				player = sceneInfo.playerList.getPlayer(id);
			}
			else
			{
				player = sceneInfo.playerList.getPlayerByNick(serverId,nick);
			}
			if(player)
			{
				if(player.getIsFight())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.unDoubleSitbeInFight"));
					return;
				}
				PlayerInviteSitSocketHandler.send(serverId,nick,id);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unInviteTooFar"));
			}
		}
		
		
		public function alertTaskWarnning():void{
			var list:Array;
			var task:TaskItemInfo;
			var message:String;
			var alert:Object;
			list = GlobalData.taskInfo.getNoSubmitMainLineTasks();
			if (list.length > 0 && GlobalData.selfPlayer.level < 35){
				
				var sitTaskWarnning:Function = function (evt:CloseEvent):void{
					var deployInfo:DeployItemInfo;
					var deployList:Array;
					var i:int;
					var target:String;
					var mes:String;
					var deploy:String;
					if (evt.isSelected){
						GlobalData.noAlertType.saveByType(NoAlertType.SIT_TASK_WARNNING);
					}
					if (evt.detail == MAlert.GO_RIGHTNOW){
						deployList = [];
						if (list[0] == task){
							deployInfo = new DeployItemInfo();
							deployInfo.type = DeployEventType.TASK_NPC;
							deployInfo.param1 = task.getCurrentState().npc;
							deployInfo.descript = NpcTemplateList.getNpc(deployInfo.param1).name;
							deployList.push(deployInfo);
						} else {
							target = task.getCurrentState().target;
							while (target.indexOf("{") != -1 && (target.indexOf("{") < target.indexOf("}") )) {
								mes = target.slice(target.indexOf("{"), (target.indexOf("}") + 1));
								deploy = mes.slice(1, (mes.length - 1));
								list = deploy.split("#");
								deployInfo = new DeployItemInfo();
								deployInfo.type = list[0];
								deployInfo.param1 = list[2];
								deployInfo.descript = list[1];
								deployList.push(deployInfo);
								target = target.replace(mes, deployInfo.descript);
							}
						}
						i = 0;
						while (i < deployList.length) {
							DeployEventManager.handle(deployList[i]);
							i++;
						}
					}
				}
				task = list[0];
				message = LanguageManager.getWord("ssztl.scene.sitTaskWanning", task.getTemplate().title);
				alert = GlobalData.noAlertType.dataList[NoAlertType.SIT_TASK_WARNNING];
				GlobalData.noAlertType.show(message, null, MAlert.GO_RIGHTNOW, null, sitTaskWarnning, NoAlertType.SIT_TASK_WARNNING, LanguageManager.getWord("ssztl.common.noAlertInThisLogin1"));
			}
		}
		
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}