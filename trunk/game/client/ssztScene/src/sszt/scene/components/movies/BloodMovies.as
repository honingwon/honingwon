package sszt.scene.components.movies
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import sszt.core.caches.NumberCache;
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.tick.ITick;
	
	public class BloodMovies extends Bitmap implements ITick
	{
		private var _value:int;
		private var _type:int;
		private var _sceneX:Number;
		private var _sceneY:Number;
		private var _currentFrame:int;
		private var _isComplete:Boolean;
		
		public function BloodMovies(value:int,type:int)
		{
			_value = value;
			_type = type;
			super();
			init();
		}
		
		private function init():void
		{
//			bitmapData = NumberCache.getNumber(_value,_type);
			if(bitmapData)
				GlobalAPI.tickManager.addTick(this);
		}
		
		public function move(x:Number,y:Number):void
		{
			_sceneX = x;
			_sceneY = y;
			if(bitmapData)
				setPos();
		}
		
		private function setPos():void
		{
			x = _sceneX - bitmapData.width / 2;
			y = _sceneY - bitmapData.height * 2;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			for(var i:int = 0; i < times; i++)
			{
				if(!_isComplete)
				{
					_currentFrame++;
					if(_currentFrame < 10)
					{
						move(_sceneX,_sceneY - 5);
					}
					else if(_currentFrame < 20){}
					else if(_currentFrame < 26)
					{
						move(_sceneX,_sceneY - 8);
						alpha -= 0.2;
					}
					else if(_currentFrame >= 40)
					{
						_isComplete = true;
						dispose();
					}
				}
			}
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			if(parent)parent.removeChild(this);
		}
	}
}