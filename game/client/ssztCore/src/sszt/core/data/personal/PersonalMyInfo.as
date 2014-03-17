package sszt.core.data.personal
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	public class PersonalMyInfo extends EventDispatcher
	{
		public var serverId:int;				//服务器ID
		public var userId:Number;
		public var nick:String;
		public var starId:int;
		public var provinceId:int;
		public var cityId:int;
		public var mood:String;
		public var introduce:String;
		public var winNum:int;
		public var failNum:int;
		public var isCanGetRewards:Boolean;
		public var headIndex:int;
		public var oldIndex:int;
		
		public function PersonalMyInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			dispatchEvent(new PersonalInfoUpdateEvents(PersonalInfoUpdateEvents.PERSONAL_MY_INFO_UPDATE));
		}
		
		public function updateHead(argHeadIndex:int):void
		{
			headIndex = argHeadIndex;
			dispatchEvent(new PersonalInfoUpdateEvents(PersonalInfoUpdateEvents.PERSONAL_MY_HEAD_UPDATE));
		}
	}
}