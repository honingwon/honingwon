package sszt.core.view.effects
{
	import sszt.constData.CommonConfig;

	public class BaseLoadMoveEffectPool extends BaseLoadEffectPool
	{
		private var _current:int;
		private var _to:int;
		private var _updateScale:Number;
		private var _currentScale:Number;
		private var _dtS:Number;
		
		public function BaseLoadMoveEffectPool()
		{
			super();
		}
		
		/**
		 * [MovieTemplateInfo]
		 * @param param
		 * 
		 */		
		override public function reset(param:Object):void
		{
			super.reset(param);
			_current = 0;
			_to = param[1];
			_updateScale = param[2];
			_currentScale = 1;
			_dtS = (_updateScale - _currentScale) / 10;
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			for(var i:int = 0; i < times; i++)
			{
				if(Math.abs(_current - _to) <= CommonConfig.EFFECT_STEP_DISTANCE)
				{
					move(_to,0);
					collect();
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
			if(_info == null)return;
			super.update(times,dt);
		}

	}
}