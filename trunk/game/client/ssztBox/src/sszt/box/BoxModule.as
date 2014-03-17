package sszt.box
{
	import sszt.box.components.BoxPanel;
	import sszt.box.components.GainPanel;
	import sszt.box.components.BoxStorePanel;
	import sszt.box.components.small.OverViewPanel;
	import sszt.box.components.small.XunYuanPanel;
	import sszt.box.data.BoxStoreInfo;
	import sszt.box.events.BoxMediatorEvents;
	import sszt.box.socketHandlers.BoxSetSocketHandler;
	import sszt.box.socketHandlers.StoreItemInitSocketHandler;
	import sszt.box.socketHandlers.UpGainInfoInitHandler;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.module.changeInfos.ToBoxData;
	import sszt.core.module.BaseModule;
	import sszt.interfaces.module.IModule;
	
	public class BoxModule extends BaseModule
	{
		public var facade:BoxFacade;
		public var boxPanel:BoxPanel;
		public var shenmoStorePanel:BoxStorePanel;
		public var xunYuanPanel:XunYuanPanel;
		public var overViewPanel:OverViewPanel;
		public var gainPanel:GainPanel;
		
		public var shenmoStoreInfo:BoxStoreInfo;
		public var toBoxData:ToBoxData;
		
		public function BoxModule()
		{
			super();
		}
		
		override public function setup(prev:IModule, data:Object = null):void
		{
			shenmoStoreInfo = new BoxStoreInfo();
			BoxSetSocketHandler.addHandlers(this);
			
			facade = BoxFacade.getInstance(moduleId.toString());
			facade.setup(this);
			
			configure(data);
			
			UpGainInfoInitHandler.sendInitInfo();
			StoreItemInitSocketHandler.sendInitInfo();
		}
		
		override public function configure(data:Object):void
		{
			toBoxData = data as ToBoxData;
			if(boxPanel && (toBoxData == null || toBoxData.type==1))
			{
				if(GlobalAPI.layerManager.getTopPanel() != boxPanel)
				{
					boxPanel.setToTop();
				}
				else
				{
					boxPanel.dispose();
					return;
				}
			}
			if(toBoxData==null || toBoxData.type == 1)
			{
				facade.sendNotification(BoxMediatorEvents.SHOW_BOX_PANEL);
			}
			else if(toBoxData.type ==2)
			{
				facade.sendNotification(BoxMediatorEvents.SHOW_STORE_PANEL);
			}
//			else if(toBoxData.type==3)
//			{
//				facade.sendNotification(BoxMediatorEvents.SHOW_XUNYUAN_PANEL);
//			}
//			else if(toBoxData.type==4)
//			{
//				facade.sendNotification(BoxMediatorEvents.SHOW_OVERVIEW_PANEL);
//			}
			else if(toBoxData.type==5)
			{
				facade.sendNotification(BoxMediatorEvents.SHOW_GAIN_PANEL,toBoxData.list);
			}
				
		}
		
		override public function get moduleId():int
		{
			return ModuleType.BOX;
		}
		
		override public function assetsCompleteHandler():void
		{
			if(boxPanel)
			{
				boxPanel.assetsCompleteHandler();
			}
		}
		
		override public function dispose():void
		{
			BoxSetSocketHandler.removeHandlers();
			boxPanel = null;
			shenmoStorePanel = null;
			xunYuanPanel = null;
			overViewPanel = null;
			gainPanel = null;
			GlobalData.boxMsgInfo.clearBoxMsgInfo();
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			shenmoStoreInfo = null;
			super.dispose();
		}
	}
}