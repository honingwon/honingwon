package sszt.core.view.effects
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.loader.IPackageFileData;
	import sszt.interfaces.pool.IPoolManager;
	import sszt.interfaces.tick.ITick;
	
	public class BaseEffect extends Bitmap implements IEffect
	{
		protected var _info:MovieTemplateInfo;
		//当前侦
		private var _currentFrame:int;
		//当前索引
		private var _currentIndex:int = -1;
//		protected var _data:IDataFileInfo;
		//[datas,path]
		protected var _data:Object;
		private var _sceneX:Number = 0;
		private var _sceneY:Number = 0;
		private var _startTime:Number;
		/**
		 * 清除类型,如果为never，则对象为多次复用，dispose的时候不删除info和data
		 */		
		private var _clearType:int;
		
		public function BaseEffect(info:MovieTemplateInfo)
		{
			_info = info;
			super();
		}
		
//		public function setData(data:IDataFileInfo):void
//		{
//			_data = data;
//			if(_info.addMode == 1)
//			{
//				blendMode = BlendMode.ADD;
//			}
//		}
		public function setData(data:Object):void
		{
			_data = data;
			if(_info == null)
				return;
			if(_info.addMode == 1)
			{
				blendMode = BlendMode.ADD;
			}
//			if(_info.scaleX != 0 &&  _info.scaleX != 1)
//			{
//				this.scaleX = _info.scaleX / 100;
//			}
//			if(_info.scaleY != 0 && _info.scaleY != 1)
//			{
//				this.scaleY = _info.scaleY / 100;
//			}
		}
		
		public function play(clearType:int = 1,clearTime:int = 2147483647,priority:int = 3):void
		{
			_clearType = clearType;
			_startTime = getTimer();
			_currentFrame = 0;
			GlobalAPI.tickManager.addTick(this);
		}
		public function stop():void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_info == null)return;
			if(_info.time != -1)
			{
				if(getTimer() - _startTime >= _info.time)
				{
					dispose();
					return;
				}
			}
			if(_data == null || _data.datas == null)
			{
				dispose();
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
					dispose();
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
		
		public function move(x:Number,y:Number):void
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
		
		public function dispose():void
		{
			stop();
			if(_clearType != SourceClearType.NEVER)
			{
				_info = null;
				_data = null;
			}
			if(parent)parent.removeChild(this);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}