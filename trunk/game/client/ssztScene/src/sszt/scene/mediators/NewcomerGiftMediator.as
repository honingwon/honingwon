package sszt.scene.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.ActivityIcon.NewcomerGiftView;
	import sszt.scene.components.newcomerGift.NewcomerGiftPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class NewcomerGiftMediator extends Mediator
	{
		public static const NAME:String = "newcomerGiftMediator";
		public function NewcomerGiftMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.NEWCOMER_GIFT_ICON,
				SceneMediatorEvent.REMOVE_NEWCOMER_GIFT_ICON,
				SceneMediatorEvent.SHOW_NEWCOMER_GIFT_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch(notification.getName())
			{
				case SceneMediatorEvent.NEWCOMER_GIFT_ICON:
					initNewcomerGiftIcon(data as int);
					break;
				case SceneMediatorEvent.REMOVE_NEWCOMER_GIFT_ICON:
					removeNewcomerGiftIcon();
					break;
				case SceneMediatorEvent.SHOW_NEWCOMER_GIFT_PANEL:
					showNewcomerGiftPanel(data.giftItemTemplateId);
					break;
			}
		}
		
		private function removeNewcomerGiftIcon():void
		{
			NewcomerGiftView.getInstance().dispose();
		}
		
		private function initNewcomerGiftIcon(currentGiftItemTemplateId:int):void
		{
			NewcomerGiftView.getInstance().show(currentGiftItemTemplateId,this,true);
		}
		
		private function showNewcomerGiftPanel(giftItemTemplateId:int):void
		{
			if(sceneModule.newcomerGiftPanel == null)
			{
				sceneModule.newcomerGiftPanel = new NewcomerGiftPanel(this, giftItemTemplateId);
				GlobalAPI.layerManager.addPanel(sceneModule.newcomerGiftPanel);
				sceneModule.newcomerGiftPanel.addEventListener(Event.CLOSE,newcomerGiftPanelCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != sceneModule.newcomerGiftPanel)
				{
					sceneModule.newcomerGiftPanel.setToTop();
				}
				else
				{
					sceneModule.newcomerGiftPanel.dispose();
				}
			}
		}
		
		private function newcomerGiftPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.newcomerGiftPanel)
			{
				sceneModule.newcomerGiftPanel.removeEventListener(Event.CLOSE,newcomerGiftPanelCloseHandler);
				sceneModule.newcomerGiftPanel = null;
			}
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
		
		public function get sceneModule():SceneModule
		{
			return viewComponent as SceneModule;
		}
		public function get sceneInfo():SceneInfo
		{
			return sceneModule.sceneInfo;
		}
	}
}