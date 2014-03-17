package sszt.scene.components.functionGuide
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
	import sszt.scene.components.functionGuide.FunctionGuidePanel;
	import sszt.scene.components.guide.ShenMoGuidePanel;
	import sszt.scene.mediators.SceneMediator;
	
	public class FunctionGuideIconView extends Sprite
	{
		private var _icon:Bitmap;
		private var _guidePanel:ShenMoGuidePanel;
		private var _mediator:SceneMediator;
		
		public function FunctionGuideIconView(mediator:SceneMediator)
		{
			_mediator = mediator
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
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.FunctionGuideIconAsset") as BitmapData;
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
			move(CommonConfig.GAME_WIDTH - 65,CommonConfig.GAME_HEIGHT - 135);
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
			move(CommonConfig.GAME_WIDTH - 65,CommonConfig.GAME_HEIGHT - 135);
		}
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			_icon.bitmapData = AssetUtil.getAsset("mhsm.scene.FunctionGuideIconAsset") as BitmapData;
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
			_mediator.showFunctionGuidePanel();
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