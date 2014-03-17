package sszt.scene.components.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CommonConfig;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	
	public class ServerTransportLeftTimeView extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _icon:Bitmap;
		private var _countDown:CountDownView;
		public function ServerTransportLeftTimeView(mediator:SceneMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			buttonMode = true;
//			this.x = CommonConfig.GAME_WIDTH - 215;
//			this.y = 50;
			
			this.x = CommonConfig.GAME_WIDTH - 360;
			this.y = 8;
			
			_icon = new Bitmap();
			addChild(_icon);
			var t:BitmapData = AssetUtil.getAsset("mhsm.scene.ServerTransportIconAsset") as BitmapData;
			if(t)
			{
				_icon.bitmapData = t;
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetComplete);
			}
			
			_countDown = new CountDownView();
			_countDown.setColor(0x00ff00);
			_countDown.move(2,40);
			addChild(_countDown);
		}
		
		public function setTime(second:Number):void
		{
			_countDown.start(second);
		}
		
		private function initEvents():void
		{
			addEventListener(MouseEvent.CLICK,iconClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_countDown.addEventListener(Event.COMPLETE,countDownCompleteHandler);
		}
		
		private function removeEvents():void
		{
			removeEventListener(MouseEvent.CLICK,iconClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_countDown.removeEventListener(Event.COMPLETE,countDownCompleteHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetComplete);
		}
		
		private function sceneAssetComplete(evt:CommonModuleEvent):void
		{
			_icon.bitmapData = AssetUtil.getAsset("mhsm.scene.ServerTransportIconAsset",BitmapData) as BitmapData;
		}
		
		private function iconClickHandler(evt:Event):void
		{
			_mediator.showServerTransportPanel();
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH - 360;
		}
		
		private function countDownCompleteHandler(evt:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			if(parent)
			{
				parent.removeChild(this);
			}
			_icon = null;
		}
	}
}