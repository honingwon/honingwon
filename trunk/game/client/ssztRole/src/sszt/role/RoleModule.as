package sszt.role
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToRoleData;
	import sszt.core.data.role.RoleInfo;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.role.components.FightUpgradePanel;
	import sszt.role.events.RoleMediaEvents;
	import sszt.role.socketHandlers.RoleSetSocketHandlers;
	
	public class RoleModule extends BaseModule
	{
		public var roleFacade:RoleFacade;
		public var rolePropertyPanelList:Dictionary = new Dictionary();
		public var roleInfoList:Dictionary = new Dictionary();
		
		public var fightUpPanel:FightUpgradePanel;
//		public var rolePlayerId:Number;
//		public var isMyself:Boolean = false;
		public var assetsReady:Boolean =false;
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			RoleSetSocketHandlers.add(this);
			roleFacade = RoleFacade.getInstance(moduleId.toString());
			roleFacade.setup(this);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			var toRoleData:ToRoleData = data as ToRoleData;
			var rolePlayerId:Number = toRoleData.playerId;
			if(toRoleData.selectIndex ==100)
			{
				roleFacade.sendNotification(RoleMediaEvents.ROLE_MEDIATOR_START_FIGHTUPANEL,toRoleData);
			}
			else if(!rolePropertyPanelList[rolePlayerId])
			{
				roleInfoList[rolePlayerId] = new RoleInfo();
				roleFacade.sendNotification(RoleMediaEvents.ROLE_MEDIATOR_START,toRoleData);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != rolePropertyPanelList[rolePlayerId])
				{
					rolePropertyPanelList[rolePlayerId].setToTop();
				}
				else
				{
					if(toRoleData && toRoleData.forciblyOpen)
					{
						
					}
					else
					{
						rolePropertyPanelList[rolePlayerId].dispose();
					}
				}
			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
		}
		
		override public function assetsCompleteHandler():void
		{
			assetsReady = true;
			for(var i:String in rolePropertyPanelList)
			{
				rolePropertyPanelList[i].assetsCompleteHandler();
			}
			if(fightUpPanel)
			{
				fightUpPanel.assetsCompleteHandler();
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.ROLE;
		}
		
		override public function dispose():void
		{
			if(roleFacade)
			{
				roleFacade.dispose();
				roleFacade = null;
			}
			roleInfoList = null;
			if(rolePropertyPanelList)
			{
				rolePropertyPanelList = null;
			}
			RoleSetSocketHandlers.remove();
			super.dispose();
		}
	}
}