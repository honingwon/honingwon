package sszt.core.data.bag
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.pet.PetItemInfo;
	
	public class PetBagInfo extends EventDispatcher
	{
		public static const SIZE:int=5;
		public var petDic:Dictionary = new Dictionary();
		
		public function PetBagInfo()
		{
			super();
		}
		
		public function getItemByItemId(itemId:Number):ItemInfo
		{
			var fightPet:PetItemInfo = GlobalData.petList.getFightPet();
			if(fightPet)
			{
				var petList:Array = petDic[fightPet.id];
				for each(var i:ItemInfo in petList)
				{
					if(i && i.itemId == itemId)
					{
						return i;
					}
				}
			}
			return null;
		}
		
		public function updateItems(petId:Number, list:Array):void
		{
			if(!petDic[petId]) petDic[petId] = new Array(SIZE);
			var itemList:Array = petDic[petId];
			var updateItemIdList:Array = [];
			var updateItemPlaceList:Array = [];
			var tmpItemId:Number;
			var place:int;
			for each(var i:ItemInfo in list)
			{
				if(!i.isExist)
				{
					if(itemList[i.place])
					{
						tmpItemId = itemList[i.place].itemId;
						itemList[i.place] = null;
					}
				}
				else
				{
					if(itemList[i.place])
					{
						tmpItemId = itemList[i.place].itemId;
					}
					else
					{
						tmpItemId = i.itemId;
					}
					itemList[i.place] = i;
				}
				updateItemPlaceList.push(i.place);
				updateItemIdList.push(tmpItemId);
			}
			if(updateItemPlaceList.length > 0)dispatchEvent(new PetBagInfoUpdateEvent(PetBagInfoUpdateEvent.ITEM_PLACE_UPDATE,{petId:petId,updateItemPlaceList:updateItemPlaceList}));
			if(updateItemIdList.length > 0)dispatchEvent(new PetBagInfoUpdateEvent(PetBagInfoUpdateEvent.ITEM_ID_UPDATE,updateItemIdList));
		}
	}
}