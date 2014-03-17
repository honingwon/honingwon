package sszt.scene.components.bossWar
{
	import fl.controls.Label;
	
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
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToBossWarIconData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.LayerManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.events.SceneBossWarUpdateEvent;
	import sszt.scene.mediators.BossWarMediator;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	
	public class BossIconView extends Sprite
	{
		public var _countDown:CountDownView;
		private var _mediator:BossWarMediator;
		private var _bossWarIconLabel:MAssetLabel;
		private var _killLabel:MAssetLabel;
		private var _bossId:int = -1;
		private var _bossWarIcon:Bitmap;
		public function BossIconView(argMediator:BossWarMediator)
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
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.BossWarIconAsset") as BitmapData;
			if(t)
			{
				_bossWarIcon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			_bossWarIconLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_bossWarIconLabel.mouseEnabled = _bossWarIconLabel.mouseWheelEnabled = false;
			_bossWarIconLabel.textColor = 0x00ff00;
			_bossWarIconLabel.move(25,45);
			
			_killLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.canKill"),MAssetLabel.LABELTYPE1);
			_killLabel.mouseEnabled = _killLabel.mouseWheelEnabled = false;
			_killLabel.textColor = 0x00ff00;
			_killLabel.move(10,60);
			
			_countDown = new CountDownView();
			_countDown.setColor(0x00ff00);
			_countDown.move(0,60);
			
			move(CommonConfig.GAME_WIDTH - 240,3);
		}
		
		
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_mediator.bossWarInfo.addEventListener(SceneBossWarUpdateEvent.BOSS_FOCUSE_UPDATE,focuseUpdateHandler);
			this.addEventListener(MouseEvent.CLICK,iconClickHandler);
		}
		
		private  function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_mediator.bossWarInfo.removeEventListener(SceneBossWarUpdateEvent.BOSS_FOCUSE_UPDATE,focuseUpdateHandler);
			this.removeEventListener(MouseEvent.CLICK,iconClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
		}
		
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			_bossWarIcon.bitmapData = AssetUtil.getAsset("mhsm.scene.BossWarIconAsset",BitmapData) as BitmapData;
		}
		
		
		private function iconClickHandler(e:MouseEvent):void
		{
			if(_mediator.sceneModule.bossMainPanel)
			{
				_mediator.sceneModule.bossMainPanel.dispose();
			}
			else
			{
				_mediator.showBossMainPanel();
			}
		}
		
		private function focuseUpdateHandler(e:SceneBossWarUpdateEvent):void
		{
			var tmpBossId:int = e.data as int;
			_bossId = tmpBossId;
			if(tmpBossId == -1)
			{
				if(_killLabel.parent)_killLabel.parent.removeChild(_killLabel);
				if(_bossWarIconLabel.parent)_bossWarIconLabel.parent.removeChild(_bossWarIconLabel);
				if(_countDown.parent)_countDown.parent.removeChild(_countDown);
				_countDown.removeEventListener(Event.COMPLETE,countDownCompleteHandler);
			}
			else
			{
				_bossWarIconLabel.text = MonsterTemplateList.getMonster(tmpBossId).name;
				var tmpTime:int = _mediator.sceneModule.bossMainPanel.getItem(tmpBossId).getCurrentTimeToInt();
				if(tmpTime != 0)_countDown.start(tmpTime);
				_countDown.addEventListener(Event.COMPLETE,countDownCompleteHandler);
				addChild(_bossWarIconLabel);
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
			x = CommonConfig.GAME_WIDTH - 240;
		}
		
		private function countDownCompleteHandler(e:Event):void
		{
			if(_countDown.parent)_countDown.parent.removeChild(_countDown);
			addChild(_killLabel);
			var tmpInfo:MonsterTemplateInfo = MonsterTemplateList.getMonster(_bossId);
			var tmpBossInfo:BossWarTemplateInfo = BossWarTemplateList.getBossWarTemplateInfo(_bossId);
			if(tmpBossInfo.type == 2)
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.sureInChangeFightMode",tmpInfo.name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			}
			else
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.sureTransfer",tmpInfo.name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
			}
			function closeHandler(e:CloseEvent):void
			{
				if(tmpBossInfo.type == 2 && GlobalData.selfPlayer.level < 40)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotEnterMap",40));
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
			if(parent)parent.removeChild(this);
			_bossWarIconLabel = null;
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