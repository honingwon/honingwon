package sszt.core.data.mounts
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MountsItemList extends EventDispatcher
	{
		private var _mountsList:Array;
		
		public function MountsItemList()
		{
			_mountsList = [];
		}
		
		public function get mountsCount():int
		{
			return _mountsList.length;
		}
		
		public function addMounts(mounts:MountsItemInfo):void
		{
			_mountsList.push(mounts);
			dispatchEvent(new MountsListUpdateEvent(MountsListUpdateEvent.ADD_MOUNTS,mounts));
		}
		
		public function removeMounts(id:Number):void
		{
			var item:MountsItemInfo;
			for(var i:int = 0;i<_mountsList.length;i++)
			{
				if(id == _mountsList[i].id)
				{
					item = _mountsList.splice(i,1)[0];
					dispatchEvent(new MountsListUpdateEvent(MountsListUpdateEvent.REMOVE_MOUNTS,item));
					break;
				}
			}
		}
		
		public function getList():Array
		{
			return _mountsList;
		}
		
		public function getMountsById(id:Number):MountsItemInfo
		{
			for(var i:int = 0;i<_mountsList.length;i++)
			{
				if(id == _mountsList[i].id)
				{
					return _mountsList[i];
				}
			}
			return null;
		}
		
//		public function update(list:Vector.<PetItemInfo>):void
		public function update(list:Array):void
		{
			_mountsList = list;
		}
		
		public function hasFightPet():Boolean
		{
			var result:Boolean = false;
			for(var i:int = 0;i<_mountsList.length;i++)
			{
				if((_mountsList[i].state & 1) > 0)
					return true;
			}
			return result;
		}
		
		public function getFightPet():MountsItemInfo
		{
			for each(var i:MountsItemInfo in _mountsList)
			{
				if((i.state & 1) > 0)return i;
			}
			return null;
		}
	}
}