package sszt.scene.components.acrossServer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bossWar.BossWarTemplateInfo;
	import sszt.core.data.bossWar.BossWarTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.events.SceneAcroSerUpdateEvent;
	import sszt.scene.events.SceneBossWarUpdateEvent;
	import sszt.scene.mediators.AcroSerMediator;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	
	public class AcroSerIconView extends Sprite
	{
		public var _countDown:CountDownView;
		private var _mediator:AcroSerMediator;
		private var _acroSerIconLabel:MAssetLabel;
		private var _killLabel:MAssetLabel;
		private var _bossId:int = -1;
		private var _bossWarIcon:Bitmap;
		public function AcroSerIconView(argMediator:AcroSerMediator)
		{
			_mediator = argMediator;
			super();
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			buttonMode = true;
			_bossWarIcon = new Bitmap();
			addChild(_bossWarIcon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.AcrossBossIconAsset") as BitmapData;
			if(t)
			{
				_bossWarIcon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			_acroSerIconLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_acroSerIconLabel.mouseEnabled = _acroSerIconLabel.mouseWheelEnabled = false;
			_acroSerIconLabel.textColor = 0x00ff00;
			_acroSerIconLabel.move(25,45);
			
			_killLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.canKill"),MAssetLabel.LABELTYPE1);
			_killLabel.mouseEnabled = _killLabel.mouseWheelEnabled = false;
			_killLabel.textColor = 0x00ff00;
			_killLabel.move(10,60);
			
			_countDown = new CountDownView();
			_countDown.setColor(0x00ff00);
			_countDown.move(0,60);
			
			move(CommonConfig.GAME_WIDTH - 300,5);
		}
		
		
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_mediator.bossWarInfo.addEventListener(SceneAcroSerUpdateEvent.ACROSER_BOSS_FOCUSE_UPDATE,focuseUpdateHandler);
			this.addEventListener(MouseEvent.CLICK,iconClickHandler);
		}
		
		private  function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_mediator.bossWarInfo.removeEventListener(SceneAcroSerUpdateEvent.ACROSER_BOSS_FOCUSE_UPDATE,focuseUpdateHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			this.removeEventListener(MouseEvent.CLICK,iconClickHandler);
		}
		
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			_bossWarIcon.bitmapData = AssetUtil.getAsset("mhsm.scene.AcrossBossIconAsset",BitmapData) as BitmapData;
		}
		
		
		private function iconClickHandler(e:MouseEvent):void
		{
			if(_mediator.sceneModule.acroSerMainPanel)
			{
				_mediator.sceneModule.acroSerMainPanel.dispose();
			}
			else
			{
				_mediator.sendNotification(SceneAcroSerUpdateEvent.ACROSER_SHOW_MAIN_PANEL);
			}
		}
		
		private function focuseUpdateHandler(e:SceneAcroSerUpdateEvent):void
		{
			var tmpBossId:int = e.data as int;
			_bossId = tmpBossId;
			if(tmpBossId == -1)
			{
				if(_killLabel.parent)_killLabel.parent.removeChild(_killLabel);
				if(_acroSerIconLabel.parent)_acroSerIconLabel.parent.removeChild(_acroSerIconLabel);
				if(_countDown.parent)_countDown.parent.removeChild(_countDown);
				_countDown.removeEventListener(Event.COMPLETE,countDownCompleteHandler);
			}
			else
			{
				_acroSerIconLabel.text = MonsterTemplateList.getMonster(tmpBossId).name;
				var tmpTime:int = _mediator.sceneModule.acroSerMainPanel.panels[0].getItem(tmpBossId).getCurrentTimeToInt();
				if(tmpTime != 0)_countDown.start(tmpTime);
				_countDown.addEventListener(Event.COMPLETE,countDownCompleteHandler);
				addChild(_acroSerIconLabel);
				if(_countDown.getTimeToInt() == 0)
				{
					addChild(_killLabel);
				}
				else
				{
					addChild(_countDown);
				}
			}
		}
		
		private function gameSizeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 300;
		}
		
		private function countDownCompleteHandler(e:Event):void
		{
			if(_countDown.parent)_countDown.parent.removeChild(_countDown);
			addChild(_killLabel);
			var tmpInfo:MonsterTemplateInfo = MonsterTemplateList.getMonster(_bossId);
			var tmpBossInfo:BossWarTemplateInfo = BossWarTemplateList.getBossWarTemplateInfo(_bossId);
			if(tmpBossInfo.type == 3)
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.sureInChangeFightMode",tmpInfo.name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			}
			else
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.sureTransfer",tmpInfo.name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			}
			function closeHandler(e:CloseEvent):void
			{
				if(tmpBossInfo.type == 3 && GlobalData.selfPlayer.level < 60)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.unenterableBefore60"));
					return;
				}
				if(e.detail == MAlert.OK)
				{
					if(!GlobalData.selfPlayer.canfly())
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
					}
					else
					{
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:tmpBossInfo.mapId,target:new Point(tmpBossInfo.posX,tmpBossInfo.posY)}));
					}
				}
			}
		}
		
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(ShopID.QUICK_BUY));
			}
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(parent)parent.removeChild(this);
			_acroSerIconLabel = null;
			_killLabel = null;
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			_mediator = null;
		}
	}
}