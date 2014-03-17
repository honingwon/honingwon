package sszt.scene.components.shenMoWar.personalWar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.shenMoWar.main.IShenMoMainInterface;
	import sszt.scene.components.shenMoWar.main.ShenMoHonorSmallItemView;
	import sszt.scene.data.personalWar.PerWarInfo;
	import sszt.scene.data.personalWar.PerWarMainInfo;
	import sszt.scene.data.personalWar.PerWarMainItemInfo;
	import sszt.scene.data.shenMoWar.ShenMoWarInfo;
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarSceneItemInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.events.ScenePerWarUpdateEvent;
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarEnterSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarSceneListUpdateSocketHandler;
	
	public class PerWarMainPanel extends Sprite implements IShenMoMainInterface
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _enterBtn:MCacheAsset1Btn;
		private var _getRewardsBtn:MCacheAsset1Btn;
		private var _itemViewList:Array;
		private var _mTile:MTile;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		
		private var _currentItemView:PerWarMainItemView = null;
		
		public function PerWarMainPanel(argMediator:SceneWarMediator)
		{
			_mediator = argMediator;
			super();
			_mediator.perWarInfo.initPerWarMainInfo();
			initialView();
			initialEvents();
			//请求列表数据
			_mediator.sendPerWarSceneList();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,323,47)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,50,323,278)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(327,0,205,328)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(4,54,316,22))
			]);
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			label1.mouseWheelEnabled = false;
			label1.defaultTextFormat = LABEL_FORMAT;
			label1.setTextFormat(LABEL_FORMAT);
			label1.move(6,7);
			label1.width = 320;
			label1.wordWrap = true;
			label1.multiline = true;
			addChild(label1);

			label1.htmlText = LanguageManager.getWord("ssztl.scene.personWarIntroduce");
			
			var label2:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			label2.mouseWheelEnabled = false;
			label2.defaultTextFormat = LABEL_FORMAT;
			label2.setTextFormat(LABEL_FORMAT);
			label2.move(338,7);
			label2.width = 184;
			label2.wordWrap = true;
			label2.multiline = true;
			addChild(label2);
			
			label2.htmlText = LanguageManager.getWord("ssztl.scene.huanGuWarScoreIntroduce");
			
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.war"),MAssetLabel.LABELTYPE14);
			label3.move(146,57);
			addChild(label3);
			
			_enterBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.enter"));
			_enterBtn.move(42,335);
			addChild(_enterBtn);
			
			
			
			_getRewardsBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.getAward"));
			_getRewardsBtn.move(184,335);
			addChild(_getRewardsBtn);
			
			//			_honerShopBtn = new MCacheAsset1Btn(2,"荣誉商店");
//			_honerShopBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.honorShop"));
//			_honerShopBtn.move(385,15);
//			addChild(_honerShopBtn);
			
			_itemViewList = [];
			_mTile = new MTile(311,30);
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.setSize(311,230);
			_mTile.move(6,83);
			addChild(_mTile);
			
			
			//			tmpItemView1 = new ShenMoHonorItemView(_mediator,0);
			//			tmpItemView1.move(6,79);
			//			tmpItemView2 = new ShenMoHonorItemView(_mediator,1);
			//			tmpItemView2.move(6,120);
			//			_mTile.appendItem(tmpItemView1);
			//			_mTile.appendItem(tmpItemView2);
			//			_itemViewList.push(tmpItemView1);
			//			_itemViewList.push(tmpItemView2);
		}
		
		private function initialEvents():void
		{
			_enterBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_getRewardsBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_mediator.perWarInfo.perWarMainInfo.addEventListener(ScenePerWarUpdateEvent.PERWAR_MAINLIST_UPDATE,updateListHandler);
		}
		
		private function removeEvents():void
		{
			_enterBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_getRewardsBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_mediator.perWarInfo.perWarMainInfo.removeEventListener(ScenePerWarUpdateEvent.PERWAR_MAINLIST_UPDATE,updateListHandler);
		}
		
		private function updateListHandler(e:ScenePerWarUpdateEvent):void
		{
			var tmpItemView:PerWarMainItemView;
			for each(var i:PerWarMainItemInfo in perWarMainInfo.warSceneItemInfoDiList)
			{
				var tmp:PerWarMainItemView  = getItemView(i.listId);
				if(tmp)continue;
				tmpItemView = new PerWarMainItemView(_mediator,i);
				tmpItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
				_itemViewList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
			//默认选中第一个
			if(_itemViewList.length > 0)
			{
				_currentItemView = _itemViewList[0];
				_currentItemView.selected = true;
				perWarInfo.warSceneId = _currentItemView.info.listId;
			}
		}
		
		private function getItemView(argWarSceneId:Number):PerWarMainItemView
		{
			for each(var i:PerWarMainItemView in _itemViewList)
			{
				if(i && (i.info.listId == argWarSceneId))
				{
					return i;
				}
			}
			return null;
		}
		
		private function itemViewClickHandler(e:MouseEvent):void
		{
			var argItemView:PerWarMainItemView = e.currentTarget as PerWarMainItemView
			if(_currentItemView == argItemView)return;
			if(_currentItemView)
			{
				_currentItemView.selected = false;
			}
			_currentItemView = argItemView;
			_currentItemView.selected = true;
			perWarInfo.warSceneId = _currentItemView.info.listId;
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _enterBtn:
					enterBtnHandler();
					break;
				case _getRewardsBtn:
					//					_mediator.module.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOREWARDS);
					_mediator.showPerWarRewardsPanel();
					break;
			}
		}
		
		private function enterBtnHandler():void
		{
			if(!_currentItemView)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.selectWarScene"));
				return;
			}
			if(MapTemplateList.isPerWarMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.inWarScene"));
				return;
			}
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.transportForbidAction"));
				return;
			}
			if(!_mediator.sceneInfo.playerList.self.getIsCommon())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.inWarState"));
				return;
			}
			if(GlobalData.copyEnterCountList.isInCopy || _mediator.sceneInfo.mapInfo.isShenmoDouScene() || _mediator.sceneInfo.mapInfo.isClubPointWarScene() || _mediator.sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				return;
			}
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.sceneUnoperatable"));
				return;
			}
			if(GlobalData.selfPlayer.level >= _currentItemView.info.minLevel &&
				GlobalData.selfPlayer.level <= _currentItemView.info.maxLevel)
			{
				GlobalData.selfPlayer.scenePath = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathCallback = null;
				if(_mediator && _mediator.module.sceneInit.playerListController.getSelf())_mediator.module.sceneInit.playerListController.getSelf().stopMoving();
				
				_mediator.sendPerWarEnter();
				_mediator.module.shenMoWarMainPanel.dispose();
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.levelNotMatch"));
				return;
			}
			
		}
		
		public function get perWarInfo():PerWarInfo
		{
			return _mediator.perWarInfo;
		}
		
		public function get perWarMainInfo():PerWarMainInfo
		{
			return perWarInfo.perWarMainInfo;
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator.perWarInfo.clearPerWarMainInfo();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_enterBtn)
			{
				_enterBtn.dispose();
				_enterBtn = null;
			}
			if(_getRewardsBtn)
			{
				_getRewardsBtn.dispose();
				_getRewardsBtn = null;
			}
			for each(var i:PerWarMainItemView   in _itemViewList)
			{
				if(i)
				{
					i.removeEventListener(MouseEvent.CLICK,itemViewClickHandler);
					i.dispose();
					i = null;
				}
			}
			_itemViewList = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile =  null;
			}
			_mediator = null;
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
	}
}