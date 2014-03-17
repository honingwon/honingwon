package sszt.scene.components.duplicate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import sszt.constData.CommonConfig;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.events.ScenePvP1UpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.scene.ComboNumberAsset0;
	import ssztui.scene.ComboNumberAsset1;
	import ssztui.scene.ComboNumberAsset2;
	import ssztui.scene.ComboNumberAsset3;
	import ssztui.scene.ComboNumberAsset4;
	import ssztui.scene.ComboNumberAsset5;
	import ssztui.scene.ComboNumberAsset6;
	import ssztui.scene.ComboNumberAsset7;
	import ssztui.scene.ComboNumberAsset8;
	import ssztui.scene.ComboNumberAsset9;
	import ssztui.scene.PickUpDownBgAsset;
	
	public class CountDownPanel extends Sprite
	{
		private var _bg:Bitmap;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		
		private var _countDown:MAssetLabel;
		private var _timer:Timer;
		
		private var _numAssets:Array;
		private var _txtBox:MSprite;
		
		private var _countTime:int = 99;
		
		public function CountDownPanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();	
		}
		
		private function initialView():void
		{
			_numAssets = [ComboNumberAsset0,ComboNumberAsset1,ComboNumberAsset2,ComboNumberAsset3,ComboNumberAsset4,ComboNumberAsset5,ComboNumberAsset6,ComboNumberAsset7,ComboNumberAsset8,ComboNumberAsset9];
			
			this.x = (CommonConfig.GAME_WIDTH)/2;
			this.y = 90;
			
			_bg = new Bitmap(new PickUpDownBgAsset());
			_bg.x = -117;
			addChild(_bg);
			
			_txtBox = new MSprite();
			_txtBox.move(-12,-25);
			addChild(_txtBox);
			
			_countDown = new MAssetLabel("90",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_countDown.move(22,38);
//			addChild(_countDown);
			
			_timer = new Timer(1000,_countTime);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.start();
			_mediator.sceneModule.duplicateNormalInfo.addEventListener(ScenePvP1UpdateEvent.PVP1_CLOSE_COUNTDOWN, closeCountDown);
			_mediator.sceneModule.duplicateNormalInfo.addEventListener(ScenePvP1UpdateEvent.PVP1_STOP_COUNTDOWN, stopCountDown);
		}
		private function stopCountDown(evt:ScenePvP1UpdateEvent):void
		{
			_timer.stop();
		}
		private function closeCountDown(evt:ScenePvP1UpdateEvent):void
		{
			dispose();
		}
		private function timerHandler(evt:TimerEvent):void
		{
			var n:int = _timer.currentCount;
//			_countDown.text = n.toString();	
			setNumbers(_countTime - n);
		}
		private function setNumbers(n:Number):void
		{
			while(_txtBox && _txtBox.numChildren>0){
				_txtBox.removeChildAt(0);
			}
			var f:String = n.toString();
			for(var i:int=0; i<f.length; i++)
			{
				var mc:Bitmap = new Bitmap(new _numAssets[int(f.charAt(i))]() as BitmapData);
				mc.x = i*34; 
				_txtBox.addChild(mc);
			}
			_txtBox.move(25-_txtBox.width/2,-25);
		}
		public function dispose():void
		{
			_mediator.sceneModule.duplicateNormalInfo.removeEventListener(ScenePvP1UpdateEvent.PVP1_CLOSE_COUNTDOWN, closeCountDown);
			_mediator.sceneModule.duplicateNormalInfo.removeEventListener(ScenePvP1UpdateEvent.PVP1_STOP_COUNTDOWN, stopCountDown);
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.stop();
				_timer = null;
			}
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			while(_txtBox && _txtBox.numChildren>0){
				_txtBox.removeChildAt(0);
			}
			_txtBox = null;
			_countDown = null;
			if(parent)parent.removeChild(this);
		}
	}
}