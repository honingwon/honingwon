package sszt.scene.components.copyIsland.beforeEnter
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.copyIsland.beforeEnter.CIBeforeInfo;
	import sszt.scene.data.copyIsland.beforeEnter.CIBeforeItemInfo;
	import sszt.scene.events.SceneCopyIslandUpdateEvent;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandCleanSocketHandler;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandEneterSokcetHandler;
	import sszt.scene.socketHandlers.smIsland.beforeEnter.CopyIslandTeamerEnterSocketHandler;
	
	public class CopyIslandEnterPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:CopyGroupMediator;
		private var _copyItem:CopyTemplateItem;
		private var _enterBtn:MCacheAsset1Btn;
		private var _agreeBtn:MCacheAsset1Btn;
		private var _rejectBtn:MCacheAsset1Btn;
		private var _mTile:MTile;
		private var _itemList:Array;
		private var _timer:Timer;
		private var _coutDownLabel:MAssetLabel;
		public function CopyIslandEnterPanel(argMediator:CopyGroupMediator,argItem:CopyTemplateItem)
		{
			_mediator = argMediator;
			_copyItem = argItem;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.scene.vote")),true,0);
			_mediator.copyIslandInfo.initCIBeforeInfo();
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(206,253);
			_bg = BackgroundUtils.setBackground([
						new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,206,253)),
						new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,5,197,243)),
			]);
			addContent(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.isEnterShenMoIsland"),MAssetLabel.LABELTYPE1);
			label1.move(20,16);
			addContent(label1);
			
			_coutDownLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.voteTimeLeft"),MAssetLabel.LABELTYPE1);
			_coutDownLabel.move(43,215);
			addContent(_coutDownLabel);
			
			_enterBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.scene.enter"));
			_enterBtn.move(29,184);
			addContent(_enterBtn);
			_enterBtn.visible = false;
			_enterBtn.enabled = false;
			
			_agreeBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.consign.agree"));
			_agreeBtn.move(29,184);
			addContent(_agreeBtn);
			
			_rejectBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.refuse"));
			_rejectBtn.move(118,184);
			addContent(_rejectBtn);
			
			_itemList = [];
			_mTile = new MTile(150,25);
			_mTile.horizontalScrollPolicy = _mTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_mTile.setSize(150,75);
			_mTile.move(20,39);
			addContent(_mTile);
			updateBtn();
			
			_timer = new Timer(1000,15);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			_timer.start();
		}
		
		
		private function updateBtn():void
		{
			if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
			{
				_enterBtn.visible = true;
				_agreeBtn.visible = false;
				_rejectBtn.enabled = false;
			}
		}
		
		private function initEvents():void
		{
			cIBeforeInfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_INIT,initHandler);
			cIBeforeInfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_ITEMUPDATE,updateHandler);
			cIBeforeInfo.addEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_CANENTER,canEnterHandler);
			_enterBtn.addEventListener(MouseEvent.CLICK,btnHandler);
			_agreeBtn.addEventListener(MouseEvent.CLICK,btnHandler);
			_rejectBtn.addEventListener(MouseEvent.CLICK,btnHandler);
		}
		
		private function removeEvents():void
		{
			cIBeforeInfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_INIT,initHandler);
			cIBeforeInfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_ITEMUPDATE,updateHandler);
			cIBeforeInfo.removeEventListener(SceneCopyIslandUpdateEvent.COPY_ISLAND_BEFORE_CANENTER,canEnterHandler);
			_enterBtn.removeEventListener(MouseEvent.CLICK,btnHandler);
			_agreeBtn.removeEventListener(MouseEvent.CLICK,btnHandler);
			_rejectBtn.removeEventListener(MouseEvent.CLICK,btnHandler);
		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			var n:int = 15 - _timer.currentCount;
			if(n < 0)n = 0;
			_coutDownLabel.setValue(LanguageManager.getWord("ssztl.scene.voteTimeLeftValue",n));
		}
		private function timerCompleteHandler(evt:TimerEvent):void
		{
			CopyIslandCleanSocketHandler.send();
			dispose();
		}
		
		private function initHandler(e:SceneCopyIslandUpdateEvent):void
		{
			for each(var i:CIBeforeItemInfo in cIBeforeInfo.resultList)
			{
				var tmpItemView:CIBeforeEnterItemView = new CIBeforeEnterItemView();
				tmpItemView.info = i;
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
		}
		
		private function canEnterHandler(e:SceneCopyIslandUpdateEvent):void
		{
			if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
			{
				_enterBtn.enabled = true;
			}
		}
		
		private function updateHandler(e:SceneCopyIslandUpdateEvent):void
		{
			var tmpName:String = e.data as String;
			var tmpItemView:CIBeforeEnterItemView = getItemView(tmpName);
			if(!tmpItemView)return;
			tmpItemView.info = cIBeforeInfo.getResult(tmpName);
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _enterBtn:
					enterBtnHandler();
					break;
				case _agreeBtn:
					CopyIslandTeamerEnterSocketHandler.send(1,_copyItem.id);
					_agreeBtn.enabled = false;
					_rejectBtn.enabled = false;
					break
				case _rejectBtn:
					CopyIslandTeamerEnterSocketHandler.send(2,_copyItem.id);
					_rejectBtn.enabled = false;
					_agreeBtn.enabled = false;
					break;
			}
		}
		
		private function enterBtnHandler():void
		{
			GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.loadingMap"));
			GlobalData.selfPlayer.scenePath = null;
			GlobalData.selfPlayer.scenePathTarget = null;
			GlobalData.selfPlayer.scenePathCallback = null;
			_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
			CopyIslandEneterSokcetHandler.send(_copyItem.id);
			_enterBtn.enabled = false;
			dispose();
		}
		
		public function getItemView(argName:String):CIBeforeEnterItemView
		{
			for each(var i:CIBeforeEnterItemView in _itemList)
			{
				if(i.info.name == argName)
				{
					return i;
				}
			}
			return null;
		}
		
		public function get cIBeforeInfo():CIBeforeInfo
		{
			return _mediator.copyIslandInfo.cIBeforeInfo;
		}
		
		override public function dispose():void
		{
			removeEvents();
			_mediator.copyIslandInfo.clearCIBeforeInfo();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			_copyItem = null;
			if(_enterBtn)
			{
				_enterBtn.dispose();
				_enterBtn = null;
			}
			if(_agreeBtn)
			{
				_agreeBtn.dispose();
				_agreeBtn = null;
			}
			if(_rejectBtn)
			{
				_rejectBtn.dispose();
				_rejectBtn = null;
			}
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for each(var i:CIBeforeEnterItemView in _itemList)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_itemList = null;
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
				_timer.stop();
				_timer = null;
			}
			_coutDownLabel = null;
			super.dispose();
		}
	}
}