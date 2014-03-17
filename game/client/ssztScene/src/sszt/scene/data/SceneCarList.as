package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	
	public class SceneCarList extends EventDispatcher implements ITick
	{
		private var _carList:Dictionary;
		private var _waitList:Array;
		private var _frameCount:int;
		
		public function SceneCarList()
		{
			_carList = new Dictionary();
			_waitList = [];
		}
		
		public function getCars():Dictionary
		{
			return _carList;
		}
		
		public function getCar(id:Number):BaseSceneCarInfo
		{
			return _carList[id];
		}
		
		public function addSceneCar(car:BaseSceneCarInfo):void
		{
			var id:Number = car.getObjId();
			if(_carList[id] != null)return;
			_carList[id] = car;
			if(id == GlobalData.selfPlayer.userId)
			{
				dispatchEvent(new SceneCarListUpdateEvent(SceneCarListUpdateEvent.ADD_CAR,car));
			}
			else
			{
				_waitList.push(car);
			}
		}
		
		public function removeSceneCar(id:Number):void
		{
			var t:BaseSceneCarInfo = _carList[id];
			if(t)
			{
				delete _carList[id];
				var n:int = _waitList.indexOf(t);
				if(n > -1)
				{
					_waitList.splice(n,1);
				}
				dispatchEvent(new SceneCarListUpdateEvent(SceneCarListUpdateEvent.REMOVE_CAR,t));
			}
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_frameCount ++;
			if(_frameCount == 2)
			{
				_frameCount = 0;
				if(_waitList.length > 0)
				{
					var car:BaseSceneCarInfo = _waitList.shift() as BaseSceneCarInfo;
					dispatchEvent(new SceneCarListUpdateEvent(SceneCarListUpdateEvent.ADD_CAR,car));
				}
			}
		}
		
		public function clear():void
		{
			for each(var i:BaseSceneCarInfo in _carList)
			{
				delete _carList[i.getObjId()];
			}
			_waitList.length = 0;
		}
	}
}