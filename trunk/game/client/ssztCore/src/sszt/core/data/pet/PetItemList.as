package sszt.core.data.pet
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PetItemList extends EventDispatcher
	{
//		private var _petList:Vector.<PetItemInfo>;
		private var _petList:Array;
		
		public function PetItemList()
		{
//			_petList = new Vector.<PetItemInfo>();
			_petList = [];
		}
		
		public function get petCount():int
		{
			return _petList.length;
		}
		
		public function getList():Array
		{
			return _petList;
		}
		
		public function addPet(pet:PetItemInfo):void
		{
			_petList.push(pet);
			dispatchEvent(new PetListUpdateEvent(PetListUpdateEvent.ADD_PET,pet));
		}
		
		public function removePet(id:Number):void
		{
			var item:PetItemInfo;
			for(var i:int = 0;i<_petList.length;i++)
			{
				if(id == _petList[i].id)
				{
					item = _petList.splice(i,1)[0];
					dispatchEvent(new PetListUpdateEvent(PetListUpdateEvent.REMOVE_PET,item));
					break;
				}
			}
		}
		
		public function getPetById(id:Number):PetItemInfo
		{
			for(var i:int = 0;i<_petList.length;i++)
			{
				if(id == _petList[i].id)
				{
					return _petList[i];
				}
			}
			return null;
		}
		
//		public function update(list:Vector.<PetItemInfo>):void
		public function update(list:Array):void
		{
			_petList = list;
		}
		
		public function hasFightPet():Boolean
		{
			var result:Boolean = false;
			for(var i:int = 0;i<_petList.length;i++)
			{
				if((_petList[i].state & 1) > 0)
					return true;
			}
			return result;
		}
		
		public function getFightPet():PetItemInfo
		{
			for each(var i:PetItemInfo in _petList)
			{
				if((i.state & 1) > 0)return i;
			}
			return null;
		}
	}
}