package sszt.marriage
{
	
	import sszt.core.data.marriage.MarriageInfo;
	import sszt.core.data.marriage.WeddingInvitationInfo;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToMarriageData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	import sszt.marriage.componet.MarriageUIStateList;
	import sszt.marriage.componet.MarryTargetPanel;
	import sszt.marriage.data.MarriageRelationList;
	import sszt.marriage.event.MarriageMediatorEvent;
	import sszt.marriage.socketHandlers.MarriageSetSocketHandler;
	
	public class MarriageModule extends BaseModule
	{
		public var assetReady:Boolean;
		public var marriageInfo:MarriageInfo = new MarriageInfo();
		public var marriageRelationList:MarriageRelationList = new MarriageRelationList();
		
		public var facade:MarriageFacade;
		public var marriageUIStateList:MarriageUIStateList = new MarriageUIStateList();
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			MarriageSetSocketHandler.add(this);
			
			facade = MarriageFacade.getInstance(String(moduleId));
			facade.startup(this,data);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			var toMarriageData:ToMarriageData = data as ToMarriageData;
			if(toMarriageData.type == 0)
			{
				facade.sendNotification(MarriageMediatorEvent.MARRIAGE_START);
			}
			else if(toMarriageData.type == 1)
			{
				facade.sendNotification(MarriageMediatorEvent.SHOW_MARRY_TARGET_PANEL,data);
			}
			else if(toMarriageData.type == 2)
			{
				facade.sendNotification(MarriageMediatorEvent.SHOW_WEDDING_PANEL,data);
			}
			else if(toMarriageData.type == 3)
			{
				facade.sendNotification(MarriageMediatorEvent.SHOW_WEDDING_INVITATION_CARD,data);
			}
			else if(toMarriageData.type == 4)
			{
				facade.sendNotification(MarriageMediatorEvent.SHOW_MARRY_REFUSE_PANEL,data);
			}
			else if(toMarriageData.type == 5)
			{
				facade.sendNotification(MarriageMediatorEvent.SHOW_MARRIAGE_MANAGE_PANEL);
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.MARRIAGE;
		}
		
		override public function assetsCompleteHandler():void
		{
			assetReady = true;
			if(marriageUIStateList.marriageEntrancePanel)
			{
				marriageUIStateList.marriageEntrancePanel.assetsCompleteHandler();
			}
			if(marriageUIStateList.weddingInvitationCardView)
			{
				marriageUIStateList.weddingInvitationCardView.assetsCompleteHandler();
			}
			if(marriageUIStateList.marriageManagePanel)
			{
				marriageUIStateList.marriageManagePanel.assetsCompleteHandler();
			}
			MarryTargetPanel.getInstance().assetsCompleteHandler();
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
		}
	}
}