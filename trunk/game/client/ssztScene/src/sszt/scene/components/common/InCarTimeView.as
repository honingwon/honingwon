package sszt.scene.components.common
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	
	public class InCarTimeView extends Sprite
	{
		private var _bg:Bitmap;
		private var _label:MAssetLabel;
		private var _countDown:CountDownView;
		private var _btn:MAssetButton1;
		private var _mediator:SceneMediator;
		
		public function InCarTimeView(mediator:SceneMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			gameSizeChangeHandler(null);
			
			_bg = new  Bitmap(AssetUtil.getAsset("ssztui.scene.TransportSceneBgAsset") as BitmapData);
			addChild(_bg);
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TransportSceneBtnAsset") as MovieClip);
			_btn.move(77,-23);
			addChild(_btn);
			
			_label = new MAssetLabel(LanguageManager.getWord("ssztl.scene.transportLeftTime"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_label.move(36,21);
			addChild(_label);
			
			_countDown = new CountDownView();
			_countDown.setColor(0x0cff00);
			_countDown.move(120,21);
			addChild(_countDown);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			
			_btn.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH/2;
			this.y = CommonConfig.GAME_HEIGHT-220;
		}
		private function onClick(e:MouseEvent):void
		{
			_mediator.showTransportPanel();
		}
		
		public function setTime(second:Number):void
		{
			_countDown.start(second);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}