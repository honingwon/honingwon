package sszt.club.datas.armyInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import sszt.club.events.ClubArmyInfoUpdateEvent;
	
	public class ClubArmyInfo extends EventDispatcher
	{
		public var armyList:Dictionary;
		public var enounce:String;
		
		public function ClubArmyInfo(target:IEventDispatcher=null)
		{
			armyList = new Dictionary();
			super(target);
		}
		
//		public function update(list:Vector.<ClubArmyItemInfo>,enounce:String):void
		public function update(list:Array,enounce:String):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				if(list[i].isExist ==  false)
					armyList[list[i].armyId] = null;
				else
					armyList[list[i].armyId] = list[i];
			}
			this.enounce = enounce;
			dispatchEvent(new ClubArmyInfoUpdateEvent(ClubArmyInfoUpdateEvent.ARMYINFO_UPDATE));
		}
		
		public function getIsArmyLeader(name:String):Boolean
		{
			for each(var info:ClubArmyItemInfo in armyList)
			{
				if(info)
				{
					if(info.masterName == name)return true;
				}
			}
			return false;
		}
		
		public function dispose():void
		{
			armyList = null;
		}
	}
}