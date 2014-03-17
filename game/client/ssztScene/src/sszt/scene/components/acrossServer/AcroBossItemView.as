package sszt.scene.components.acrossServer
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.PK.PKType;
	import sszt.core.data.activity.BossTemplateInfo;
	import sszt.core.data.bossWar.BossWarTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.events.SceneAcroSerUpdateEvent;
	import sszt.scene.events.SceneBossWarUpdateEvent;
	import sszt.scene.mediators.AcroSerMediator;
	import sszt.scene.mediators.BossWarMediator;
	
	public class AcroBossItemView extends Sprite
	{
		private var _info:BossWarTemplateInfo;
		private var _mediator:AcroSerMediator;
		private var _countDownView:CountDownView;
		
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _mapNameLabel:MAssetLabel;
		private var _stateLabel:MAssetLabel;
		
		private var _focuseBtn:MCacheAsset3Btn;
		private var _cancelFocuseBtn:MCacheAsset3Btn;
		private var _connectBtn:MCacheAsset3Btn;
		private var _select:Boolean;
		private var _selectedBg:Shape;
		
		public function AcroBossItemView(argInfo:BossWarTemplateInfo,argMediator:AcroSerMediator)
		{
			_info = argInfo;
			_mediator = argMediator;
			super();
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,380,30);
			graphics.endFill();
			
			_selectedBg = new Shape();
			_selectedBg.graphics.beginFill(0x7AC900,0.5);
			_selectedBg.graphics.drawRect(0,0,380,30);
			_selectedBg.graphics.endFill();
			addChild(_selectedBg);
			_selectedBg.visible = false;
			
			var monsterInfo:MonsterTemplateInfo = MonsterTemplateList.getMonster(_info.id);
			_nameLabel = new MAssetLabel(monsterInfo.name,MAssetLabel.LABELTYPE1);
			_nameLabel.move(5,8);
			addChild(_nameLabel);
			
			_levelLabel = new MAssetLabel(monsterInfo.level.toString(),MAssetLabel.LABELTYPE1);
			_levelLabel.move(80,8);
			addChild(_levelLabel);
			
			_stateLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.canKill"),MAssetLabel.LABELTYPE16);
			_stateLabel.move(129,8);
			addChild(_stateLabel);
			
			_countDownView = new CountDownView();
			_countDownView.setColor(0xFF0000);
			_countDownView.move(127,8);
			addChild(_countDownView);
			
			_mapNameLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.crossServer"),MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
//			_mapNameLabel.htmlText = "<u><a href='event:1'>"+MapTemplateList.getMapTemplate(_info.mapId).name+"</a></u>";
			_mapNameLabel.mouseEnabled = _mapNameLabel.mouseWheelEnabled = true;
			_mapNameLabel.selectable = false;
			_mapNameLabel.move(212,8);
			addChild(_mapNameLabel);
			
			_focuseBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.scene.focuse"));
			_focuseBtn.move(268,5);
			addChild(_focuseBtn);
			
			_cancelFocuseBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelFocuseBtn.move(268,5);
			addChild(_cancelFocuseBtn);
			_cancelFocuseBtn.visible = false;
			
			_connectBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.scene.connect"));
			_connectBtn.move(316,5);
			addChild(_connectBtn);
			
			focuseUpdateHandler(null);
		}
		
		private function initEvents():void
		{
			_focuseBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_connectBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelFocuseBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_countDownView.addEventListener(Event.COMPLETE,countDownCompleteHandler);
			_mediator.bossWarInfo.addEventListener(SceneAcroSerUpdateEvent.ACROSER_BOSS_FOCUSE_UPDATE,focuseUpdateHandler);
//			addEventListener(TextEvent.LINK,linkClickHandler);
		}
		
		private function removeEvents():void
		{
			_focuseBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_connectBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelFocuseBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_countDownView.removeEventListener(Event.COMPLETE,countDownCompleteHandler);
			_mediator.bossWarInfo.removeEventListener(SceneAcroSerUpdateEvent.ACROSER_BOSS_FOCUSE_UPDATE,focuseUpdateHandler);
//			removeEventListener(TextEvent.LINK,linkClickHandler);
		}
		
//		private function linkClickHandler(e:TextEvent):void
//		{
//			switch(e.text)
//			{
//				case "1":
//					if(GlobalData.copyEnterCountList.isInCopy || _mediator.sceneModule.sceneInfo.mapInfo.isSpaScene())
//					{
//						//						QuickTips.show("特殊场景内不允许此行为。");
//						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
//						return;
//					}
//					_mediator.sceneModule.sceneInit.walk(_info.mapId,null);
//					break;
//			}
//		}
		
		private function focuseUpdateHandler(e:SceneAcroSerUpdateEvent):void
		{
			if(_mediator.bossWarInfo.acrossSelectId == -1)
			{
				_focuseBtn.visible = true;
				_cancelFocuseBtn.visible = false;
				_focuseBtn.enabled = true;
			}
			else if(_info.id != _mediator.bossWarInfo.acrossSelectId)
			{
				_focuseBtn.enabled = false;
			}
			else if(_info.id == _mediator.bossWarInfo.acrossSelectId)
			{
				_focuseBtn.visible = false
				_cancelFocuseBtn.visible = true;
			}
		}
		
		private function countDownCompleteHandler(e:Event):void
		{
			_countDownView.visible = false;
			_stateLabel.visible = true;
		}
		
		public function updateTime(argTime:int):void
		{
			_stateLabel.visible = false;
			_countDownView.start(argTime);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				return;
			}
			switch(e.currentTarget)
			{
				case _focuseBtn:
					if(_countDownView.getTimeToInt() == 0)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.bossRefreshed"));
					}
					else
					{
						_mediator.bossWarInfo.updateAcroBossSelectId(_info.id);
					}
					break;
				case _connectBtn:
					sendHandler();
					break;
				case _cancelFocuseBtn:
					_mediator.bossWarInfo.updateAcroBossSelectId(-1);
					break;
			}
		}
		
		private function sendHandler():void
		{
			if(GlobalData.selfPlayer.level < 55)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.ByUnAchieve60"));
					return;
			}
			if(GlobalData.selfPlayer.fight < 20000)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.byFightUnAchieve5000"));
				return;
			}
			if(GlobalData.copyEnterCountList.isInCopy)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.byInCopy"));
				return;
			}
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.byInTransport"));
				return;
			}
			if(!GlobalData.selfScenePlayerInfo.getIsCommon())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.byFighting"));
				return;
			}
			if(GlobalData.isInTrade)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.byInTrade"));
				return;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.byInCrossServerMap"));
				return;
			}
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.sceneUnconnectable"));
				return;
			}
			MAlert.show(LanguageManager.getWord("ssztl.scene.sureEnterCrossScene"),"提示",MAlert.OK|MAlert.CANCEL,null,closeHandler);
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					if(_mediator && _mediator.sceneModule.sceneInit.playerListController.getSelf())_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
					
					_mediator.sendEnter(_info.mapId);
					_mediator.sceneModule.acroSerMainPanel.dispose();
				}
			}
		}
		
		public function get info():BossWarTemplateInfo
		{
			return _info;
		}
		
		public function set info(value:BossWarTemplateInfo):void
		{
			_info = value;
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(value:Boolean):void
		{
			if(_select == value)return;
			_select = value;
			if(_select)_selectedBg.visible = true;
			else _selectedBg.visible = false;
		}
		
		public function getCurrentTimeToInt():int
		{
			return _countDownView.getTimeToInt();
		}
		
		public function dispose():void
		{
			removeEvents();
			_info = null;
			_mediator = null;
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView = null;
			}
			_nameLabel = null;
			_levelLabel = null;
			_mapNameLabel = null;
			_stateLabel = null;
			if(_focuseBtn)
			{
				_focuseBtn.dispose();
				_focuseBtn = null;
			}
			if(_cancelFocuseBtn)
			{
				_cancelFocuseBtn.dispose();
				_cancelFocuseBtn = null;
			}
			if(_connectBtn)
			{
				_connectBtn.dispose();
				_connectBtn = null;
			}
			_selectedBg = null;
			if(parent)parent.removeChild(this);
		}
	}
}