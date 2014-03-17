package sszt.core.action
{
	public class BaseAction implements IAction
	{
		protected var _life:int;
		protected var _level:int;
		protected var _isfinish:Boolean;
		protected var _hadDoPlay:Boolean;
		protected var _manager:IActionManager;
		protected var _playDelay:int;
		
		
		public function BaseAction(level:int = 0)
		{
			_level = 0;
			_playDelay = 0;
			_isfinish = false;
			_life = int.MAX_VALUE;
		}
		
		public function doAction():void
		{
			
		}
		
		public function play():void
		{
			_hadDoPlay = true;
		}
		
		public function get hadDoPlay():Boolean
		{
			return _hadDoPlay;
		}
		
		public function get canPlay():Boolean
		{
			return _playDelay <= 0;
		}
		
		public function get isFinished():Boolean
		{
			return _isfinish;
		}
		public function set isFinished(value:Boolean):void
		{
			_isfinish = value;
		}
		
		public function doRemove(manager:IActionManager):void
		{
			
		}
		
		public function get type():String
		{
			return "baseAction";
		}
		
		public function setManager(manager:IActionManager):void
		{
			_manager = manager;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function replace(action:IAction):Boolean
		{
			return false;
		}
		
		public function beIgnore(action:IAction):Boolean
		{
			return false;
		}
		
		public function skip():void
		{
			isFinished = true;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_playDelay > 0)
			{
				_playDelay -= times;
			}
			if(_life != int.MAX_VALUE)
			{
				_life -= times;
				if(_life <= 0)
				{
					isFinished = true;
				}
			}
		}
		
		public function configure(...args):void
		{
		}
		
		public function managerClear():void
		{
			dispose();
		}
		
		public function dispose():void
		{
			isFinished = true;
			if(_manager)
			{
				_manager.removeAction(this);
				_manager = null;
			}
		}
	}
}