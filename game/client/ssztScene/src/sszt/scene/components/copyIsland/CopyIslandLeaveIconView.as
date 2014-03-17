package sszt.scene.components.copyIsland
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.acrossServer.AcroSerBossLeaveSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandLeaveSocketHandler;
	
	public class CopyIslandLeaveIconView extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _shenMoIcon:Bitmap;
		public function CopyIslandLeaveIconView(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			buttonMode = true;
			_shenMoIcon = new Bitmap();
			addChild(_shenMoIcon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.AcrossBossLeaveAsset") as BitmapData;
			if(t)
			{
				_shenMoIcon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			move(CommonConfig.GAME_WIDTH - 295,80);
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			this.addEventListener(MouseEvent.CLICK,iconClickHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			this.removeEventListener(MouseEvent.CLICK,iconClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
		}
		
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			_shenMoIcon.bitmapData = AssetUtil.getAsset("mhsm.scene.AcrossBossLeaveAsset",BitmapData) as BitmapData;
		}
		
		private function gameSizeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 295;
		}
		
		private function iconClickHandler(e:MouseEvent):void
		{
//			if(!GlobalData.selfScenePlayerInfo.getIsCommon())
//			{
//				QuickTips.show("战斗状态下，禁止此操作！");
//				return;
//			}
			MAlert.show(LanguageManager.getWord("ssztl.scene.isSureLeaveCopy"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					if(_mediator && _mediator.sceneModule.sceneInit.playerListController.getSelf())_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
					CopyIslandLeaveSocketHandler.send();
				}
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
			_mediator = null;
			if(parent)parent.removeChild(this);
		}
	}
}