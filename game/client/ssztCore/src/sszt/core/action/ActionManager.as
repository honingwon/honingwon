package sszt.core.action
{
	public class ActionManager implements IActionManager
	{
//		protected var _actinos:Vector.<IAction>;
		protected var _actinos:Array;
		protected var _name:String;
		
		public function ActionManager(name:String = "")
		{
			_name = name;
//			_actinos = new Vector.<IAction>();
			_actinos = [];
		}
		
		public function unshiftAction(action:IAction):void
		{
			if(!_actinos)return;
			if(_actinos.length > 0 && _actinos[0].hadDoInit)_actinos.splice(1,0,action);
			else _actinos.unshift(action);
		}
		
		public function addAction(action:IAction):void
		{
			if(!_actinos)return;
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
			action.setManager(this);
			_actinos.push(action);
		}
		
		public function removeAction(action:IAction):void
		{
			if(!_actinos)return;
			var n:int = _actinos.indexOf(action);
			action.doRemove(this);
			_actinos.splice(n,1);
		}
		
//		public function getAction(type:String):Vector.<IAction>
		public function getAction(type:String):Array
		{
//			var list:Vector.<IAction> = new Vector.<IAction>();
			if(!_actinos)return [];
			var list:Array = [];
			for each(var i:IAction in _actinos)
			{
				if(i.type == type)
					list.push(i);
			}
			return list;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(!_actinos)return;
			var len:int = _actinos.length;
			for(var i:int = len - 1; i >= 0; i--)
			{
				if(!_actinos)return;
				if(i >= _actinos.length)continue;
				var action:IAction = _actinos[i];
				if(!action.hadDoPlay && action.canPlay)
					action.play();
				if(!action.isFinished)
					action.update(times,dt);
				if(action.isFinished)
				{
					action.managerClear();
					
					//动作可能在init或update中被删除,所以需要先判断
					//动作可能在执行过程中调dispose,所以需要先判断_actions
					if(_actinos && i < _actinos.length && action == _actinos[i])
					{
						action.doRemove(this);
						_actinos.splice(i,1);
					}
				}
			}
		}
		
		public function dispose():void
		{
			for each(var i:IAction in _actinos)
			{
				i.dispose();
			}
			_actinos = null;
		}
	}
}