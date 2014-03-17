package sszt.core.data.personal
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.personal.item.PersonalDynamicItemInfo;
	
	public class PersonalFriendInfo extends EventDispatcher
	{
		private var _itemInfoList:Array;
		public function PersonalFriendInfo(target:IEventDispatcher=null)
		{
			super(target);
			_itemInfoList = [];
		}
		
		public function addToList(argInfo:PersonalDynamicItemInfo):void
		{
			_itemInfoList.push(argInfo);
			dispatchEvent(new PersonalInfoUpdateEvents(PersonalInfoUpdateEvents.PERSONAL_FRIENDINFO_UPDATE,argInfo));
		}
		
		public function clearList():void
		{
			_itemInfoList.length = 0;
		}

		public function get itemInfoList():Array
		{
			return _itemInfoList;
		}

		public function set itemInfoList(value:Array):void
		{
			_itemInfoList = value;
		}

	}
}