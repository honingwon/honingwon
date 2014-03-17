package sszt.scene.components.shenMoWar.main
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
	import sszt.scene.data.shenMoWar.ShenMoWarInfo;
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarSceneItemInfo;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarEnterSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarSceneListUpdateSocketHandler;

	public class ShenMoHonorPanel extends Sprite implements IShenMoMainInterface
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _enterBtn:MCacheAsset1Btn;
		private var _getRewardsBtn:MCacheAsset1Btn;
		private var _honerShopBtn:MCacheAsset1Btn;
		private var _killNumLabel:MAssetLabel;
		private var _killTotalNumLabel:MAssetLabel;
		private var _honorNumLabel:MAssetLabel;
		private var _honorTotalNumLabel:MAssetLabel;
		private var _itemViewList:Array;
		private var _mTile:MTile;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		
		private var _currentItemView:ShenMoHonorSmallItemView = null;
		
		public function ShenMoHonorPanel(argMediator:SceneWarMediator)
		{
			_mediator = argMediator;
			super();
			_mediator.shenMoWarInfo.initShenMoWarHonorInfo();
			initialView();
			initialEvents();
			//请求列表数据和荣誉数据
			_mediator.sendWarSceneList();
			_mediator.sendHonorInfo();
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
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.todayKillNum"),MAssetLabel.LABELTYPE14);
			label1.move(6,5);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.todayHonor"),MAssetLabel.LABELTYPE14);
			label2.move(6,25);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.totalKillNum"),MAssetLabel.LABELTYPE14);
			label3.move(185,5);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.totalHonor"),MAssetLabel.LABELTYPE14);
			label4.move(185,25);
			addChild(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.war"),MAssetLabel.LABELTYPE14);
			label5.move(146,57);
			addChild(label5);
			
			var label6:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			label6.mouseWheelEnabled = false;
			label6.defaultTextFormat = LABEL_FORMAT;
			label6.setTextFormat(LABEL_FORMAT);
			label6.move(338,58);
			label6.width = 184;
			label6.wordWrap = true;
			label6.multiline = true;
			addChild(label6);
			
			label6.htmlText = LanguageManager.getWord("ssztl.scene.shenMoWarIntroduce");
											
			_enterBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.enter"));
			_enterBtn.move(42,335);
			addChild(_enterBtn);
			

			
			_getRewardsBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.getAward"));
			_getRewardsBtn.move(184,335);
			addChild(_getRewardsBtn);
			
			_honerShopBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.honorShop"));
			_honerShopBtn.move(385,15);
			addChild(_honerShopBtn);
			
			_killNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_killNumLabel.move(104,5);
			addChild(_killNumLabel);
			
			_killTotalNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_killTotalNumLabel.move(255,5);
			addChild(_killTotalNumLabel);
			
			_honorNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_honorNumLabel.move(104,25);
			addChild(_honorNumLabel);
			
			_honorTotalNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_honorTotalNumLabel.move(255,25);
			addChild(_honorTotalNumLabel);
			
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
			_honerShopBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_mediator.shenMoWarInfo.shenMoWarHonorInfo.addEventListener(SceneShenMoWarUpdateEvent.SHENMO_HONOR_LIST_UPDATE,updateListHandler);
			_mediator.shenMoWarInfo.shenMoWarHonorInfo.addEventListener(SceneShenMoWarUpdateEvent.SHENMO_HONOR_INFO_UPDATE,udpateHonorInfo);
			
		}
		
		private function removeEvents():void
		{
			_enterBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_getRewardsBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_honerShopBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_mediator.shenMoWarInfo.shenMoWarHonorInfo.removeEventListener(SceneShenMoWarUpdateEvent.SHENMO_HONOR_LIST_UPDATE,updateListHandler);
			_mediator.shenMoWarInfo.shenMoWarHonorInfo.removeEventListener(SceneShenMoWarUpdateEvent.SHENMO_HONOR_INFO_UPDATE,udpateHonorInfo);
		}
		
		private function updateListHandler(e:SceneShenMoWarUpdateEvent):void
		{
			var tmpItemView:ShenMoHonorSmallItemView;
			for each(var i:ShenMoWarSceneItemInfo in shenMoWarInfo.shenMoWarHonorInfo.warSceneItemInfoDiList)
			{
				var tmp:ShenMoHonorSmallItemView  = getItemView(i.listId);
				if(tmp)continue;
				tmpItemView = new ShenMoHonorSmallItemView(_mediator,i);
				tmpItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
				_itemViewList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
			//默认选中第一个
			if(_itemViewList.length > 0)
			{
				_currentItemView = _itemViewList[0];
				_currentItemView.selected = true;
				shenMoWarInfo.warSceneId = _currentItemView.info.listId;
			}
		}
		
		private function getItemView(argWarSceneId:Number):ShenMoHonorSmallItemView
		{
			for each(var i:ShenMoHonorSmallItemView in _itemViewList)
			{
				if(i && (i.info.listId == argWarSceneId))
				{
					return i;
				}
			}
			return null;
		}
		
		private function udpateHonorInfo(e:SceneShenMoWarUpdateEvent):void
		{
			_killNumLabel.text = shenMoWarInfo.shenMoWarHonorInfo.todayKillNum.toString();
			_killTotalNumLabel.text = shenMoWarInfo.shenMoWarHonorInfo.totalkillNum.toString();
			_honorNumLabel.text = shenMoWarInfo.shenMoWarHonorInfo.todayHonorNum.toString();
			_honorTotalNumLabel.text = shenMoWarInfo.shenMoWarHonorInfo.totalHonorNum.toString();
		}
		
		private function itemViewClickHandler(e:MouseEvent):void
		{
			var argItemView:ShenMoHonorSmallItemView = e.currentTarget as ShenMoHonorSmallItemView
			if(_currentItemView == argItemView)return;
			if(_currentItemView)
			{
				_currentItemView.selected = false;
			}
			_currentItemView = argItemView;
			_currentItemView.selected = true;
			shenMoWarInfo.warSceneId = _currentItemView.info.listId;
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
					_mediator.showShenMoRewardsPanel();
					break;
				case _honerShopBtn:
					_mediator.showShenMoWarShopPanel();
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
			if(!_mediator.module.shenMoWarIcon)
			{
//				QuickTips.show("还没到开启时间。");
//				return;
			}
			if(_mediator.sceneInfo.mapInfo.isShenmoDouScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.inWarScene"));
				return;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.crossServerForbidAction"));
				return;
			}
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show("sszt.scene.sceneUnoperatable");
				return;
			}
			if(GlobalData.selfPlayer.level >= _currentItemView.info.minLevel &&
				GlobalData.selfPlayer.level <= _currentItemView.info.maxLevel)
			{
				_mediator.sendEnterWar();
				_mediator.module.shenMoWarMainPanel.dispose();
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.levelNotMatch"));
				return;
			}
					
		}
		
		public function get shenMoWarInfo():ShenMoWarInfo
		{
			return _mediator.module.shenMoWarInfo;
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
			_mediator.shenMoWarInfo.clearShenMoWarHonorInfo();
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
			 if(_honerShopBtn)
			 {
				 _honerShopBtn.dispose();
				 _honerShopBtn = null;
			 }
			 _killNumLabel = null;
			 _killTotalNumLabel = null;
			 _honorNumLabel = null;
			 _honorTotalNumLabel = null;
			 for each(var i:ShenMoHonorSmallItemView   in _itemViewList)
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