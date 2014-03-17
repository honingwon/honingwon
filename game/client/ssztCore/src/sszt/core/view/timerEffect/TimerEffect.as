package sszt.core.view.timerEffect
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import mhsm.ui.LeftBtnAsset;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.interfaces.tick.ITick;
	
	public class TimerEffect extends Bitmap implements ITick
	{
		private var _time:Number;
		private var _rect:Rectangle;
		private var _startFrom:int;
		private var _startTime:Number;
		/**
		 * 剩余时间
		 */		
		private var _leftTime:Number;
		private var _totalTime:Number;
		private var _currentFrame:int = -1;
		private var _type:int = 0;
		
		public function TimerEffect(time:Number,rect:Rectangle,type:int=0)
		{
			_startFrom = 0;
			_time = Math.ceil(time / 360);
			_rect = rect;
			_leftTime = 0;
			_totalTime = 0;
			_type = type;
			super();
			init();
		}
		
		private function init():void
		{
			this.x = _rect.x;
			this.y = _rect.y;
		}
		
		private function drawBg(index:int):void
		{
			if(index < 0)index = 0;
			else if(index >= 360)index = 359;
			if(_currentFrame != index)
			{
				if(_type == 0)
				{
					bitmapData = GlobalData.timerEffectSource.datas[index];
				}
				else
				{
					bitmapData = GlobalData.timerEffectSource.datas1[index];
				}
				_currentFrame = index;
			}
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			var t:Number = getTimer();
			var tmp:Number = t - _startTime;
			_leftTime = _totalTime - tmp;
			var n:int = tmp / _time;
			if(n >= _startFrom)
			{
				if(n >= 360)
					stop();
				else
					drawBg(n);
			}
		}
		
		public function begin():void
		{
			_startTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
			bitmapData = null;
			_startFrom = 0;
		}
		
		public function setTime(value:Number):void
		{
			stop();
			_time = Math.ceil(value / 360);
			_leftTime = value;
			_totalTime = value;
		}
		
		public function getLeftTime():Number
		{
			return _leftTime;
		}
		
		public function dispose():void
		{
			stop();
			_rect = null;
			if(parent)parent.removeChild(this);
		}
	}
}