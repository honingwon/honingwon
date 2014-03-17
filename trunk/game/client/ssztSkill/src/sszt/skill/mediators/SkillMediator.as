package sszt.skill.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToSkillData;
	import sszt.core.socketHandlers.skill.SkillLearnOrUpdateSocketHandler;
	import sszt.skill.SkillModule;
	import sszt.skill.commands.SkillStartCommand;
	import sszt.skill.components.SkillPanel;
	import sszt.skill.events.SkillMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SkillMediator extends Mediator
	{
		public static const NAME:String = "skillMediator";
		
		public function SkillMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SkillMediatorEvent.SKILL_MEDIATOR_START,
				SkillMediatorEvent.SKILL_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SkillMediatorEvent.SKILL_MEDIATOR_START:
					initSkillPanel(notification.getBody());
					break;
				case SkillMediatorEvent.SKILL_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initSkillPanel(data:Object):void
		{
			var toData:ToSkillData = data as ToSkillData;
			if(skillModule.skillPanel == null)
			{
				skillModule.skillPanel = new SkillPanel(this);
				GlobalAPI.layerManager.addPanel(skillModule.skillPanel);
				skillModule.skillPanel.addEventListener(Event.CLOSE,skillCloseHandler);
			}
			if(toData!=null && toData.index != -1)
			{
				skillModule.skillPanel.setIndex(toData.index);
			}
		}
		
		private function skillCloseHandler(evt:Event):void
		{
			if(skillModule.skillPanel)
			{
				skillModule.skillPanel.removeEventListener(Event.CLOSE,skillCloseHandler);
				skillModule.skillPanel = null;
				skillModule.dispose();
			}
		}
		
		public function studyOrUpgrade(id:int):void
		{
			SkillLearnOrUpdateSocketHandler.send(id);
		}
		
		public function get skillModule():SkillModule
		{
			return viewComponent as SkillModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}