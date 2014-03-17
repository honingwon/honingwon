package sszt.core.action
{
	public class CallbackAction extends BaseAction
	{
		private var _callback:Function;
		private var _param:Object;
		
		public function CallbackAction(callback:Function,life:int = 0,level:int=0,param:Object = null)
		{
			_callback = callback;
			_param = param;
			super(level);
			_life = life;
		}
		
		override public function set isFinished(value:Boolean):void
		{
			super.isFinished = value;
			if(value)
			{
				if(_callback != null)
				{
					if(_param != null)
					{
						_callback(_param);
					}
					else _callback();
				}
			}
		}
		
		override public function dispose():void
		{
			_callback = null;
			_param = null;
			super.dispose();
		}
	}
}