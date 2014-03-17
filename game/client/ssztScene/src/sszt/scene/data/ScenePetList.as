package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.components.sceneObjs.BaseScenePet;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;
	import sszt.scene.events.ScenePetListUpdateEvent;
	
	public class ScenePetList extends EventDispatcher implements ITick
	{
		private var _petList:Dictionary;
		public var self:SelfScenePetInfo;
		private var _waitList:Array;
		private var _frameCount:int;
		
		public function ScenePetList()
		{
			_petList = new Dictionary();
			_waitList = [];
		}
		
		public function getPets():Dictionary
		{
			return _petList;
		}
		
		public function getPet(id:Number):BaseScenePetInfo
		{
			return _petList[id];
		}
		
		public function addScenePet(pet:BaseScenePetInfo):void
		{
			_petList[pet.getObjId()] = pet;
			if(pet.owner == GlobalData.selfPlayer.userId)
			{
				self = pet as SelfScenePetInfo;
				dispatchEvent(new ScenePetListUpdateEvent(ScenePetListUpdateEvent.ADD_PET,pet));
			}
			else
			{
				_waitList.push(pet);
			}
		}
		
		public function removeScenePet(id:Number):void
		{
			var t:BaseScenePetInfo = _petList[id];
			if(t)
			{
				if(self == t)
					self = null;
				var n:int = _waitList.indexOf(t);
				if(n > -1)
				{
					_waitList.splice(n,1);
				}
				delete _petList[id];
				dispatchEvent(new ScenePetListUpdateEvent(ScenePetListUpdateEvent.REMOVE_PET,t));
				t.sceneRemove();
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
					var pet:BaseScenePetInfo = _waitList.shift() as BaseScenePetInfo;
					dispatchEvent(new ScenePetListUpdateEvent(ScenePetListUpdateEvent.ADD_PET,pet));
				}
			}
		}
		
		public function clear():void
		{
			for each(var i:BaseScenePetInfo in _petList)
			{
				delete _petList[i.getObjId()];
			}
			self = null;
			_waitList.length = 0;
		}
	}
}