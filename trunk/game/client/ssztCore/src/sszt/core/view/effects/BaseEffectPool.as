package sszt.core.view.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.loader.IPackageFileData;
	import sszt.interfaces.pool.IPoolManager;
	import sszt.interfaces.pool.IPoolObj;
	
	public class BaseEffectPool extends Bitmap implements IEffect, IPoolObj
	{
		/**
		 * 动画模版
		 */		
		protected var _info:MovieTemplateInfo;
		//当前侦
		protected var _currentFrame:int;
		//当前索引
		protected var _currentIndex:int = -1;
		/**
		 * 动画数据
		 */		
		protected var _data:Object;
		private var _sceneX:Number = 0;
		private var _sceneY:Number = 0;
		private var _startTime:Number;
		protected var _poolManager:IPoolManager;
		
		public function BaseEffectPool()
		{
			super();
		}
		
		public function play(clearType:int=1,clearTime:int = 2147483647,priority:int = 3):void
		{
			_startTime = getTimer();
			_currentFrame = 0;
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
		
		public function move(x:Number, y:Number):void
		{
			_sceneX = x;
			_sceneY = y;
		}
		public function get sceneX():Number
		{
			return _sceneX;
		}
		public function get sceneY():Number
		{
			return _sceneY;
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			if(_info == null)return;
			if(_info.time != -1)
			{
				if(getTimer() - _startTime >= _info.time)
				{
					collect();
					return;
				}
			}
			if(_data == null || _data.datas == null)
			{
				collect();
				return;
			}
			var tmp:int = _info.frames[_currentFrame];
			if(_currentIndex != tmp && _data.datas[tmp])
			{
				_currentIndex = tmp;
				if(_currentIndex >= _data.datas.length)_currentIndex = _data.datas.length - 1;
				if(_currentIndex < 0)_currentIndex = 0;
				bitmapData = (_data.datas[_currentIndex] as IPackageFileData).getBD();
			}
			setToPos();
			_currentFrame+= times;
			if(_currentFrame >= _info.frames.length)
			{
				if(_info.time == -1)
				{
					collect();
				}
				else
				{
					_currentFrame = 0;
				}
			}
			
		}
		
		protected function setToPos():void
		{
			x = int(-_data.datas[_currentIndex].getX()) + _sceneX;
			y = int(-_data.datas[_currentIndex].getY()) + _sceneY;
		}
		
		public function setManager(manager:IPoolManager):void
		{
			_poolManager = manager;
		}
		/**
		 * [MovieTemplateInfo,IDataFileInfo]
		 * @param param
		 * 
		 */		
		public function reset(param:Object):void
		{
			_info = param[0];
			_data = param[1];
			if(_info.addMode == 1)
			{
				blendMode = BlendMode.ADD;
			}
			else if(_info.addMode == 0)
			{
				blendMode = BlendMode.NORMAL;
			}
			_currentFrame = 0;
			_currentIndex = -1;
		}
		
		public function collect():void
		{
			if(_poolManager)
			{
				_poolManager.removeObj(this);
			}
		}
		
		public function dispose():void
		{
			_info = null;
			_data = null;
			_poolManager = null;
			stop();
			bitmapData = null;
			if(parent)parent.removeChild(this);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function poolDispose():void
		{
			dispose();
		}
	}
}