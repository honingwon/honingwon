package sszt.scene.data.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class EventList extends EventDispatcher
	{
//		private var _list:Vector.<String>;
		private var _list:Array;
		
		public function EventList()
		{
//			_list = new Vector.<String>();
			_list = [];
		}
		
		public function addEvent(mes:String):void
		{
			_list.push(mes);
			if(_list.length > 100)_list.shift();
			dispatchEvent(new EventListUpdateEvent(EventListUpdateEvent.ADDEVENT,mes));
		}
		
//		public function getList():Vector.<String>
		public function getList():Array
		{
			return _list;
		}
	}
}