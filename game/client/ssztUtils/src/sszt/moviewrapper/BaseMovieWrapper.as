package sszt.moviewrapper
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import sszt.interfaces.moviewrapper.*;
	
	public class BaseMovieWrapper extends Bitmap implements IMovieWrapper 
	{
		
		private var _stopFrame:int;
		private var _sourceBitmapdata:BitmapData;
		private var _frameScripts:Dictionary;
		private var _timer:Timer;
		private var _currentFrame:int;
		protected var _rectangle:Rectangle;
		private var _prevFrame:int;
		private var _tick:int;
		protected var _movieInfo:MovieWrapperInfo;
		
		public function BaseMovieWrapper(sourceBitmapData:BitmapData, movieInfo:MovieWrapperInfo)
		{
			_tick = MovieManager.defaultTick;
			_frameScripts = new Dictionary();
			_sourceBitmapdata = sourceBitmapData;
			_movieInfo = movieInfo;
			_prevFrame = -1;
			_stopFrame = -1;
			initBitmapData();
			initRectangle();
			smoothing = true;
		}
		public function stop():void
		{
			clearEnterFrame();
			clearTimer();
		}
		public function get totalFrame():int
		{
			return (_movieInfo.totalFrames);
		}
		private function enterFrameHandler(evt:Event):void
		{
			tickHandler();
		}
		public function gotoAndStop(frame:int):void
		{
			currentFrame = frame;
			stop();
			print();
		}
		private function clearTimer():void
		{
			if (_timer){
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			};
			_timer = null;
		}
		public function dispose():void
		{
			_frameScripts = null;
			clearEnterFrame();
			clearTimer();
			if (_sourceBitmapdata){
				_sourceBitmapdata = null;
			};
			_movieInfo = null;
			if (parent){
				parent.removeChild(this);
			};
		}
		public function get currentFrame():int
		{
			return (_currentFrame);
		}
		private function clearEnterFrame():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		public function get tick():int
		{
			return (_tick);
		}
		protected function initBitmapData():void
		{
			if (_movieInfo == null){
				return;
			};
			bitmapData = new BitmapData(_movieInfo.mcWidth, _movieInfo.mcHeight, true, 0);
		}
		public function play(updateImmediately:Boolean=false, stopAt:int=-1):void
		{
			if (_movieInfo == null){
				return;
			};
			_stopFrame = stopAt;
			if (updateImmediately){
				tickHandler();
			};
			clearTimer();
			if (_tick == MovieManager.defaultTick){
				if (!(hasEventListener(Event.ENTER_FRAME))){
					addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				};
			} else {
				clearEnterFrame();
				_timer = new Timer(_tick);
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				_timer.start();
			};
		}
		public function setSource(source:BitmapData):void
		{
			_sourceBitmapdata = source;
		}
		public function addFrameScript(frame:int, script:Function):void
		{
			_frameScripts[frame] = script;
		}
		protected function initRectangle():void
		{
			if (_movieInfo == null){
				return;
			};
			_rectangle = new Rectangle(0, 0, _movieInfo.mcWidth, _movieInfo.mcHeight);
		}
		private function timerHandler(evt:TimerEvent):void
		{
			tickHandler();
		}
		public function gotoAndPlay(frame:int, updateImmediately:Boolean=false):void
		{
			if (_movieInfo == null){
				return;
			};
			currentFrame = frame;
			play(updateImmediately);
		}
		public function set tick(value:int):void
		{
			_tick = value;
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function clear():void
		{
			bitmapData.fillRect(new Rectangle(0, 0, bitmapData.width, bitmapData.height), 0);
		}
		protected function print():void
		{
			if ((((bitmapData == null)) || ((_movieInfo == null)))){
				return;
			};
			if (currentFrame == _prevFrame){
				return;
			};
			_prevFrame = currentFrame;
			_rectangle.x = (((currentFrame - 1) % _movieInfo.columns) * _movieInfo.mcWidth);
			_rectangle.y = (Math.floor(((currentFrame - 1) / _movieInfo.columns)) * _movieInfo.mcHeight);
			bitmapData.copyPixels(_sourceBitmapdata, _rectangle, new Point(0, 0));
		}
		public function stopAndClear():void
		{
			stop();
			clear();
		}
		public function set currentFrame(value:int):void
		{
			if (_movieInfo == null){
				return;
			};
			if (value > totalFrame){
				value = totalFrame;
			};
			if (value < 1){
				value = 1;
			};
			if (value == _currentFrame){
				return;
			};
			_currentFrame = value;
		}
		protected function tickHandler():void
		{
			print();
			if (((!((_stopFrame == -1))) && ((_stopFrame == _currentFrame)))){
				stop();
				_stopFrame = -1;
				return;
			};
			if (_frameScripts[_currentFrame] != null){
				_frameScripts[_currentFrame]();
			};
			if (_movieInfo){
				nextFrame();
			};
		}
		protected function nextFrame():void
		{
			if (currentFrame == totalFrame){
				currentFrame = 1;
			} else {
				currentFrame = (currentFrame + 1);
			};
		}
		
	}
}