package sszt.core.action
{
	public class QueueActionManager extends ActionManager
	{
		public function QueueActionManager(name:String = "")
		{
			super(name);
		}
		
		override public function addAction(action:IAction):void
		{
			if(_actinos.indexOf(action) != -1)return;
			for(var i:int = 0; i < _actinos.length; i++)
			{
				if(_actinos[i].beIgnore(action))return;
				else if(_actinos[i].replace(action))
				{
					_actinos[i].dispose();
					_actinos[i] = action;
					return;
				}
			}
			_actinos.push(action);
		}
		
		override public function update(times:int,dt:Number = 0.04):void
		{
			if(_actinos.length > 0)
			{
				var action:IAction = _actinos[0];
				if(!action.hadDoPlay && action.canPlay)
					action.play();
				if(!action.isFinished)
					action.update(times,dt);
				if(action.isFinished)
				{
					action.managerClear();
					_actinos.shift();
				}
			}
		}
	}
}