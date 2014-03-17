package sszt.scene.actions
{
	import flash.display.DisplayObject;
	
	import sszt.core.action.BaseAction;
	import sszt.core.data.GlobalAPI;
	
	public class ShakeAction extends BaseAction
	{
		private var _skakeObjects:DisplayObject;
		private var _shakeOffsetX:Array;
		private var _shakeOffsetY:Array;
		private var _currentIndex:int;
		private var _hasOffsetX:int;
		private var _hasOffsetY:int;
		
		public function ShakeAction()
		{
			super(0);
			_shakeOffsetX = [0,0,0,0,0,0,0];
//			_shakeOffsetY = [-15,30,-15,15,-30,15];
			_shakeOffsetY = [-10,10,0,-4,4,-4,4];
		}
		
		override public function configure(...parameters):void
		{
			super.configure(parameters);
			isFinished = false;
			_skakeObjects = parameters[0] as DisplayObject;
			_skakeObjects.x -= _hasOffsetX;
			_skakeObjects.y -= _hasOffsetY;
			_hasOffsetX = _hasOffsetY = 0;
			_currentIndex = 0;
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			var nx:Number = _skakeObjects.x;
			var ny:Number = _skakeObjects.y;
			for(var i:int = 0; i < times; i++)
			{
				if(!isFinished)
				{
					if(_currentIndex > _shakeOffsetX.length - 1 || !_skakeObjects)
					{
						doStop();
					}
					else
					{
						nx += _shakeOffsetX[_currentIndex];
						ny += _shakeOffsetY[_currentIndex];
						_hasOffsetX += _shakeOffsetX[_currentIndex];
						_hasOffsetY += _shakeOffsetY[_currentIndex];
						_currentIndex++;
					}
				}
			}
			_skakeObjects.x = nx;
			_skakeObjects.y = ny;
		}
		
		private function doStop():void
		{
			isFinished = true;
			GlobalAPI.tickManager.removeTick(this);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}