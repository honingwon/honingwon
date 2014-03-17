package sszt.core.pool
{
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.pool.IPoolManager;
	import sszt.interfaces.pool.IPoolObj;
	
	public class PoolManager implements IPoolManager
	{
		private var _sourceClass:Class;
		private var _objList:Array;
		private var _maxCount:int;
		
		public function PoolManager(maxCount:int = 20)
		{
			_maxCount = maxCount;
			_objList = [];
		}
		
		public function setClass(cl:Object):void
		{
			if(cl is String)
			{
				_sourceClass = GlobalAPI.loaderAPI.getClassByPath(String(cl));
			}
			else
			{
				_sourceClass = cl as Class;
			}
		}
		
		public function getObj(param:Object):IPoolObj
		{
			if(_objList.length > 0)
			{
				_objList[0].reset(param);
				_objList[0].setManager(this);
				return _objList.shift();
			}
			else
			{
				if(_sourceClass != null)
				{
					var obj:IPoolObj = new _sourceClass();
					obj.setManager(this);
					obj.reset(param);
					return obj;
				}
			}
			return null;
		}
		
		public function removeObj(obj:IPoolObj):void
		{
			if(_objList.length < _maxCount)
			{
				obj.dispose();
				_objList.push(obj);
			}
			else
			{
				obj.dispose();
			}
		}
		
		public function getItemCount():int
		{
			return _objList.length;
		}
		
		public function clear():void
		{
			for each(var i:IPoolObj in _objList)
			{
				i.dispose();
			}
			_objList.length = 0;
		}
		
		public function dispose():void
		{
			for(var i:int = _objList.length; i > 0; i--)
			{
				_objList[i].poolDispose();
			}
			_objList = null;
		}
	}
}