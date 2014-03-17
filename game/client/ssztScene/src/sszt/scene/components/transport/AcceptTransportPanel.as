package sszt.scene.components.transport
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskStateTemplateInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.task.TaskAcceptSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.transport.TransportQualityRefreshHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class AcceptTransportPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneMediator;
		private var _quality:int;
		
		private var _checkBox:CheckBox;
		private var _comboxQuality:ComboBox;
		private var _refreshCopper:MAssetLabel;
		private var _totalTimes:MAssetLabel;
		private var _awardText:MAssetLabel;
		
		private var _refreshBtn:MCacheAssetBtn1;
		private var _acceptBtn:MCacheAssetBtn1;
		
		private var _curTransportTask:TaskTemplateInfo;
		private var _curTaskStateInfo:TaskStateTemplateInfo;
		private var _alert:MAlert;
		
		private var _waresList:Array;
		
		public function AcceptTransportPanel(mediator:SceneMediator,quality:int)
		{
			_mediator = mediator;
			for each(var template:TaskTemplateInfo in TaskTemplateList.getTemplateList())
			{
				if(template.condition == TaskConditionType.TRANSPORT && template.getCanAccept())
				{
					_curTransportTask = template;
					break;
				}
			}
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.scene.TransportTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.scene.TransportTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1, true, true);
			
			updateQuality(quality);
			initEvents();
			if(getDateLeftCount() == 0)
			{
				_refreshBtn.enabled = false;
				_acceptBtn.enabled = false;
			}
		}
		
		override protected function configUI():void
		{
			super.configUI();
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,10);
			setContentSize(565,372);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,549,362)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,541,241)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,249,541,111)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(87,288,16,14),new Bitmap(MoneyIconCaches.bingCopperAsset)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(231,265,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.dayLeftTimeValue"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(231,287,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.core.taskAward") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(30,287,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.transport.refreshConsume") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			var stateList:Array = _curTransportTask.states;
			if(stateList && stateList.length>0)
			{
				_waresList = [];
				for(var i:int=0;i<stateList.length;i++)
				{
					var item:WaresItemView = new WaresItemView(stateList[i],i);
					item.move(15+i*107,9);
					_waresList.push(item);
					addContent(item);
				}
			}
			
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,26,148,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.transportAwardExplain"),MAssetLabel.LABELTYPE1)));
			
//			var textField:TextField = new TextField();
//			textField.selectable = false;
//			textField.x = 18;
//			textField.y = 49;
//			textField.width = 196;
//			textField.height = 16;
//			textField.multiline = true;
//			textField.defaultTextFormat = format;
//			textField.htmlText = LanguageManager.getWord("ssztl.scene.transportDetail");
//			addContent(textField);
			
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,73,88,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.needCopper"),MAssetLabel.LABELTYPE14)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,96,88,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.curTransportQuality"),MAssetLabel.LABELTYPE14)));
//			
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(20,188,280,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.refreshTransportNeed"),MAssetLabel.LABELTYPE17)));
//			
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,230,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.core.taskAward") + "：",MAssetLabel.LABELTYPE14)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,253,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.experience2")  + "：",MAssetLabel.LABELTYPE14)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(18,270,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.copper2") + "：",MAssetLabel.LABELTYPE14)));
//			
			_refreshBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.refreshTransport"));
			_refreshBtn.move(74,319);
			addContent(_refreshBtn);
			if(getDateLeftCount() == 0) _refreshBtn.enabled = false;
			
			_acceptBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.scene.acceptTransport"));
			_acceptBtn.move(340,316);
			addContent(_acceptBtn);
			
			_totalTimes = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_totalTimes.move(315,265);
			_totalTimes.setValue(getDateLeftCount() + "/5" + LanguageManager.getWord("ssztl.activity.entrustAmount"));
			addContent(_totalTimes);
			
			_awardText = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_awardText.move(291,287);
			addContent(_awardText);
			
			_checkBox = new CheckBox();
			_checkBox.buttonMode = true;
			_checkBox.useHandCursor = true;
			_checkBox.label = LanguageManager.getWord("ssztl.scene.refreshQuit");
			_checkBox.selected = true;
			_checkBox.width = 150;
			_checkBox.move(29,273);
			addContent(_checkBox);
			
			_refreshCopper = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_refreshCopper.move(105,287);
			addContent(_refreshCopper);
			_refreshCopper.setValue("2000");
			
			_comboxQuality = new ComboBox();
			_comboxQuality.open();
			_comboxQuality.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_comboxQuality.x = 82;
			_comboxQuality.y = 263;
			_comboxQuality.width = 58;
			_comboxQuality.height = 22;
			_comboxQuality.rowCount = 6;
			addContent(_comboxQuality);
			_comboxQuality.dataProvider = new DataProvider([
				{label:LanguageManager.getWord("ssztl.common.whiteQulity2"),value:0},
				{label:LanguageManager.getWord("ssztl.common.greenQulity2"),value:1},
				{label:LanguageManager.getWord("ssztl.common.blueQulity2"),value:2},
				{label:LanguageManager.getWord("ssztl.common.purpleQulity2"),value:3},
				{label:LanguageManager.getWord("ssztl.common.orangeQulity2"),value:4}]);
			_comboxQuality.selectedIndex = 4;
		}
		
		private function initEvents():void
		{
			_refreshBtn.addEventListener(MouseEvent.CLICK,refreshHandler);
			_acceptBtn.addEventListener(MouseEvent.CLICK,acceptHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function removeEvents():void
		{
			_refreshBtn.removeEventListener(MouseEvent.CLICK,refreshHandler);
			_acceptBtn.removeEventListener(MouseEvent.CLICK,acceptHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function changeSceneHandler(e:SceneModuleEvent):void
		{
			dispose();
		}
		
		private function refreshHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.unRefreshTransport"));
			}
			else if(getDateLeftCount()==0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.noRefreshTransport"));
			}
			else if(GlobalData.selfPlayer.userMoney.allCopper < 2000)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.refreshTransportCopperNull"));
//				MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyCloseHandler);
			}
			else
			{
				_refreshBtn.enabled = false;
				TransportQualityRefreshHandler.send(_checkBox.selected,_comboxQuality.selectedIndex);
			}
		}
		
		private function buyCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoFill();
			}
		}
		
		private function acceptHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
//			if(GlobalData.selfPlayer.userMoney.copper < _curTransportTask.needCopper)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
//				return;
//			}
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.inTransport"));
			}
			else if(GlobalData.selfPlayer.level < _curTransportTask.minLevel)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.transportNeedLevel",_curTransportTask.minLevel));
			}
			else if(getTransportCount() >= _curTransportTask.repeatCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.transportMaxAceept"));
			}
			else if(GlobalData.taskInfo.taskStateChecker.checkCanAccept(_curTransportTask))
			{
				_alert = MAlert.show(LanguageManager.getWord("ssztl.common.autoChangeFightModel"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transportCloseHandler);
			}
//			TaskAcceptSocketHandler.sendAccept(_curTransportTask.taskId);	
		}
		
		private function transportCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				TaskAcceptSocketHandler.sendAccept(_curTransportTask.taskId);
			}
			dispatchEvent(new Event(Event.CLOSE));
			dispose();
		}
		
		
		private function showTransportAwrdHandler(evt:MouseEvent):void
		{
			_mediator.showTransportAwardPanel(_curTransportTask);
		}
		
		public function updateQuality(quality:int):void
		{
			if(quality < _curTransportTask.states.length-1)
			{
				_refreshBtn.enabled = true;
			}
			else
			{
				_refreshBtn.enabled = false;
			}
			_curTaskStateInfo = _curTransportTask.states[quality];
//			_copperAward.text = _curTaskStateInfo.awardCopper.toString();
//			_expAward.text = _curTaskStateInfo.awardExp.toString();
			_awardText.setValue(
				_curTaskStateInfo.awardExp.toString() + LanguageManager.getWord("ssztl.common.experience") + "\t" +
				_curTaskStateInfo.awardCopper.toString() + LanguageManager.getWord("ssztl.common.copper")
			);
//			_curQualityField.textColor = CategoryType.getQualityColor(quality);
//			_curQualityField.text = getQualityName(quality);
			for(var i:int; i<5; i++)
				_waresList[i].selected = false;
			_waresList[quality].selected = true;
		}
		
		private function getQualityName(quality:int):String
		{
			switch (quality)
			{
				case 0:
					return LanguageManager.getWord("ssztl.common.whiteQulity2");
				case 1:
					return LanguageManager.getWord("ssztl.common.greenQulity2");
				case 2:
					return LanguageManager.getWord("ssztl.common.blueQulity2");
				case 3:
					return LanguageManager.getWord("ssztl.common.purpleQulity2");
				case 4:
					return LanguageManager.getWord("ssztl.common.orangeQulity2");
			}
			return LanguageManager.getWord("ssztl.common.whiteQulity2");
		}
		
		private function getTransportCount():int
		{
			var list:Array = GlobalData.taskInfo.getAllTransportTask();
			var count:int = 0;
			for(var i:int = 0; i < list.length; i++)
			{
				count += (list[i].getTemplate().repeatCount - list[i].dayLeftCount);
			}
			return count;
		}
		
		//当天运镖剩余次数
		public function getDateLeftCount():int
		{
			var list:Array = GlobalData.taskInfo.getAllTransportTask();
			var count:int = 0;
			for(var i:int = 0; i < list.length; i++)
			{
				count += (list[i].getTemplate().repeatCount - list[i].dayLeftCount);
			}
			return (5-count);
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_alert)
			{
				_alert.dispose();
				_alert = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_refreshBtn)
			{
				_refreshBtn.dispose();
				_refreshBtn = null;
			}
			if(_acceptBtn)
			{
				_acceptBtn.dispose();
				_acceptBtn = null;
			}
			if(_checkBox)
			{
				_checkBox = null;
			}
			if(_comboxQuality)
			{
				_comboxQuality = null;
			}
			_curTransportTask = null;
			_curTaskStateInfo = null;
			_mediator = null;
			super.dispose();
		}
	}
}


