package sszt.scene.components.shenMoWar.crystalWar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class CrystalWarIconView extends Sprite
	{
		public var _countDown:CountDownView;
		private var _mediator:SceneWarMediator;
		private var _clubWarIcon:Bitmap;
		public function CrystalWarIconView(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			initView();
			initialEvents();
		}
		
		private function initView():void
		{
			buttonMode = true;
			
			_clubWarIcon = new Bitmap();
			addChild(_clubWarIcon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.CrystalIconAsset") as BitmapData;
			if(t)
			{
				_clubWarIcon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			_countDown = new CountDownView();
			_countDown.setColor(0x00ff00);
			_countDown.move(5,45);
			addChild(_countDown);
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_countDown.addEventListener(Event.COMPLETE,countDownCompleteHandler);
			this.addEventListener(MouseEvent.CLICK,iconClickHandler);
		}
		
		private function remvoeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
			_countDown.removeEventListener(Event.COMPLETE,countDownCompleteHandler);
			this.removeEventListener(MouseEvent.CLICK,iconClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
		}	
		
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			_clubWarIcon.bitmapData = AssetUtil.getAsset("mhsm.scene.ClubWarIconAsset",BitmapData) as BitmapData;
		}
		
		private function iconClickHandler(e:MouseEvent):void
		{
			if(_mediator.sceneInfo.mapInfo.isCrystalWarScene())
			{
				_mediator.showCrystalWarScorePanel();
			}
			else
			{
				_mediator.showShenMoMainPanel(3);
			}
		}
		
		private function gameSizeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 370;
		}
		
		private function countDownCompleteHandler(e:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function show(seconds:int):void
		{
			if(!parent)
			{
				move(CommonConfig.GAME_WIDTH - 370,0);
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