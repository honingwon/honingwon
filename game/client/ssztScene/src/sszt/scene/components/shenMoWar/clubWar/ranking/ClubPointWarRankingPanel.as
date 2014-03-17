package sszt.scene.components.shenMoWar.clubWar.ranking
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarClubItemInfo;
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarMainItemInfo;
	import sszt.scene.events.SceneClubPointWarUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.clubPointWar.ClubPointWarMainSocketHandler;
	
	public class ClubPointWarRankingPanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneMediator;
		private var _mTile:MTile;
		private var _itemList:Array;
		private var _smallBtn:MBitmapButton;
		private var _showBtn:MBitmapButton;
		private var _container:Sprite;
		private var _container2:Sprite;
		private var _myClubRankingLabel:MAssetLabel;
		private var _myClubLabel:MAssetLabel;
		private var _myClubKillCountLabel:MAssetLabel;
		private static const PAGE_COUNT:int = 10;
		
		public function ClubPointWarRankingPanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			//初始化数据层
			_mediator.clubPointWarInfo.initialMainInfo();
			initialView();
			initialEvents();
			//向服务器请求数据
			ClubPointWarMainSocketHandler.send();
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
			label1.move(20,1);
			_container.addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName"),MAssetLabel.LABELTYPE14);
			label2.mouseEnabled = label2.mouseWheelEnabled = false;
			label2.move(75,1);
			_container.addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.clubScore"),MAssetLabel.LABELTYPE14);
			label3.mouseEnabled = label3.mouseWheelEnabled = false;
			label3.move(165,1);
			_container.addChild(label3);
			
			_myClubRankingLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16);
			_myClubRankingLabel.mouseEnabled = _myClubRankingLabel.mouseWheelEnabled = false;
			_myClubRankingLabel.move(23,235);
			_container.addChild(_myClubRankingLabel);
			
			_myClubLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16);
			_myClubLabel.mouseEnabled = _myClubLabel.mouseWheelEnabled = false;
			_myClubLabel.move(105,235);
			_container.addChild(_myClubLabel);
			
			_myClubKillCountLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16);
			_myClubKillCountLabel.mouseEnabled = _myClubKillCountLabel.mouseWheelEnabled = false;
			_myClubKillCountLabel.move(195,235);
			_container.addChild(_myClubKillCountLabel);
			
//			_smallBtn = new MBitmapButton(new ZoomBtnAsset());
			_smallBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.ZoomBtnAsset") as BitmapData);
			_smallBtn.move(0,0);
			_smallBtn.height = 100;
			_container.addChild(_smallBtn);
			
//			_showBtn = new MBitmapButton(new ZoomBtnAsset());
			_showBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.ZoomBtnAsset") as BitmapData);
			_showBtn.move(11,0);
			_showBtn.height = 100;
			_showBtn.scaleX = -1;
			_container2.addChild(_showBtn);
			
			_itemList = [];
			_mTile = new MTile(216,19);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = _mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.setSize(217,193);
			_mTile.move(11,19);
			_container.addChild(_mTile);
			
			for(var i:int = 0;i<PAGE_COUNT;i++)
			{
				var tmpItemView:ClubPointWarRankingItemView = new ClubPointWarRankingItemView(_mediator);
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
			
			gameSizeChangeHandler(null);
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_mediator.clubPointWarInfo.clubPointWarMainInfo.addEventListener(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_UPDATE,getData);
			_smallBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_showBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_mediator.clubPointWarInfo.clubPointWarMainInfo.removeEventListener(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_UPDATE,getData);
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
		
		private function getData(e:SceneClubPointWarUpdateEvent):void
		{
			clearList();
			var tmpList:Array = _mediator.clubPointWarInfo.clubPointWarMainInfo.itemInfoList;
			for(var i:int = 0;i < tmpList.length;i++)
			{
				if(_itemList[i])_itemList[i].info = tmpList[i];
			}
			//更新自己帮会信息
			var tmpMyInfo:ClubPointWarClubItemInfo = _mediator.clubPointWarInfo.clubPointWarMainInfo.getItem(GlobalData.selfPlayer.clubName);
			if(!tmpMyInfo)return;
			_myClubRankingLabel.text = tmpMyInfo.rankNum.toString();
			_myClubLabel.text = tmpMyInfo.clubName;
			_myClubKillCountLabel.text = tmpMyInfo.clubScore.toString();
		}
		
		private function clearList():void
		{
			for each(var i:ClubPointWarRankingItemView in _itemList)
			{
				i.info = null;
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator.clubPointWarInfo.clearMainIno();
			if(_smallBtn)
			{
				_smallBtn.dispose();
				_smallBtn = null;
			}
			if(_showBtn)
			{
				_showBtn.dispose();
				_showBtn = null;	
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for each(var i:ClubPointWarRankingItemView in _itemList)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_itemList = null;
			_container = null;
			_container2 = null;
			_myClubRankingLabel = null;
			_myClubLabel = null;
			_myClubKillCountLabel = null;
			if(parent)parent.removeChild(this);
		}
	}
}