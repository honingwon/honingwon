package sszt.core.view.effects
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.tick.ITick;
	
	public class BaseCountEffect extends Sprite implements IEffect
	{
		private const SPACE:int = 5;
		
		protected var _info:MovieTemplateInfo;
		private var _currentCount:int = 0;
		private var _start:Boolean;
		private var _currentFrame:int = 200;
		private var _startTime:int;
		private var _effects:Array;
		private var _targetX:Number;
		private var _targetY:Number;
		private var _addChild:Function;
		private var _clearType:int;
		private var _data:Object;
		
		public function BaseCountEffect(info:MovieTemplateInfo,targetX:Number,targetY:Number,addChild:Function)
		{
			_info = info;
			_start = false;
			_effects = [];
			_addChild = addChild;
			_targetX = targetX;
			_targetY = targetY;
			super();
		}
		
		public function play(clearType:int = 1,clearTime:int = 2147483647,priority:int = 3):void
		{
			_clearType = clearType;
			GlobalAPI.loaderAPI.getPackageFile(GlobalAPI.pathManager.getMoviePath(_info.picPath),getDataComplete,_clearType,clearTime,priority);
			_startTime = getTimer();
		}
		
		protected function getDataComplete(data:Object):void
		{
			_data = data;
			_start = true;
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function update(times:int,dt:Number=0.04):void
		{
			if(!_start)return;
			if(getTimer() - _startTime >= _info.time)
			{
				dispose();
				return;
			}
			for(var i:int = 0; i < times; i++)
			{
				_currentFrame++;
				if(_currentFrame >= SPACE)
				{
					
					if(_currentCount < _info.count)
					{
						_currentCount++;
						var effect:BaseEffect = new BaseEffect(_info);
						effect.setData(_data);
						effect.move(_targetX - _info.bound + int(Math.random() * _info.bound) * 2,_targetY - _info.bound + int(Math.random() * _info.bound) * 2);
						try
						{
							_addChild(effect);
						}
						catch(e:Error)
						{
							trace(e.getStackTrace());
						}
						effect.play(_clearType);
						_effects.push(effect);
					}
					_currentFrame = 0;
				}
			}
		}
		
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
		
		public function move(x:Number,y:Number):void
		{
		}
		
		public function dispose():void
		{
			GlobalAPI.loaderAPI.removePackageAQuote(GlobalAPI.pathManager.getMoviePath(_info.picPath));
			GlobalAPI.tickManager.removeTick(this);
			for each(var i:BaseEffect in _effects)
			{
				i.dispose();
			}
			_effects = null;
			_addChild = null;
			_info = null;
			_data = null;
		}
	}
}