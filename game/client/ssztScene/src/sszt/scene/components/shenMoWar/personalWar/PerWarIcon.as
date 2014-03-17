package sszt.scene.components.shenMoWar.personalWar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class PerWarIcon extends Sprite
	{
		public var _countDown:CountDownView;
		private var _mediator:SceneWarMediator;
		private var _perWarIcon:Bitmap;
		public function PerWarIcon(argMediator:SceneWarMediator)
		{
			_mediator = argMediator;
			super();
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			buttonMode = true;
			
			_perWarIcon = new Bitmap();
			addChild(_perWarIcon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.PerWarIconAsset") as BitmapData;
			if(t)
			{
				_perWarIcon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			
			_countDown = new CountDownView();
			_countDown.setColor(0x00ff00);
			_countDown.move(0,43);
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
			_perWarIcon.bitmapData = AssetUtil.getAsset("mhsm.scene.PerWarIconAsset",BitmapData) as BitmapData;
		}
		
		private function iconClickHandler(e:MouseEvent):void
		{
			if(MapTemplateList.isPerWarMap())
			{
				_mediator.showPerWarRewardsPanel();
			}
			else
			{
				_mediator.showShenMoMainPanel(2);
			}
		}
		
		private function gameSizeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 365;
		}
		
		private function countDownCompleteHandler(e:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function show(seconds:int):void
		{
			if(!parent)
			{
				move(CommonConfig.GAME_WIDTH - 365,5);
				GlobalAPI.layerManager.getPopLayer().addChild(this);
				_countDown.start(seconds);
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
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			_mediator = null;
		}
	}
}