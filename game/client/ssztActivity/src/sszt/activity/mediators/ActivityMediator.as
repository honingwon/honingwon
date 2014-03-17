package sszt.activity.mediators
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.activity.ActivityModule;
	import sszt.activity.components.ActivityPanel;
	import sszt.activity.components.EnterCodePanel;
	import sszt.activity.components.panels.ActivityBossPanel;
	import sszt.activity.components.panels.ActivityLevelPrompt;
	import sszt.activity.components.panels.ActivityStartRemainingPanel;
	import sszt.activity.components.panels.EntrustmentExtraPanel;
	import sszt.activity.components.panels.EntrustmentPanel;
	import sszt.activity.components.panels.GetSilverPanel;
	import sszt.activity.events.ActivityMediatorEvents;
	import sszt.activity.socketHandlers.PlayerActivyCollectSocketHandler;
	import sszt.activity.socketHandlers.WelfareGetSocketHandler;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.entrustment.EntrustmentTemplateItem;
	import sszt.core.data.entrustment.EntrustmentTemplateList;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.socketHandlers.copy.CopyEnterCountSocketHandler;
	
	public class ActivityMediator extends Mediator
	{
		private var _dataLoader:URLLoader;
		public static const NAME:String = "activityMediator"
		public function ActivityMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [ActivityMediatorEvents.ACTIVITY_MEDIATOR_START,
					 	 ActivityMediatorEvents.ACTIVITY_MEDIATRO_DISPOSE,
						 ActivityMediatorEvents.SHOW_BOSS_PANEL,
						 ActivityMediatorEvents.SHOW_LEVEL_PROMPT_PANEL,
						 ActivityMediatorEvents.SHOW_ACTIVITY_START_REMAINING_PANEL,
						 ActivityMediatorEvents.SHOW_EXCHANGE_PANEL
						];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var toActivityData:ToActivityData = notification.getBody() as ToActivityData;
			switch(notification.getName())
			{
				case ActivityMediatorEvents.ACTIVITY_MEDIATOR_START:
					initialView(notification.getBody());
					break;
				case ActivityMediatorEvents.SHOW_BOSS_PANEL:
					showBossPanel();
					break;
				case ActivityMediatorEvents.SHOW_LEVEL_PROMPT_PANEL:
					showLevelPromptPanel(toActivityData.other);
					break
				case ActivityMediatorEvents.SHOW_ACTIVITY_START_REMAINING_PANEL:
					showActivityStartRemainingPanel(toActivityData.other);
					break;
				case ActivityMediatorEvents.SHOW_EXCHANGE_PANEL:
					showExchangePanel();
					break;
				case ActivityMediatorEvents.ACTIVITY_MEDIATRO_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function showEntrustmentPanel(duplicateId:int):void
		{
			var duplicateTemplateInfo:CopyTemplateItem = CopyTemplateList.getCopy(duplicateId);
			var entrustmentTemplateCollection:Array = EntrustmentTemplateList.getTemplateCollection(duplicateId);
			if(!moduel.entrustmentPanel)
			{
				if(entrustmentTemplateCollection.length == 1)
				{
					moduel.entrustmentPanel = new EntrustmentPanel(duplicateTemplateInfo, (entrustmentTemplateCollection[0] as EntrustmentTemplateItem));
				}
				else
				{
					moduel.entrustmentPanel = new EntrustmentExtraPanel(duplicateTemplateInfo);
				}
				GlobalAPI.layerManager.addPanel(moduel.entrustmentPanel);
				moduel.entrustmentPanel.addEventListener(Event.CLOSE,entrustmentPanelCloseHandler);
			}
		}
		
		protected function entrustmentPanelCloseHandler(e:Event):void
		{
			moduel.entrustmentPanel.removeEventListener(Event.CLOSE,entrustmentPanelCloseHandler);
			moduel.entrustmentPanel.dispose();
			moduel.entrustmentPanel = null;
		}
		
		private function showExchangePanel():void
		{
			if(!moduel.exchangeSilverMoney)
			{
				moduel.exchangeSilverMoney = new GetSilverPanel();
				GlobalAPI.layerManager.addPanel(moduel.exchangeSilverMoney);
				moduel.exchangeSilverMoney.addEventListener(Event.CLOSE,exchangePanelCloseHandler);
			}else
			{
				moduel.exchangeSilverMoney.dispose();
			}
		}
		
		private function exchangePanelCloseHandler(e:Event):void
		{
			moduel.exchangeSilverMoney.removeEventListener(Event.CLOSE,exchangePanelCloseHandler);
			moduel.exchangeSilverMoney = null;
		}
		
		private function showActivityStartRemainingPanel(type:int):void
		{
			if(!moduel.activityStartRemainingPanelDic[type])
			{
				moduel.activityStartRemainingPanelDic[type] = new ActivityStartRemainingPanel(type);
				GlobalAPI.layerManager.addPanel(moduel.activityStartRemainingPanelDic[type]);
				moduel.activityStartRemainingPanelDic[type].addEventListener(Event.CLOSE,activityStartRemainingPanelCloseHandler);
			}
		}
		
		private function activityStartRemainingPanelCloseHandler(event:Event):void
		{
			var panel:ActivityStartRemainingPanel = event.currentTarget as ActivityStartRemainingPanel;
			panel.removeEventListener(Event.CLOSE,activityStartRemainingPanelCloseHandler);
			moduel.activityStartRemainingPanelDic[panel.type] = null;
		}
		
		private function showLevelPromptPanel(type:int):void
		{
			if(!moduel.levelPromptPanelDic[type])
			{
				moduel.levelPromptPanelDic[type] = new ActivityLevelPrompt(type);
				GlobalAPI.layerManager.addPanel(moduel.levelPromptPanelDic[type]);
				moduel.levelPromptPanelDic[type].addEventListener(Event.CLOSE,levelPromptPanelCloseHandler);
			}
		}
		
		private function levelPromptPanelCloseHandler(event:Event):void
		{
			var panel:ActivityLevelPrompt = event.currentTarget as ActivityLevelPrompt;
			panel.removeEventListener(Event.CLOSE,levelPromptPanelCloseHandler);
			moduel.levelPromptPanelDic[panel.type] = null;
		}
		
		private function showBossPanel():void
		{
			if(!moduel.bossPanel)
			{
				moduel.bossPanel = new ActivityBossPanel(this);
				GlobalAPI.layerManager.addPanel(moduel.bossPanel);
				moduel.bossPanel.addEventListener(Event.CLOSE,bossPanelCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() == moduel.bossPanel)
				{
					moduel.bossPanel.dispose();
				}
				else
				{
					moduel.bossPanel.setToTop();
				}
			}
		}
		
		private function bossPanelCloseHandler(event:Event):void
		{
			moduel.bossPanel.removeEventListener(Event.CLOSE,bossPanelCloseHandler);
			moduel.bossPanel = null;
		}
		
		public function loadData():void
		{
			_dataLoader = new URLLoader();
			_dataLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_dataLoader.addEventListener(Event.COMPLETE,loaderCompleteHandler,false,0,true);
			_dataLoader.addEventListener(IOErrorEvent.IO_ERROR,loaderErrorHandler,false,0,true);
			try
			{
				_dataLoader.load(new URLRequest("rank/" + "welfare.xml?" + Math.random()));
			}catch(e:Error)
			{
				
			}
			function loaderCompleteHandler(evt:Event):void
			{
				try
				{
					if(_dataLoader == null)return;
					_dataLoader.removeEventListener(Event.COMPLETE,loaderCompleteHandler);
					_dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,loaderErrorHandler);
					if(_dataLoader == null)return;
					var data:ByteArray = _dataLoader.data as ByteArray;
					if(data == null)return;
					data.position = 0;
					var xmlData:XML = XML(data.readUTFBytes(data.length));
					moduel.activityInfo.readData(xmlData);
				}
				catch(e:Error)
				{
					
				}
				
			}
			function loaderErrorHandler(evt:IOErrorEvent):void
			{
				_dataLoader.removeEventListener(Event.COMPLETE,loaderCompleteHandler);
				_dataLoader.removeEventListener(IOErrorEvent.IO_ERROR,loaderErrorHandler);
			}
		}
		
		public function initialView(data:Object):void
		{
			if(!moduel.activityPanel)
			{
				moduel.activityPanel = new ActivityPanel(this,data);
				GlobalAPI.layerManager.addPanel(moduel.activityPanel);
				moduel.activityPanel.addEventListener(Event.CLOSE,activityCloseHandler);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() == moduel.activityPanel)
				{
					moduel.activityPanel.dispose();
				}
				else
				{
					moduel.activityPanel.setToTop();
				}
			}
		}
		
		private function activityCloseHandler(e:Event):void
		{
			if(moduel.activityPanel)
			{
				moduel.activityPanel.removeEventListener(Event.CLOSE,activityCloseHandler);
				moduel.activityPanel = null;
//				moduel.dispose();
			}
		}
		
		public function showCodeEnterPanel(id:int):void
		{
			if(moduel.codePanel == null)
			{
				moduel.codePanel = new EnterCodePanel(this,id);
				moduel.codePanel.addEventListener(Event.CLOSE,closeCodePanelHandler);
				GlobalAPI.layerManager.addPanel(moduel.codePanel);
			}
		}
		
		private function closeCodePanelHandler(evt:Event):void
		{
			if(moduel.codePanel)
			{
				moduel.codePanel.removeEventListener(Event.CLOSE,closeCodePanelHandler);
				moduel.codePanel = null;
			}
		}
		
		private function setActiveData():void
		{
			
		}
		
		public function searchWelf(id:int):void
		{
			WelfareGetSocketHandler.sendGetWelfare(id);
		}
		
		public function getCopyNumber():void
		{
			CopyEnterCountSocketHandler.send();
		}
		
		public function sendGetWelfare(id:int,code:String):void
		{
			PlayerActivyCollectSocketHandler.send(id,code);
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
		
		public function get moduel():ActivityModule
		{
			return viewComponent as ActivityModule;
		}
	}
}