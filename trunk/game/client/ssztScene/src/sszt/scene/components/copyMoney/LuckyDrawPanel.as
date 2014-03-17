package sszt.scene.components.copyMoney
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.BigMapMediator;
	import sszt.scene.socketHandlers.CopyRandMoneySocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	
	import ssztui.scene.LuckyDrawBgAsset;
	import ssztui.scene.LuckyDrawBtnAsset;
	import ssztui.scene.LuckyNumberAsset0;
	import ssztui.scene.LuckyNumberAsset1;
	import ssztui.scene.LuckyNumberAsset2;
	import ssztui.scene.LuckyNumberAsset3;
	import ssztui.scene.LuckyNumberAsset4;
	import ssztui.scene.LuckyNumberAsset5;
	import ssztui.scene.LuckyNumberAsset6;
	import ssztui.scene.LuckyNumberAsset7;
	import ssztui.scene.LuckyNumberAsset8;
	import ssztui.scene.LuckyNumberAsset9;
	import ssztui.scene.LuckyNumberMaskAsset;

	public class LuckyDrawPanel extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _mediator:BigMapMediator;
		private var _btnStart:MAssetButton1;
		private var _tensPlace:Sprite;
		private var _unitPlace:Sprite;
		private var _numPlace:Sprite;
		private var _mask:Bitmap;
		
		private var _numClass:Array = [LuckyNumberAsset0,LuckyNumberAsset1,LuckyNumberAsset2,LuckyNumberAsset3,LuckyNumberAsset4,LuckyNumberAsset5,LuckyNumberAsset6,LuckyNumberAsset7,LuckyNumberAsset8,LuckyNumberAsset9];
		
		public function LuckyDrawPanel()
		{
			super();
		}
		override protected function configUI() : void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,250,150),new Bitmap(new LuckyDrawBgAsset() as BitmapData)),
			]);
			addChild(_bg as DisplayObject);
			
			_btnStart = new MAssetButton1(new LuckyDrawBtnAsset());
			_btnStart.move(189,41);
			addChild(_btnStart);
			
			_numPlace = new Sprite();
			_numPlace.x = 73;
			_numPlace.y = 48;
			addChild(_numPlace);

			_mask = new Bitmap(new LuckyNumberMaskAsset() as BitmapData);
//			_mask.cacheAsBitmap = true; 
			_mask.x = 67;
			_mask.y = 43;
			addChild(_mask);
//			
			_numPlace.mask = _mask;
			initNumber();
			
			initEvent();
		}
		private function initNumber():void
		{
			_tensPlace = new Sprite();
			_numPlace.addChild(_tensPlace);
			
			_unitPlace = new Sprite();
			_unitPlace.x = 54;
			_numPlace.addChild(_unitPlace);
			
			for(var i:int=0; i<40; i++){
				var mc1:Bitmap = new Bitmap(new _numClass[i%10] as BitmapData);
				var mc2:Bitmap = new Bitmap(new _numClass[i%10] as BitmapData);
				mc1.y = mc2.y =  -_tensPlace.height;
				_tensPlace.addChild(mc1);
				_unitPlace.addChild(mc2);
			}
			_tensPlace.y = _unitPlace.y = 0;
		}
		private function initEvent() : void
		{
			_btnStart.addEventListener(MouseEvent.CLICK,startClickHandler);
		}
		private function removeEvent() : void
		{
			_btnStart.removeEventListener(MouseEvent.CLICK,startClickHandler);
		}
		private function startClickHandler(evt:MouseEvent):void
		{
			//startLottery(int(Math.random()*100));
			CopyRandMoneySocketHandler.send();
		}
		public function startLottery(amt:int):void
		{
			if(amt>99) return;
			_btnStart.enabled = false;
			var _t1:int = int(amt/10);
			var _t2:int = int(amt%10);
			TweenLite.to(_tensPlace,4.6,{y:(30+_t1)*64,ease:Circ.easeInOut,onComplete:onTweenComplete});
			TweenLite.to(_unitPlace,4.2,{y:(30+_t2)*64,ease:Circ.easeInOut});
			
		}
		private function onTweenComplete():void
		{	
			_tensPlace.y = 0;
			_unitPlace.y = 0;		
			_btnStart.enabled = true;
			this.visible = false;
			
		}
		override public function dispose() : void
		{
			this.removeEvent();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btnStart)
			{
				_btnStart.dispose();
				_btnStart = null;
			}
			_dragArea = null;
			this._mediator = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}