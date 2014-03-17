package sszt.role.mediator
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToRoleData;
	import sszt.core.data.role.RoleInfo;
	import sszt.core.data.titles.TitleTemplateInfo;
	import sszt.core.socketHandlers.role.RoleInfoSocketHandler;
	import sszt.core.socketHandlers.role.RoleNameSaveSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.role.RoleModule;
	import sszt.role.components.FightUpgradePanel;
	import sszt.role.components.RolePropertyPanel;
	import sszt.role.events.RoleMediaEvents;
	
	public class RoleMediator extends Mediator
	{
		public static const NAME:String = "roleMediator";
		public function RoleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [RoleMediaEvents.ROLE_MEDIATOR_START,
				RoleMediaEvents.ROLE_MEDIATOR_START_FIGHTUPANEL,
						RoleMediaEvents.ROLE_MEDIATOR_DISPOSE];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			var data:ToRoleData = notification.getBody() as ToRoleData;
			switch(notification.getName())
			{
				case RoleMediaEvents.ROLE_MEDIATOR_START:
					initialView(data);
					break;
				case RoleMediaEvents.ROLE_MEDIATOR_START_FIGHTUPANEL:
					showFightUpgradePanel(data);
					break;
				case RoleMediaEvents.ROLE_MEDIATOR_DISPOSE:
					dispose();
					break;
				default :
					break;
			}
		}
		
		private function showFightUpgradePanel(data:ToRoleData):void
		{
			if(roleModule.fightUpPanel == null)
			{
				roleModule.fightUpPanel = new FightUpgradePanel(data);
				if(roleModule.assetsReady)
				{
					roleModule.fightUpPanel.assetsCompleteHandler();
				}
				roleModule.fightUpPanel.addEventListener(Event.CLOSE,fightUpgradePanelCloseHandler);
				GlobalAPI.layerManager.addPanel(roleModule.fightUpPanel);
			}
			else
			{
				roleModule.fightUpPanel.dispose();
			}
		}
		
		private function fightUpgradePanelCloseHandler(e:Event):void
		{
			if(roleModule && roleModule.fightUpPanel)
			{
				roleModule.fightUpPanel.removeEventListener(Event.CLOSE,fightUpgradePanelCloseHandler);
				roleModule.fightUpPanel= null;
				for each(var i:RolePropertyPanel in roleModule.rolePropertyPanelList)
				{
					if(i)return;
				}
				roleModule.dispose();
			}
		}
		
		private function initialView(toRoleData:ToRoleData):void
		{
			var rolePlayerId:Number = toRoleData.playerId;
			if(roleModule.rolePropertyPanelList[rolePlayerId] == null)
			{
				roleModule.rolePropertyPanelList[rolePlayerId] = new RolePropertyPanel(this,rolePlayerId, toRoleData.selectIndex);
				setDataToRolePropertyPanel(rolePlayerId);
				GlobalAPI.layerManager.addPanel(roleModule.rolePropertyPanelList[rolePlayerId]);
				roleModule.rolePropertyPanelList[rolePlayerId].addEventListener(Event.CLOSE,closeRolePropertyPanelHandler);
			}
			else
			{
				roleModule.rolePropertyPanelList[rolePlayerId].dispose();
				roleModule.rolePropertyPanelList[rolePlayerId] = null;
			}
//			if(roleModule.isMyself)
//			{
//				SetModuleUtils.addBag();
//			}
		}
		
		private function setDataToRolePropertyPanel(argRolePlayerId:Number):void
		{
			if(argRolePlayerId == GlobalData.selfPlayer.userId)
			{
				roleModule.roleInfoList[argRolePlayerId].equipList = GlobalData.bagInfo._itemList.slice(0,30);
				roleModule.roleInfoList[argRolePlayerId].playerInfo = GlobalData.selfPlayer;
			}
			else
			{
				sendRolePlayerId(argRolePlayerId);
			}
		}
		
		public function sendRolePlayerId(playerId:Number):void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.ROLEINFO_UPDATE, handleRoleInfoUpdate);
			RoleInfoSocketHandler.sendPlayerId(playerId);
		}
		
		private function handleRoleInfoUpdate(e:CommonModuleEvent):void
		{ 
			var data:RoleInfo = e.data as RoleInfo;
			if(!roleModule.roleInfoList[data.playerInfo.userId]) return;
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.ROLEINFO_UPDATE, handleRoleInfoUpdate);
			roleModule.roleInfoList[data.playerInfo.userId].equipList = data.equipList;
			roleModule.roleInfoList[data.playerInfo.userId].playerInfo = data.playerInfo;
		}
		
		private function closeRolePropertyPanelHandler(e:Event):void
		{
			var rolePanel:RolePropertyPanel = e.currentTarget as RolePropertyPanel;
			if(roleModule.rolePropertyPanelList[rolePanel.rolePlayerId])
			{
				roleModule.rolePropertyPanelList[rolePanel.rolePlayerId].removeEventListener(Event.CLOSE,closeRolePropertyPanelHandler);
				roleModule.rolePropertyPanelList[rolePanel.rolePlayerId] = null;
				for each(var i:RolePropertyPanel in roleModule.rolePropertyPanelList)
				{
					if(i)return;
				}
				if(roleModule.fightUpPanel)return;
				roleModule.dispose();
			}
		}
		
		public function sendSaveData(argTitleId:int,argIsHide:Boolean):void
		{
			RoleNameSaveSocketHandler.sendSave(argTitleId,argIsHide);
		}
		
		public function setNameData(argTitleTemplateInfo:TitleTemplateInfo,argPlayerId:Number):void
		{
			roleModule.roleInfoList[argPlayerId].titleTemplateInfo = argTitleTemplateInfo
		}
		
		public function get roleModule():RoleModule
		{
			return viewComponent as RoleModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}