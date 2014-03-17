package sszt.core.view.effects
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.PkgRecord;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.pool.PoolManager;
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.pool.IPoolManager;
	import sszt.interfaces.pool.IPoolObj;
	
	public class BaseCountEffectPool extends Sprite implements IEffect,IPoolObj
	{
		private const SPACE:int = 25;
		
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
		private var _data:IDataFileInfo;
		private var _path:String;
		private var _manager:IPoolManager;
		
		public function BaseCountEffectPool()
		{
			_start = false;
			_effects = [];
			super();
		}
		
		public function play(clearType:int = 1,clearTime:int = 2147483647,priority:int = 3):void
		{
			_clearType = clearType;
			_path = GlobalAPI.pathManager.getMoviePath(_info.picPath);
			PkgRecord.getFile(_path,int(_info.picPath),LayerType.EFFECT,0,getDataComplete);
			_startTime = getTimer();
		}
		
		protected function getDataComplete(data:IDataFileInfo):void
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
				collect();
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
						var effect:BaseEffectPool = CommonEffectPoolManager.baseEffectManager.getObj([_info,_data]) as BaseEffectPool;
						effect.move(_targetX - _info.bound + int(Math.random() * _info.bound) * 2,_targetY - _info.bound + int(Math.random() * _info.bound) * 2);
						try
						{
							_addChild(effect);
						}
						catch(e:Error){trace(e.getStackTrace());}
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
		
		public function setManager(manager:IPoolManager):void
		{
			_manager = manager;
		}
		public function collect():void
		{
			if(_manager)
			{
				_manager.removeObj(this);
			}
		}
		
		public function reset(param:Object):void
		{
			_info = param[0];
			_targetX = param[1];
			_targetY = param[2];
			_addChild = param[3];
			if(_info.addMode == 1)
			{
				blendMode = BlendMode.ADD;
			}
			else if(_info.addMode == 0)
			{
				blendMode = BlendMode.NORMAL;
			}
			_currentFrame = 200;
			_currentCount = 0;
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			for each(var i:BaseEffectPool in _effects)
			{
				i.collect();
			}
			if(parent)parent.removeChild(this);
			_effects = null;
			_addChild = null;
			_info = null;
			_manager = null;
		}
		
		public function poolDispose():void
		{
			dispose();
		}
	}
}