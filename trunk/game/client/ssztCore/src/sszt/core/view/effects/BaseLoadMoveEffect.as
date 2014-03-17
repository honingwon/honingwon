package sszt.core.view.effects
{
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.utils.Geometry;
	import sszt.core.utils.RotateUtils;
	import sszt.interfaces.loader.IDataFileInfo;
	
	public class BaseLoadMoveEffect extends BaseLoadEffect
	{
		private var _current:int;
		private var _to:int;
		private var _updateScale:Number;
		private var _currentScale:Number;
		private var _dtS:Number;
		
		public function BaseLoadMoveEffect(info:MovieTemplateInfo,distance:int,updateScale:Number = 2)
		{
			_current = 0;
			_to = distance;
			_updateScale = updateScale;
			_currentScale = 1;
			_dtS = (_updateScale - _currentScale) / 10;
			super(info);
		}
		
		override protected function getDataComplete(data:Object):void
		{
			super.getDataComplete(data);
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			for(var i:int = 0; i < times; i++)
			{
				if(Math.abs(_current - _to) <= CommonConfig.EFFECT_STEP_DISTANCE)
				{
					move(_to,0);
					dispose();
				}
				else
				{
					_current += CommonConfig.EFFECT_STEP_DISTANCE;
					var yOff:int = 0;
					if(_dtS != 0)
					{
						if(_currentScale < _updateScale)
						{
							_currentScale += _dtS;
							scaleX = scaleY = _currentScale;
						}
					}
					move(_current,-yOff);
				}
			}
			super.update(times,dt);
			
		}
	}
}