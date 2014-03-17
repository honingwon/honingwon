package sszt.tick
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import sszt.interfaces.layer.ILayerManager;
	import sszt.interfaces.tick.ITick;
	import sszt.constData.CommonConfig;
	import sszt.module.ModuleEventDispatcher;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.*;
	
	public class TickManager implements ITickManager 
	{
		
		public static var enterFrameTick:int;
		
		private var _frameCount:int;
		private var _lastSysTimes:Number;
		private var _lastDt:Number;
		private var _tickTimes:uint;
		private var _lastSec:Number;
		private var _totalTime:Number;
		private var _totalDt:Number;
		private var _ticks:Array;
		private var _startSec:Number;
		
		public function TickManager(layerManager:ILayerManager, enterFrameTick:int=40)
		{
			TickManager.enterFrameTick = enterFrameTick;
			_ticks = [];
			layerManager.getModuleLayer().addEventListener(Event.ENTER_FRAME, tickHandler);
			_startSec = getTimer();
			_lastSec = getTimer();
			_tickTimes = 0;
			_frameCount = 0;
			_lastSysTimes = 0;
			_totalTime = 0;
			_lastDt = 0;
			_totalDt = 0;
		}
		public function removeTick(tick:ITick):void
		{
			var n:int = _ticks.indexOf(tick);
			if (n > -1){
				_ticks.splice(n, 1);
			};
		}
		public function inTick(tick:ITick):Boolean
		{
			return ((_ticks.indexOf(tick) > -1));
		}
		public function addTick(tick:ITick):void
		{
			if (_ticks.indexOf(tick) == -1){
				_ticks.push(tick);
			};
		}
		private function tickHandler(evt:Event):void
		{
			var n:Number = getTimer();
			var dt:Number = (n - _lastSec);
			var dtimes:int = (dt / TickManager.enterFrameTick);
			if (((!(CommonConfig.ISACTIVITY)) && ((((((dt > 100)) && ((dt < 120)))) || ((dt > 500)))))){
				onTick(dtimes, dt);
			} else {
				onTick(1, dt);
			};
			_lastSec = n;
			_frameCount++;
			var tt:Date = new Date();
			var nnn:Number = tt.getTime();
			if (_lastSysTimes == 0){
				_totalTime = (_totalTime + 40);
			} else {
				_totalTime = (_totalTime + (nnn - _lastSysTimes));
			}
			_lastSysTimes = nnn;
			_totalDt = (_totalDt + dt);
			if (_frameCount == 60){
				_frameCount = 0;
				if ((((_totalTime < 2100)) || (((_totalDt - _totalTime) > 300)))){
					ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.FRAMETIME_OVER));
				}
				_totalTime = 0;
				_totalDt = 0;
			}
		}
		private function onTick(times:int, dt:Number):void
		{
			var tmp:ITick;
			var i:int = (_ticks.length - 1);
			while (i >= 0) {
				tmp = _ticks[i];
				if (tmp){
					tmp.update(times, dt);
				}
				i--;
			}
		}
		
	}
}