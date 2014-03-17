package sszt.furnace.data.lastConfig
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class FurnaceLastConfigInfo extends EventDispatcher
	{
		private var _configItemList:Array;
		public var isBind:Boolean;
		public function FurnaceLastConfigInfo()
		{
			_configItemList = [];
		}
		
		public function clearList():void
		{
			_configItemList.length = 0;
		}
		
		public function addToList(argInfo:ConfigItemInfo):void
		{
			_configItemList.push(argInfo);
		}

		public function get configItemList():Array
		{
			return _configItemList;
		}

		public function set configItemList(value:Array):void
		{
			_configItemList = value;
		}

	}
}