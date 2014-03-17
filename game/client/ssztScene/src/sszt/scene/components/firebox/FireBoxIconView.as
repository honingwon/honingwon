package sszt.scene.components.firebox
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.acrossServer.AcroSerBossLeaveSocketHandler;
	
	public class FireBoxIconView extends Sprite
	{
		private var _fireBoxIcon:Bitmap;
		public function FireBoxIconView()
		{
			super();
			initialView();
			initialEvents();
			show();
		}
		
		private function initialView():void
		{
			buttonMode = true;
			_fireBoxIcon = new Bitmap();
			addChild(_fireBoxIcon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.FireboxAsset") as BitmapData;
			if(t)
			{
				_fireBoxIcon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
		}
		
		public function show():void
		{
			move(CommonConfig.GAME_WIDTH - 100,CommonConfig.GAME_HEIGHT-410);
			GlobalAPI.layerManager.getPopLayer().addChild(this);
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
			_fireBoxIcon.bitmapData = AssetUtil.getAsset("mhsm.scene.FireboxAsset",BitmapData) as BitmapData;
		}
		
		
		private function gameSizeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 100;
		}
		
		private function iconClickHandler(e:MouseEvent):void
		{
			SetModuleUtils.addFireBox();
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
		}
	}
}