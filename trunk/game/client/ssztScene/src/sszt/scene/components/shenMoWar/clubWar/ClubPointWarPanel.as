package sszt.scene.components.shenMoWar.clubWar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.shenMoWar.clubWar.mainInfo.ClubPointWarMainItemView;
	import sszt.scene.components.shenMoWar.clubWar.ranking.ClubPointWarRankingItemView;
	import sszt.scene.components.shenMoWar.main.IShenMoMainInterface;
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarMainInfo;
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarMainItemInfo;
	import sszt.scene.events.SceneClubPointWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	
	public class ClubPointWarPanel extends Sprite implements IShenMoMainInterface
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		
		private var _enterWarBtn:MCacheAsset1Btn;
		private var _getRewardsBtn:MCacheAsset1Btn;
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,4);
		private var _itemList:Array;
		private static const PAGE_COUNT:int = 10;
		private var _mTile:MTile;
		
		private var _perKillNumLabel:MAssetLabel;
		private var _perScoreNumLabel:MAssetLabel;
		private var _contributeNumLabel:MAssetLabel;
		private var _todayHonorNumLabel:MAssetLabel;
		private var _allHonorNumLabel:MAssetLabel;
		
		private var _warScoreShopBtn:MCacheAsset1Btn;
		private var _doubleSitalert:MAlert;
		
		public function ClubPointWarPanel(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			_mediator.clubPointWarInfo.initialMainInfo();
			initialView();
			initialEvents();
			_mediator.sendPointWarMainInfo();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground(
				[
					new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,323,65)),
					new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,68,323,260)),
					new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(327,0,205,328)),
					new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(4,71,316,22))
				]);
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.personalKillNum"),MAssetLabel.LABELTYPE14);
			label1.move(6,5);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.personalContributeValue"),MAssetLabel.LABELTYPE14);
			label2.move(6,25);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.personalScore"),MAssetLabel.LABELTYPE14);
			label3.move(185,5);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.todayHonorValue"),MAssetLabel.LABELTYPE14);
			label4.move(185,25);
			addChild(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.totalHonorValue"),MAssetLabel.LABELTYPE14);
			label5.move(6,45);
			addChild(label5);
			
			_itemList = [];
			_mTile = new MTile(320,20);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = _mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.setSize(320,230);
			_mTile.move(6,100);
			addChild(_mTile);
			
			for(var i:int = 0;i<PAGE_COUNT;i++)
			{
				var tmpItemView:ClubPointWarMainItemView = new ClubPointWarMainItemView();
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
			var label6:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.clubWarLabel6"),MAssetLabel.LABELTYPE14);
			label6.move(10,73);
			addChild(label6);
			
			var label7:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			label7.mouseWheelEnabled = label7.mouseEnabled = false;
			label7.defaultTextFormat = LABEL_FORMAT;
			label7.setTextFormat(LABEL_FORMAT);
			label7.move(338,54);
			label7.width = 184;
			label7.wordWrap = true;
			label7.multiline = true;
			addChild(label7);
			
			label7.htmlText = LanguageManager.getWord("ssztl.scene.clubWarLabel7");
			
			_perKillNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_perKillNumLabel.move(104,5);
			addChild(_perKillNumLabel);
			
			_perScoreNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_perScoreNumLabel.move(265,5);
			addChild(_perScoreNumLabel);
			
			_contributeNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_contributeNumLabel.move(104,25);
			addChild(_contributeNumLabel);
			
			_todayHonorNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_todayHonorNumLabel.move(265,25);
			addChild(_todayHonorNumLabel);
			
			_allHonorNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_allHonorNumLabel.move(104,45);
			addChild(_allHonorNumLabel);
			
			_warScoreShopBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.honorShop"));
			_warScoreShopBtn.move(385,15);
			addChild(_warScoreShopBtn);
			
			
			_enterWarBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.enterWar"));
			_enterWarBtn.move(41,335);
			addChild(_enterWarBtn);
			
			_getRewardsBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.common.getAward"));
			_getRewardsBtn.move(184,335);
			addChild(_getRewardsBtn);
		}
		
		private function initialEvents():void
		{
			_enterWarBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_getRewardsBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			clubPointWarMainInfo.addEventListener(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_UPDATE,mainListUpdate);
			clubPointWarMainInfo.addEventListener(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_PERSONALINFO_UPDATE,updatePersonalInfo);
			_warScoreShopBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvents():void
		{
			_enterWarBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_getRewardsBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			clubPointWarMainInfo.removeEventListener(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_UPDATE,mainListUpdate);
			clubPointWarMainInfo.removeEventListener(SceneClubPointWarUpdateEvent.CLUB_MAIN_INFO_PERSONALINFO_UPDATE,updatePersonalInfo);
			_warScoreShopBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function mainListUpdate(e:SceneClubPointWarUpdateEvent):void
		{
			clearList();
			for(var i:int = 0;i < clubPointWarMainInfo.itemInfoList.length;i++)
			{
				_itemList[i].info = clubPointWarMainInfo.itemInfoList[i];
			}
		}
		
		private function updatePersonalInfo(e:SceneClubPointWarUpdateEvent):void
		{
			_perKillNumLabel.text = clubPointWarMainInfo.personalKillNum.toString();
			_perScoreNumLabel.text = clubPointWarMainInfo.personalScore.toString();
			_contributeNumLabel.text = clubPointWarMainInfo.personalContribute.toString();
			_todayHonorNumLabel.text = clubPointWarMainInfo.todayHonorNum.toString();
			_allHonorNumLabel.text = clubPointWarMainInfo.allHonorNum.toString();
		}
		
		private function clearList():void
		{
			for each(var i:ClubPointWarMainItemView in _itemList)
			{
				i.info = null;
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _enterWarBtn:
					enterBtnHandler();
				break
				case _getRewardsBtn:
					_mediator.showClubPointWarScorePanel();
				break;
				case _warScoreShopBtn:
					_mediator.showShenMoWarShopPanel();
				break;
			}
		}
		
		private function enterBtnHandler():void
		{
			if(_mediator.sceneInfo.mapInfo.isClubPointWarScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.inClubWarScene"));
				return;
			}
			if(GlobalData.selfPlayer.level >= 40)
			{
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
				if(MapTemplateList.isAcrossBossMap())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.crossServerForbidAction"));
					return;
				}
				if(MapTemplateList.getIsPrison())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.sceneUnoperatable"));
					return;
				}
				if(_mediator.sceneInfo.playerList.isDoubleSit())
				{
					if(!_doubleSitalert)
						_doubleSitalert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,stopDoubleSit);
				}
				else
				{
					doUse();
				}
				function stopDoubleSit(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						PlayerSitSocketHandler.send(false);
						_mediator.sceneInfo.playerList.clearDoubleSit();
						doUse();
					}
					_doubleSitalert = null;
				}
				function doUse():void
				{
					_mediator.sendEnterPointWar();
					_mediator.module.shenMoWarMainPanel.dispose();
					
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					if(_mediator && _mediator.module.sceneInit.playerListController.getSelf())_mediator.module.sceneInit.playerListController.getSelf().stopMoving();
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.enterNeedLevel40"));
				return;
			}
		}
		
		private function get clubPointWarMainInfo():ClubPointWarMainInfo
		{
			return _mediator.clubPointWarInfo.clubPointWarMainInfo;
		}
		
		public function show():void
		{
			_mediator.sendClubHonorInfo();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(argX:int, argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator.clubPointWarInfo.clearMainIno();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			
			if(_enterWarBtn)
			{
				_enterWarBtn.dispose();
				_enterWarBtn = null;
			}
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			
			if(_getRewardsBtn)
			{
				_getRewardsBtn.dispose();
				_getRewardsBtn = null;
			}
			for each(var i:ClubPointWarMainItemView  in _itemList)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_itemList = null;
			
			_perKillNumLabel = null;
			_perScoreNumLabel = null;
			_contributeNumLabel = null;
			_todayHonorNumLabel = null;
			_allHonorNumLabel = null;
			_doubleSitalert = null;
			
			if(_warScoreShopBtn)
			{
				_warScoreShopBtn.dispose();
				_warScoreShopBtn = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}