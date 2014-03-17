package sszt.core.data.pet
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.item.ItemInfo;
	
	public class PetShowInfo extends EventDispatcher
	{
		public var petShowItemInfo:PetItemInfo;
		public var petShowEquipInfo:Array;
		
		public function PetShowInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function updatePetShowItemInfo(petItemInfo:PetItemInfo):void
		{
			if(petShowItemInfo)
			{
				petShowItemInfo = null;
			}
			petShowItemInfo = petItemInfo;
			dispatchEvent(new PetShowInfoUpdateEvent(PetShowInfoUpdateEvent.PET_SHOW_INFO_LOAD_COMPLETE));
		}
		
		public function updateItems(list:Array):void
		{
			petShowEquipInfo = new Array(5);
			var tmpItemId:Number;
			var place:int;
			for each(var i:ItemInfo in list)
			{
				if(!i.isExist)
				{
					if(petShowEquipInfo[i.place])
					{
						tmpItemId = petShowEquipInfo[i.place].itemId;
						petShowEquipInfo[i.place] = null;
					}
				}
				else
				{
					if(petShowEquipInfo[i.place])
					{
						tmpItemId = petShowEquipInfo[i.place].itemId;
					}
					else
					{
						tmpItemId = i.itemId;
					}
					petShowEquipInfo[i.place] = i;
				}
			}
		}
	}
}