package sszt.module
{
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class ModuleTransitionView 
	{
		
		private var _movie:Sprite;
		private var _state:int = 0;
		private var _container:DisplayObjectContainer;
		private var _callback:Function;
		
		public function ModuleTransitionView(container:DisplayObjectContainer)
		{
			_container = container;
			_movie = new Sprite();
			_movie.graphics.beginFill(0, 1);
			_movie.graphics.drawRect(0, 0, 3000, 3000);
			_movie.graphics.endFill();
			_movie.alpha = 0;
		}
		public function stop():void
		{
			_movie.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (_movie.parent)
			{
				_movie.parent.removeChild(_movie);
			}
		}
		private function enterFrameHandler(evt:Event):void
		{
			if (_state == 0){
				_movie.alpha = (_movie.alpha + 0.4);
				if (_movie.alpha > 0.9)
				{
					_state = 1;
					if (_callback != null)
					{
						_callback();
					}
				}
			} 
			else 
			{
				_movie.alpha = (_movie.alpha - 0.4);
				if (_movie.alpha < 0.1)
				{
					_state = 0;
					_movie.alpha = 0;
					stop();
				}
			}
		}
		public function start(callback:Function):void
		{
			_callback = callback;
			_state = 0;
			_movie.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_movie.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_container.addChild(_movie);
		}
		
	}
}
