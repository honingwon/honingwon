package sszt.scene.components.clubFire
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.camp.ClubCampEnterSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.mediators.SceneClubMediator;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class ClubFireIconView extends Sprite
	{
		public var _countDown:CountDownView;
		private var _mediator:SceneClubMediator;
		private var _clubFireIcon:Bitmap;
		public function ClubFireIconView(argMediator:SceneClubMediator)
		{
			_mediator = argMediator;
			super();
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			buttonMode = true;
			
			_clubFireIcon = new Bitmap();
			addChild(_clubFireIcon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.ClubFireIconAsset") as BitmapData;
			if(t)
			{
				_clubFireIcon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			_countDown = new CountDownView();
			_countDown.setColor(0x00ff00);
			_countDown.move(3,43);
			addChild(_countDown);
		}
		
		
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_countDown.addEventListener(Event.COMPLETE,countDownCompleteHandler);
			this.addEventListener(MouseEvent.CLICK,iconClickHandler);
		}
		
		private  function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_countDown.removeEventListener(Event.COMPLETE,countDownCompleteHandler);
			this.removeEventListener(MouseEvent.CLICK,iconClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
		}
		
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			_clubFireIcon.bitmapData = AssetUtil.getAsset("mhsm.scene.ClubFireIconAsset",BitmapData) as BitmapData;
		}
		
		private function iconClickHandler(e:MouseEvent):void
		{
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				return;
			}
			if(!sceneModule.sceneInfo.mapInfo.isClubFire())
			{
				if(GlobalData.copyEnterCountList.isInCopy || sceneModule.sceneInfo.playerList.self.isTransporting || !sceneModule.sceneInfo.playerList.self.getIsCommon() || MapTemplateList.getIsPrison())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotOperate"));
					return;
				}
				MAlert.show(LanguageManager.getWord("ssztl.scene.sureEnterClubFire"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,enterAlertHandler);
				function enterAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						if(sceneModule.sceneInfo.playerList.isDoubleSit())
						{
							PlayerSitSocketHandler.send(false);
							sceneModule.sceneInfo.playerList.clearDoubleSit();
						}
						GlobalData.selfPlayer.scenePath = null;
						GlobalData.selfPlayer.scenePathTarget = null;
						GlobalData.selfPlayer.scenePathCallback = null;
						sceneModule.sceneInit.playerListController.getSelf().stopMoving();
						SetModuleUtils.addClub(4);
					}
				}
			}
			else
			{
				if(!sceneModule.sceneInfo.playerList.self.getIsCommon())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotOperate"));
					return;
				}
				MAlert.show(LanguageManager.getWord("ssztl.scene.sureLeaveClubFire"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
				function leaveAlertHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						if(sceneModule.sceneInfo.playerList.isDoubleSit())
						{
							PlayerSitSocketHandler.send(false);
							sceneModule.sceneInfo.playerList.clearDoubleSit();
						}
						GlobalData.selfPlayer.scenePath = null;
						GlobalData.selfPlayer.scenePathTarget = null;
						GlobalData.selfPlayer.scenePathCallback = null;
						sceneModule.sceneInit.playerListController.getSelf().stopMoving();
						ClubCampEnterSocketHandler.send();
					}
				}
			}
		}
		
		private function gameSizeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 360;
		}
		
		private function countDownCompleteHandler(e:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function show(seconds:int):void
		{
			if(!parent)
			{
				move(CommonConfig.GAME_WIDTH - 360,3);
				GlobalAPI.layerManager.getPopLayer().addChild(this);
				_countDown.start(seconds);
			}
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		private function get sceneModule():SceneModule
		{
			return _mediator.sceneModule;
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			_mediator = null;
		}
		
		
	}
}