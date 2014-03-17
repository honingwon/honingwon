package sszt.box.mediators
{
	import flash.events.Event;
	
	import sszt.box.BoxModule;
	import sszt.box.components.BoxPanel;
	import sszt.box.components.GainPanel;
	import sszt.box.components.BoxStorePanel;
	import sszt.box.components.small.OverViewPanel;
	import sszt.box.components.small.XunYuanPanel;
	import sszt.box.events.BoxMediatorEvents;
	import sszt.core.data.GlobalAPI;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class BoxMediator extends Mediator
	{
		public static const NAME:String = "boxMediator";
		public function BoxMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				BoxMediatorEvents.SHOW_BOX_PANEL,
				BoxMediatorEvents.SHOW_STORE_PANEL,
//				BoxMediatorEvents.SHOW_XUNYUAN_PANEL,
//				BoxMediatorEvents.SHOW_OVERVIEW_PANEL,
				BoxMediatorEvents.BOX_MEDIATOR_DISPOSE,
				BoxMediatorEvents.SHOW_GAIN_PANEL
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case BoxMediatorEvents.SHOW_BOX_PANEL:
					showBox();
					break;
				case BoxMediatorEvents.SHOW_STORE_PANEL:
					showStore();
					break;
//				case BoxMediatorEvents.SHOW_XUNYUAN_PANEL:
//					showXunYuan();
//					break;
//				case BoxMediatorEvents.SHOW_OVERVIEW_PANEL:
//					showOverView();
//					break;
				case BoxMediatorEvents.SHOW_GAIN_PANEL:
					showGain(notification.getBody() as Array);
					break;
				case BoxMediatorEvents.BOX_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function showBox():void
		{
			if(boxModule.boxPanel)
			{
				boxModule.boxPanel.dispose();
			}
			else
			{
				boxModule.boxPanel = new BoxPanel(this);
				boxModule.boxPanel.addEventListener(Event.CLOSE, boxCloseHandler);
				GlobalAPI.layerManager.addPanel(boxModule.boxPanel);
			}
		}
		
		public function showStore():void
		{
			if(boxModule.shenmoStorePanel)
			{
				boxModule.shenmoStorePanel.dispose();
			}
			else
			{
				boxModule.shenmoStorePanel = new BoxStorePanel(this);
				boxModule.shenmoStorePanel.addEventListener(Event.CLOSE, storeCloseHandler);
				GlobalAPI.layerManager.addPanel(boxModule.shenmoStorePanel);
			}
		}
		
		public function showXunYuan():void
		{
			if(boxModule.xunYuanPanel)
			{
				boxModule.xunYuanPanel.dispose();
			}
			else
			{
				boxModule.xunYuanPanel = new XunYuanPanel(this);
				boxModule.xunYuanPanel.addEventListener(Event.CLOSE, xunYuanCloseHandler);
				GlobalAPI.layerManager.addPanel(boxModule.xunYuanPanel);
			}
		}
		
		public function showOverView():void
		{
			if(boxModule.overViewPanel)
			{
				boxModule.overViewPanel.dispose();
			}
			else
			{
				boxModule.overViewPanel = new OverViewPanel(this);
				boxModule.overViewPanel.addEventListener(Event.CLOSE, overViewCloseHandler);
				GlobalAPI.layerManager.addPanel(boxModule.overViewPanel);
			}
		}
		
		private function showGain(list:Array):void
		{
			if(boxModule.gainPanel)
			{
				boxModule.gainPanel.initTile(list);
				boxModule.gainPanel.setToTop();
			}
			else
			{
				boxModule.gainPanel = new GainPanel();
				boxModule.gainPanel.initTile(list);
				boxModule.gainPanel.addEventListener(Event.CLOSE,gainCloseHandler);
				GlobalAPI.layerManager.addPanel(boxModule.gainPanel);
			}
		}
		
		private function boxCloseHandler(evt:Event):void
		{
			if(boxModule.boxPanel)
			{
				boxModule.boxPanel.removeEventListener(Event.CLOSE, boxCloseHandler);
				boxModule.boxPanel = null;
			}
			
//			if(boxModule && boxModule.boxPanel == null && boxModule.shenmoStorePanel == null && boxModule.overViewPanel==null && boxModule.xunYuanPanel==null && boxModule.gainPanel==null)
//			{
//				boxModule.dispose();
//			}
			disposeModule();
		}
		
		private function storeCloseHandler(evt:Event):void
		{
			if(boxModule.shenmoStorePanel)
			{
				boxModule.shenmoStorePanel.removeEventListener(Event.CLOSE, storeCloseHandler);
				boxModule.shenmoStorePanel = null;
			}
//			if(boxModule && boxModule.boxPanel == null && boxModule.shenmoStorePanel == null && boxModule.overViewPanel==null && boxModule.xunYuanPanel==null && boxModule.gainPanel==null)
//			{
//				boxModule.dispose();
//			}
			disposeModule();
		}
		
		private function xunYuanCloseHandler(evt:Event):void
		{
			if(boxModule.xunYuanPanel)
			{
				boxModule.xunYuanPanel.removeEventListener(Event.CLOSE, xunYuanCloseHandler);
				boxModule.xunYuanPanel = null;
			}
//			if(boxModule && boxModule.boxPanel == null && boxModule.shenmoStorePanel == null && boxModule.overViewPanel==null && boxModule.xunYuanPanel==null && boxModule.gainPanel==null)
//			{
//				boxModule.dispose();
//			}
			disposeModule();
		}
		
		private function overViewCloseHandler(evt:Event):void
		{
			if(boxModule.overViewPanel)
			{
				boxModule.overViewPanel.removeEventListener(Event.CLOSE, overViewCloseHandler);
				boxModule.overViewPanel = null;
			}
//			if(boxModule && boxModule.boxPanel == null && boxModule.shenmoStorePanel == null && boxModule.overViewPanel==null && boxModule.xunYuanPanel==null && boxModule.gainPanel==null)
//			{
//				boxModule.dispose();
//			}
			disposeModule();
		}
		
		private function gainCloseHandler(evt:Event):void
		{
			
			if(boxModule && boxModule.gainPanel)
			{
				boxModule.gainPanel.removeEventListener(Event.CLOSE,gainCloseHandler);
				boxModule.gainPanel = null;
			}
//			if(boxModule && boxModule.boxPanel == null && boxModule.shenmoStorePanel == null && boxModule.overViewPanel==null && boxModule.xunYuanPanel==null && boxModule.gainPanel==null)
//			{
//				boxModule.dispose();
//			}
			disposeModule();
		}
		
		private function disposeModule():void
		{
			if(boxModule && boxModule.boxPanel == null && boxModule.shenmoStorePanel == null && boxModule.overViewPanel==null && boxModule.xunYuanPanel==null && boxModule.gainPanel==null)
			{
				boxModule.dispose();
			}
		}
		
		public function get boxModule():BoxModule
		{
			return viewComponent as BoxModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}