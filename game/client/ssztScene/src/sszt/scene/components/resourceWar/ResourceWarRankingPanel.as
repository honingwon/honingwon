package sszt.scene.components.resourceWar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pvp.ActiveResourceWarLeaveSocketHandler;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.resourceWar.ResourceWarInfo;
	import sszt.scene.data.resourceWar.ResourceWarInfoUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.resourceWar.ResourceWarPointAddSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	
	import ssztui.scene.DotaTitleAsset;
	import ssztui.ui.SplitCompartLine2;

	public class ResourceWarRankingPanel extends MSprite
	{
		private const WIDTH:int = 292;
		private const HEIGHT:int = 386;
		private const Y:int = 190;
		
		private var _bg:IMovieWrapper;
		
		private var _mediator:SceneMediator;
		
		private var _container:MSprite;
		
		private var _btnViewRules:MCacheAssetBtn1;
		private var _btnLeave:MCacheAssetBtn1;
		private var _btnAlterCamp:MCacheAssetBtn1;
		
		private var _myPointLabel:MAssetLabel;
		private var _myKillingPointlLabel:MAssetLabel;
		private var _myCollectingPointlLabel:MAssetLabel;
		private var _myComboLabel:MAssetLabel;
		
		private var _tabs:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		
		private var _campLogoPath:String
		private var _campLogo:Bitmap;
		
		private var _dragArea:Sprite;
		
		private var _tipList:Array;
		
		public function ResourceWarRankingPanel(argMediator:SceneMediator)
		{
			_mediator = argMediator;
			super();
			initEvent();
			ResourceWarPointAddSocketHandler.send();
		}
		
		override protected function configUI():void
		{
			super.configUI();	
			mouseEnabled = false;		
			gameSizeChangeHandler(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.REELWIN,new Rectangle(0,0,WIDTH,HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(26,32,240,58)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(26,118,240,200)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(26,89,240,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(26,317,240,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(110,6,72,18),new Bitmap(new DotaTitleAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,WIDTH,30);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_campLogo = new Bitmap();
			_campLogo.x = 28;
			_campLogo.y = 34;
			addChild(_campLogo);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(93,44,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.myScore"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(93,62,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.killScore"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(151,62,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.collectionScore"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(208,62,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.resourceWar.combo"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));

			var _labels:Array = [
				LanguageManager.getWord("ssztl.resourceWar.personalRank"),
				LanguageManager.getWord("ssztl.resourceWar.campRank"),
			];
			_classes = [ResourceWarUserRankView, ResourceWarCampRankView];
			_panels = new Array(_labels.length);
			_tabs = new Array(_labels.length);
			
			for(var i:int = 0;i<_labels.length;i++)
			{
				_tabs[i] = new MCacheTabBtn1(0, 2, _labels[i]);
				_tabs[i].move(30+i*69,93);
				addChild(_tabs[i]);
			}
			
			_container = new MSprite();
			addChild(_container);
			_container.mouseEnabled = false;
			
			_btnViewRules = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.resourceWar.viewRule'));
			_btnViewRules.move(73,326);
			_container.addChild(_btnViewRules);
			
			_btnLeave = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.group.leaveTeamWord'));
			_btnLeave.move(150,326);
			_container.addChild(_btnLeave);
			
			_btnAlterCamp = new MCacheAssetBtn1(0, 3,LanguageManager.getWord('ssztl.resourceWar.changeCamp'));
			_btnAlterCamp.move(191,92);
			_container.addChild(_btnAlterCamp);
			
			_myPointLabel = new MAssetLabel('0', MAssetLabel.LABEL_TYPE20,'left');
			_myPointLabel.move(148, 44);
			_container.addChild(_myPointLabel);
			
			_myKillingPointlLabel =new MAssetLabel('0',MAssetLabel.LABEL_TYPE20,'left');
			_myKillingPointlLabel.move(129,62);
			addChild(_myKillingPointlLabel);
			
			_myCollectingPointlLabel =new MAssetLabel('0',MAssetLabel.LABEL_TYPE20,'left');
			_myCollectingPointlLabel.move(187,62);
			addChild(_myCollectingPointlLabel);
			
			_myComboLabel =new MAssetLabel('0',MAssetLabel.LABEL_TYPE20,'left');
			_myComboLabel.move(243,62);
			addChild(_myComboLabel);
			
			var skillTip:Sprite = new Sprite();
			skillTip.graphics.beginFill(0,0);
			skillTip.graphics.drawRect(92,60,77,20);
			skillTip.graphics.endFill();
			addChild(skillTip);
			
			var colleTip:Sprite = new Sprite();
			colleTip.graphics.beginFill(0,0);
			colleTip.graphics.drawRect(171,60,77,20);
			colleTip.graphics.endFill();
			addChild(colleTip);
			
			_tipList = [skillTip,colleTip];
			
			myCampTypeUpdateHandler(null);
			setIndex(0);
		}
		
		private function initEvent():void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			
			for(var i:int = 0;i<_tabs.length;i++)
			{
				_tabs[i].addEventListener(MouseEvent.CLICK,tabsClickHandler);
			}
			for(i=0; i<_tipList.length; i++)
			{
				_tipList[i].addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
				_tipList[i].addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
			_btnLeave.addEventListener(MouseEvent.CLICK,leaveHandler);
			_btnAlterCamp.addEventListener(MouseEvent.CLICK,campAlterHandler);
			_btnViewRules.addEventListener(MouseEvent.CLICK,showRewardHandler);
			
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.CAMP_TYPE_UPDATE, myCampTypeUpdateHandler);
			resourceWarInfo.addEventListener(ResourceWarInfoUpdateEvent.MY_POINT_UPDATE,myPointUpdateHandler);
			resourceWarInfo.addEventListener(ResourceWarInfoUpdateEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
			resourceWarInfo.addEventListener(ResourceWarInfoUpdateEvent.RESULT_UPDATE,resultUpdateHandler);
				
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			
			for(var i:int = 0;i<_tabs.length;i++)
			{
				_tabs[i].removeEventListener(MouseEvent.CLICK,tabsClickHandler);
			}
			for(i=0; i<_tipList.length; i++)
			{
				_tipList[i].removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
				_tipList[i].removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			}
			_btnLeave.removeEventListener(MouseEvent.CLICK,leaveHandler);
			_btnAlterCamp.removeEventListener(MouseEvent.CLICK,campAlterHandler);
			_btnViewRules.removeEventListener(MouseEvent.CLICK,showRewardHandler);
			
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.CAMP_TYPE_UPDATE, myCampTypeUpdateHandler);
			resourceWarInfo.removeEventListener(ResourceWarInfoUpdateEvent.MY_POINT_UPDATE,myPointUpdateHandler);
			resourceWarInfo.removeEventListener(ResourceWarInfoUpdateEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
			resourceWarInfo.removeEventListener(ResourceWarInfoUpdateEvent.RESULT_UPDATE,resultUpdateHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function resultUpdateHandler(event:Event):void
		{
			var myRewards:Array =resourceWarInfo.myRewards;
			var winningCampType:int = resourceWarInfo.winningCampType;
			var campRankList:Array = resourceWarInfo.campRankList;
			var exploit:int = resourceWarInfo.exploit;
			ResultShowPanel.getInstance().show(winningCampType, campRankList, myRewards,exploit);
		}
		private function tipOverHandler(e:MouseEvent):void
		{
			var index:int = _tipList.indexOf(e.currentTarget);
			
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.resourceWar.getScoreTip"+(index+1)),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function tipOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function tabsClickHandler(e:MouseEvent):void
		{
			var _index:int = _tabs.indexOf(e.currentTarget);
			setIndex(_index);
		}
		
		private function setIndex(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_tabs[_currentIndex].selected = false;
			}
			_currentIndex = argIndex;
			_tabs[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(28,120);
			}
			addChild(_panels[_currentIndex]);
			_panels[_currentIndex].show();
		}
		
		
		private function myPointUpdateHandler(event:Event):void
		{
			_myPointLabel.setValue(resourceWarInfo.myPoint.toString());
			_myKillingPointlLabel.setValue(resourceWarInfo.myKillPoint.toString());
			_myCollectingPointlLabel.setValue(resourceWarInfo.myCollectPoint.toString());
			_myComboLabel.setValue(resourceWarInfo.myCombo.toString());
		}
		
		private function myCampTypeUpdateHandler(event:Event):void
		{
			_campLogoPath = GlobalAPI.pathManager.getBannerPath("dotaCamp" + GlobalData.selfPlayer.camp + ".jpg");
			GlobalAPI.loaderAPI.getPicFile(_campLogoPath, loadCampLogoComplete,SourceClearType.NEVER);
			
//			_campLabel.setValue(CampType.getCampName(GlobalData.selfPlayer.camp));
		}
		private function loadCampLogoComplete(data:BitmapData):void
		{
			_campLogo.bitmapData = data;
		}
		
		private function rankInfoUpdateHandler(event:Event):void
		{
//			_userRankView.updateView(resourceWarInfo.rankList);
//			_campRankView.updateView(resourceWarInfo.campRankList);
		}
		
		private function campAlterHandler(event:MouseEvent):void
		{
			AlterCampPanel.getInstance().show(GlobalData.selfPlayer.camp);
		}
		private function showRewardHandler(event:MouseEvent):void
		{
//			RewardShowPanel.getInstance().show();
			_mediator.sendNotification(SceneMediatorEvent.SHOW_RESOURCE_WAR_ENTRANCE_PANEL);
		}
		
		private function leaveHandler(event:MouseEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.scene.resouceWarLeaveAlert") ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveConfirmHandler);
		}
		
		private function leaveConfirmHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				ActiveResourceWarLeaveSocketHandler.send();
			}
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - WIDTH;
			y = Y;
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - WIDTH,parent.stage.stageHeight - HEIGHT));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		public function get resourceWarInfo():ResourceWarInfo
		{
			return _mediator.sceneModule.resourceWarInfo;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_container)
			{
				_container.dispose();
				_container = null;
			}
			for(var i:int = 0;i<_tabs.length;i++)
			{
				_tabs[i].dispose();
				_tabs[i] = null;
			}
			_tabs[i] = null;
			_classes = null;
			for(var j:int = 0;j<_panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			if(_btnLeave)
			{
				_btnLeave.dispose();
				_btnLeave = null;
			}
			if(_btnAlterCamp)
			{
				_btnAlterCamp.dispose();
				_btnAlterCamp = null;
			}
			if(_btnViewRules)
			{
				_btnViewRules.dispose();
				_btnViewRules = null;
			}
			_myPointLabel= null;
			_myKillingPointlLabel= null;
			_myCollectingPointlLabel= null;
			GlobalAPI.loaderAPI.removeAQuote(_campLogoPath,loadCampLogoComplete);
			_campLogoPath = null;
			if(_campLogo)
			{
				_campLogo = null;
			}
			_tipList = null;
			_dragArea = null;
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
		}
	}
}