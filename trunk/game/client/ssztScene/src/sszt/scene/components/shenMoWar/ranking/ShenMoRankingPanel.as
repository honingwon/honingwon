package sszt.scene.components.shenMoWar.ranking
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMembersItemInfo;
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMemberListUpdateSocketHandler;
	
	
	public class ShenMoRankingPanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneMediator;
		private var _pageView:PageView;
		private var _mTile:MTile;
		private var _itemList:Array;
		private static const PAGE_COUNT:int = 10;
		private var _myRankingLabel:MAssetLabel;
		private var _myNickLabel:MAssetLabel;
		private var _myKillCountLabel:MAssetLabel;
		private var _smallBtn:MBitmapButton;
		private var _showBtn:MBitmapButton;
		private var _container:Sprite;
		private var _container2:Sprite;
		
		public function ShenMoRankingPanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			//初始化数据层
			_mediator.shenMoWarInfo.initShenMoWarMenbersInfo();
			initialEvents();
			//向服务器请求数据
			ShenMoWarMemberListUpdateSocketHandler.send(_mediator.shenMoWarInfo.warSceneId);
		}
		
		private function initialView():void
		{
			_container = new Sprite();
			addChild(_container);
			_container2 = new Sprite();
			addChild(_container2);
			_container.mouseEnabled = _container2.mouseEnabled = false;
			_container2.visible = false;
			
			_bg = BackgroundUtils.setBackground([
																				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(11,19,216,236)),
																				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(11,0,216,19)),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(40,1,11,17),new MCacheSplit3Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(147,1,11,17),new MCacheSplit3Line()),
																				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,211,214,1),new MCacheSplit1Line())
																		     ]);
			
			_container.addChild(_bg as DisplayObject);
			
			mouseEnabled = false;
			
			
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.rank"),MAssetLabel.LABELTYPE14);
			label1.mouseEnabled = label1.mouseWheelEnabled = false;
			label1.move(15,1);
			_container.addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.name2"),MAssetLabel.LABELTYPE14);
			label2.mouseEnabled = label2.mouseWheelEnabled = false;
			label2.move(86,1);
			_container.addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.killCount"),MAssetLabel.LABELTYPE14);
			label3.mouseEnabled = label3.mouseWheelEnabled = false;
			label3.move(171,1);
			_container.addChild(label3);
			
			_myRankingLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16);
			_myRankingLabel.mouseEnabled = _myRankingLabel.mouseWheelEnabled = false;
			_myRankingLabel.move(20,235);
			_container.addChild(_myRankingLabel);
			
			_myNickLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16);
			_myNickLabel.mouseEnabled = _myNickLabel.mouseWheelEnabled = false;
			_myNickLabel.move(100,235);
			_container.addChild(_myNickLabel);
			
			_myKillCountLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16);
			_myKillCountLabel.mouseEnabled = _myKillCountLabel.mouseWheelEnabled = false;
			_myKillCountLabel.move(200,235);
			_container.addChild(_myKillCountLabel);
			
//			_smallBtn = new MBitmapButton(new ZoomBtnAsset());
			_smallBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.ZoomBtnAsset") as BitmapData);
			_smallBtn.move(0,0);
			_container.addChild(_smallBtn);
			
//			_showBtn = new MBitmapButton(new ZoomBtnAsset());
			_showBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.ZoomBtnAsset") as BitmapData);
			_showBtn.move(11,0);
			_showBtn.scaleX = -1;
			_container2.addChild(_showBtn);
			
			_pageView = new PageView(PAGE_COUNT);
			_pageView.move(81,215);
			_container.addChild(_pageView);
			
			_itemList = [];
			_mTile = new MTile(216,19);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = _mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.setSize(217,193);
			_mTile.move(11,19);
			_container.addChild(_mTile);
			
			for(var i:int = 0;i<PAGE_COUNT;i++)
			{
				var tmpItemView:ShenMoRankingItemView = new ShenMoRankingItemView(_mediator);
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
			
			gameSizeChangeHandler(null);
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_mediator.shenMoWarInfo.shenMoWarMembersInfo.addEventListener(SceneShenMoWarUpdateEvent.SHENMO_MENBERS_LIST_UPDATE,getData);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_smallBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_showBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_mediator.shenMoWarInfo.shenMoWarMembersInfo.removeEventListener(SceneShenMoWarUpdateEvent.SHENMO_MENBERS_LIST_UPDATE,getData);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			_smallBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_showBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _smallBtn:
					hide();
					break;
				case _showBtn:
					show();
					break;
			}
		}
		
		public function show():void
		{
			_container.visible = true;
			_container2.visible = false;
		}
		
		public function hide():void
		{
			_container.visible = false;
			_container2.visible = true;
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = 0;
			y = 100;
		}
		
		private function pageChangeHandler(evt:PageEvent):void
		{
			getData(null);
		}
		
		private function getData(e:SceneShenMoWarUpdateEvent):void
		{
			clearList();
			var tmpList:Array = _mediator.shenMoWarInfo.shenMoWarMembersInfo.getMemberListByPage(_pageView.currentPage,PAGE_COUNT);
			for(var i:int = 0;i < tmpList.length;i++)
			{
				if(_itemList[i])_itemList[i].info = tmpList[i];
			}
			_pageView.totalRecord = _mediator.shenMoWarInfo.shenMoWarMembersInfo.membersItemList.length;
			//更新自己信息
			var tmpMyInfo:ShenMoWarMembersItemInfo = _mediator.shenMoWarInfo.shenMoWarMembersInfo.getMemberItemInfo(GlobalData.selfPlayer.userId);
			if(!tmpMyInfo)return;
			_myRankingLabel.text = tmpMyInfo.rankingNum.toString();
			_myNickLabel.text = "[" + tmpMyInfo.serverId + "]" + tmpMyInfo.playerNick;
			_myKillCountLabel.text = tmpMyInfo.attackPepNum.toString();
		}
		
		private function clearList():void
		{
			for each(var i:ShenMoRankingItemView in _itemList)
			{
				i.info = null;
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			if(!_mediator.sceneModule.shenMoRewardsPanel)
			{
				_mediator.shenMoWarInfo.clearShenMoWarMenbersInfo();
			}
			if(_smallBtn)
			{
				_smallBtn = null;
			}
			if(_showBtn)
			{
				_showBtn = null;	
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for each(var i:ShenMoRankingItemView in _itemList)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_itemList = null;
			_myRankingLabel = null;
			_myNickLabel = null;
			_myKillCountLabel = null;
			_container = null;
			_container2 = null;
			if(parent)parent.removeChild(this);
		}
	}
}