package sszt.setting.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToSettingData;
	import sszt.setting.SettingModule;
	import sszt.setting.components.SettingPanel;
	import sszt.setting.events.SettingMediatorEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SettingMediator extends Mediator
	{
		public static const NAME:String = "SettingMediator";
		
		public function SettingMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SettingMediatorEvent.SETTING_MEDIATOR_START,
				SettingMediatorEvent.SETTING_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case SettingMediatorEvent.SETTING_MEDIATOR_START:
					initView(notification.getBody());
					break;
				case SettingMediatorEvent.SETTING_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView(data:Object):void
		{
			var toData:ToSettingData = data as ToSettingData;
			if(settingModule.settingPanel == null)
			{
				settingModule.settingPanel = new SettingPanel(this,toData);
				GlobalAPI.layerManager.addPanel(settingModule.settingPanel);
				settingModule.settingPanel.addEventListener(Event.CLOSE,settingCloseHandler);
			}
			else
			{
				settingModule.settingPanel.dispose();
				settingModule.settingPanel = null;
			}
		}
		
		private function settingCloseHandler(evt:Event):void
		{
			if(settingModule.settingPanel)
			{
				settingModule.settingPanel.removeEventListener(Event.CLOSE,settingCloseHandler);
				settingModule.settingPanel = null;
				settingModule.dispose();
			}
		}
		
		public function get settingModule():SettingModule
		{
			return viewComponent as SettingModule;
		}
		
		private function dispose():void
		{
			viewComponent = null;
		}
	}
}