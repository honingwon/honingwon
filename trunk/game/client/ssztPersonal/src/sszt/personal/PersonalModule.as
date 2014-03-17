package sszt.personal
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToPersonalData;
	import sszt.core.data.personal.PersonalInfo;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.personal.components.PersonalChangeHeadPanel;
	import sszt.personal.components.PersonalLuckyWheelPanel;
	import sszt.personal.components.PersonalMainPanel;
	import sszt.personal.data.PersonalPartInfo;
	import sszt.personal.events.PersonalMediatorEvents;
	import sszt.personal.socketHandlers.PersonalSetSocketHandlers;
	
	public class PersonalModule extends BaseModule
	{
		public var facade:PersonalFacade;
		public var personalChangeHeadPanel:PersonalChangeHeadPanel;
		public var personalLuckyWheelPanel:PersonalLuckyWheelPanel;
		
		public var personalMainPanelList:Dictionary = new Dictionary();
		public var personalInfoList:Dictionary = new Dictionary();
		
		public function PersonalModule()
		{
			super();
		}
		
		override public function get moduleId():int
		{
			return ModuleType.PERSONAL;
		}
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			PersonalSetSocketHandlers.setSokectHandlers(this);
			facade = PersonalFacade.getInstance(moduleId.toString());
			facade.setup(this);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			var toPersonalData:ToPersonalData = data as ToPersonalData;
			var playerId:Number = toPersonalData.playerId;
			if(!personalMainPanelList[playerId])
			{
				personalInfoList[playerId] = new PersonalPartInfo();
				facade.sendNotification(PersonalMediatorEvents.PERSONAL_MEDIATOR_START,playerId);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != personalMainPanelList[playerId])
				{
					personalMainPanelList[playerId].setToTop();
				}
				else
				{
					personalMainPanelList[playerId].dispose();
				}
			}
		}
		
		override public function dispose():void
		{
			PersonalSetSocketHandlers.removeSocketHandlers();
			super.dispose();
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			personalMainPanelList = null;
			personalInfoList = null;
			 if(personalChangeHeadPanel)
			 {
				 personalChangeHeadPanel.dispose();
				 personalChangeHeadPanel = null;
			 }
		}
	}
}