package sszt.scene.components.shenMoWar.crystalWar
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
	import sszt.scene.components.shenMoWar.crystalWar.mainInfo.CrystalWarMainItemView;
	import sszt.scene.components.shenMoWar.main.IShenMoMainInterface;
	import sszt.scene.data.crystalWar.mainInfo.CrystalWarMainInfo;
	import sszt.scene.events.SceneCrystalWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	
	public class CrystalWarPanel extends Sprite implements IShenMoMainInterface
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
//		private var _contributeNumLabel:MAssetLabel;
		private var _todayHonorNumLabel:MAssetLabel;
		private var _allHonorNumLabel:MAssetLabel;
		
		private var _warScoreShopBtn:MCacheAsset1Btn;
		private var _doubleSitalert:MAlert;
		
		public function CrystalWarPanel(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			_mediator.crystalWarInfo.initialMainInfo();
			initialView();
			initialEvents();
			_mediator.sendCrystalWarMainInfo();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground(
				[
					new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,323,47)),
					new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,50,323,278)),
					new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(327,0,205,328)),
					new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(4,54,316,22))
				]);
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.personalKillNum"),MAssetLabel.LABELTYPE14);
			label1.move(6,5);
			addChild(label1);
//			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.personalContributeValue"),MAssetLabel.LABELTYPE14);
//			label2.move(6,25);
//			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.personalScore"),MAssetLabel.LABELTYPE14);
			label3.move(185,5);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.todayHonorValue"),MAssetLabel.LABELTYPE14);
			label4.move(185,25);
			addChild(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.totalHonorValue"),MAssetLabel.LABELTYPE14);
			label5.move(6,25);
			addChild(label5);
			
			_itemList = [];
			_mTile = new MTile(320,20);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = _mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.setSize(320,230);
			_mTile.move(6,83);
			addChild(_mTile);
			
			for(var i:int = 0;i<PAGE_COUNT;i++)
			{
				var tmpItemView:CrystalWarMainItemView = new CrystalWarMainItemView();
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
			var label6:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.crystalWarLabel6"),MAssetLabel.LABELTYPE14);
			label6.move(10,57);
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
			
			label7.htmlText = LanguageManager.getWord("ssztl.scene.crystalWarLabel7");
			
			_perKillNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_perKillNumLabel.move(104,5);
			addChild(_perKillNumLabel);
			
			_perScoreNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_perScoreNumLabel.move(265,5);
			addChild(_perScoreNumLabel);
			
//			_contributeNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
//			_contributeNumLabel.move(104,25);
//			addChild(_contributeNumLabel);
			
			_todayHonorNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_todayHonorNumLabel.move(265,25);
			addChild(_todayHonorNumLabel);
			
			_allHonorNumLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_allHonorNumLabel.move(104,25);
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
			crystalWarMainInfo.addEventListener(SceneCrystalWarUpdateEvent.CRYSTAL_MAIN_INFO_UPDATE,mainListUpdate);
			crystalWarMainInfo.addEventListener(SceneCrystalWarUpdateEvent.CRYSTAL_MAIN_INFO_PERSONALINFO_UPDATE,updatePersonalInfo);
			_warScoreShopBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvents():void
		{
			_enterWarBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_getRewardsBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			crystalWarMainInfo.removeEventListener(SceneCrystalWarUpdateEvent.CRYSTAL_MAIN_INFO_UPDATE,mainListUpdate);
			crystalWarMainInfo.removeEventListener(SceneCrystalWarUpdateEvent.CRYSTAL_MAIN_INFO_PERSONALINFO_UPDATE,updatePersonalInfo);
			_warScoreShopBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function mainListUpdate(e:SceneCrystalWarUpdateEvent):void
		{
			clearList();
			for(var i:int = 0;i < crystalWarMainInfo.itemInfoList.length;i++)
			{
				_itemList[i].info = crystalWarMainInfo.itemInfoList[i];
			}
		}
		
		private function updatePersonalInfo(e:SceneCrystalWarUpdateEvent):void
		{
			_perKillNumLabel.text = crystalWarMainInfo.personalKillNum.toString();
			_perScoreNumLabel.text = crystalWarMainInfo.personalScore.toString();
//			_contributeNumLabel.text = crystalWarMainInfo.personalContribute.toString();
			_todayHonorNumLabel.text = crystalWarMainInfo.todayHonorNum.toString();
			_allHonorNumLabel.text = crystalWarMainInfo.allHonorNum.toString();
		}
		
		private function clearList():void
		{
			for each(var i:CrystalWarMainItemView in _itemList)
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
					_mediator.showCrystalWarScorePanel();
				break;
				case _warScoreShopBtn:
					_mediator.showShenMoWarShopPanel();
				break;
			}
		}
		
		private function enterBtnHandler():void
		{
			if(_mediator.sceneInfo.mapInfo.isCrystalWarScene())
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
				if(GlobalData.copyEnterCountList.isInCopy)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
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
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					if(_mediator && _mediator.module.sceneInit.playerListController.getSelf())_mediator.module.sceneInit.playerListController.getSelf().stopMoving();
				
					_mediator.sendCrystalWarEnter();
					_mediator.module.shenMoWarMainPanel.dispose();
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.enterNeedLevel40"));
				return;
			}
		}
		
		private function get crystalWarMainInfo():CrystalWarMainInfo
		{
			return _mediator.crystalWarInfo.crystalWarMainInfo;
		}
		
		public function show():void
		{
			_mediator.sendCrystalWarPersonal();
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
			_mediator.crystalWarInfo.clearMainIno();
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
			for each(var i:CrystalWarMainItemView  in _itemList)
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
//			_contributeNumLabel = null;
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