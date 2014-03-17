package sszt.scene.mediators
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.scene.SceneModule;
	import sszt.scene.components.duplicateLottery.DuplicateLotteryIcon;
	import sszt.scene.components.duplicateLottery.DuplicateLotteryPanel;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class DuplicateLotteryMediator extends Mediator
	{
		public static const NAME:String = "duplicateLotteryMediator";
		private var _counter:uint = 10;
		private var _intervalId:uint;
		
		public function DuplicateLotteryMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				SceneMediatorEvent.DUPLICATE_LOTTERY_ATTENTIION,
				SceneMediatorEvent.SHOW_DUPLICATE_LOTTERY_PANEL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var data:Object = notification.getBody();
			switch(notification.getName())
			{
				case SceneMediatorEvent.DUPLICATE_LOTTERY_ATTENTIION:
					initDuplicateLotteryIcon();
					break;
				case SceneMediatorEvent.SHOW_DUPLICATE_LOTTERY_PANEL:
					showDuplicateLotteryPanel();
					break;
			}
		}
		
		private function initDuplicateLotteryIcon():void
		{
			if(sceneModule.duplicateLotteryIcon == null)
			{
				sceneModule.duplicateLotteryIcon = new DuplicateLotteryIcon(this);
				GlobalAPI.layerManager.getTipLayer().addChild(sceneModule.duplicateLotteryIcon);
				sceneModule.duplicateLotteryIcon.addEventListener(MouseEvent.CLICK,removeDuplicateLotteryIcon);
			}
		}
		
		public function autoGetDulicateLottery():void
		{
			if(sceneModule.duplicateLotteryIcon && sceneModule.duplicateLotteryIcon.parent)
			{
				sceneModule.duplicateLotteryIcon.removeEventListener(MouseEvent.CLICK,removeDuplicateLotteryIcon);
				sceneModule.duplicateLotteryIcon.dispose();
				sceneModule.duplicateLotteryIcon = null;
				if(sceneModule.duplicateLotteryPanel == null)
				{
					sceneModule.duplicateLotteryPanel = new DuplicateLotteryPanel(this);
					GlobalAPI.layerManager.addPanel(sceneModule.duplicateLotteryPanel);
					sceneModule.duplicateLotteryPanel.addEventListener(Event.CLOSE,duplicateLotteryPanelCloseHandler);
					sceneModule.duplicateLotteryPanel.autoGetDulicateLottery();
				}
			}
		}
		
		private function removeDuplicateLotteryIcon(e:MouseEvent):void
		{
			if(sceneModule.duplicateLotteryIcon && sceneModule.duplicateLotteryIcon.parent)
			{
				sceneModule.duplicateLotteryIcon.removeEventListener(MouseEvent.CLICK,removeDuplicateLotteryIcon);
				sceneModule.duplicateLotteryIcon.dispose();
				sceneModule.duplicateLotteryIcon = null;
			}
			showDuplicateLotteryPanel();
		}		
		
		private function showDuplicateLotteryPanel():void
		{
			if(sceneModule.duplicateLotteryPanel == null)
			{
				sceneModule.duplicateLotteryPanel = new DuplicateLotteryPanel(this);
				GlobalAPI.layerManager.addPanel(sceneModule.duplicateLotteryPanel);
				sceneModule.duplicateLotteryPanel.addEventListener(Event.CLOSE,duplicateLotteryPanelCloseHandler);
			}
		}
		
		private function duplicateLotteryPanelCloseHandler(evt:Event):void
		{
			if(sceneModule.duplicateLotteryPanel)
			{
				sceneModule.duplicateLotteryPanel.removeEventListener(Event.CLOSE,duplicateLotteryPanelCloseHandler);
				sceneModule.duplicateLotteryPanel = null;
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