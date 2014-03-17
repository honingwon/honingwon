package sszt.personal.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.personal.events.PersonalPartUpdateEvents;
	
	public class PersonalPartLuckyInfo extends EventDispatcher
	{
		public var luckyTemplateIdList:Array;
		public var selectTemplateId:int = -1;
		public function PersonalPartLuckyInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function updateLuckyList():void
		{
			dispatchEvent(new PersonalPartUpdateEvents(PersonalPartUpdateEvents.LUCKYLIST_UPDATE));
		}
		
		public function updateSelect():void
		{
			dispatchEvent(new PersonalPartUpdateEvents(PersonalPartUpdateEvents.LUCKYSELECT_UPDATE));
		}
		
//		public function getSelectIndex():int
//		{
//			return luckyTemplateIdList.indexOf(selectTemplateId);
//		}
	}
}