package sszt.scene.components.guide
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class ShenMoGuideIconView extends Sprite
	{
		private var _icon:Bitmap;
		private var _guidePanel:ShenMoGuidePanel;
		
		public function ShenMoGuideIconView()
		{
			super();
			initView();
			initEvents();
			if(GlobalData.selfPlayer.level>=30)
			{
				show();
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
			}
		}
		
		private function initView():void
		{
			buttonMode = true;
			_icon = new Bitmap();
			addChild(_icon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.GuideIconAsset") as BitmapData;
			if(t)
			{
				_icon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			move(CommonConfig.GAME_WIDTH - 55,170);
			GlobalAPI.layerManager.getPopLayer().addChild(this);
		}
		
		private function initEvents():void
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
		
		private function gameSizeHandler(evt:CommonModuleEvent):void
		{
//			move(CommonConfig.GAME_WIDTH - 55,CommonConfig.GAME_HEIGHT-410);
//			x = CommonConfig.GAME_WIDTH - 55;
			move(CommonConfig.GAME_WIDTH - 55,170);
		}
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			_icon.bitmapData = AssetUtil.getAsset("mhsm.scene.GuideIconAsset") as BitmapData;
		}
		
		private function upgradeHandler(evt:CommonModuleEvent):void
		{
			if(GlobalData.selfPlayer.level>=30)
			{
				show();
				ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
			}
		}
		
		private function iconClickHandler(evt:MouseEvent):void
		{
			if(_guidePanel)
			{
				if(_guidePanel.parent)
				{
					_guidePanel.parent.removeChild(_guidePanel);
					_guidePanel.dispose();
				}
				else
				{
					GlobalAPI.layerManager.addPanel(_guidePanel);
				}
			}
			else
			{
				_guidePanel = new ShenMoGuidePanel();
				_guidePanel.addEventListener(Event.CLOSE,guideCloseHandler);
				GlobalAPI.layerManager.addPanel(_guidePanel);
			}
		}
		
		private function guideCloseHandler(evt:Event):void
		{
			if(_guidePanel)
			{
				_guidePanel.removeEventListener(Event.CLOSE,guideCloseHandler);				
			}
			_guidePanel = null;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}