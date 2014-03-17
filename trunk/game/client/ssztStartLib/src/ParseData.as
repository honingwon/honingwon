package
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;

	public class ParseData
	{
		private static var _ed:IEventDispatcher;
		private static var _index:int;
		private static var _list:Array;
		
		public static function start(ed:IEventDispatcher):void
		{
			_list = [];
			_ed = ed;
			_ed.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		private static function enterFrameHandler(evt:Event):void
		{
			if(_list.length == 0 && _index > 100)
			{
				_ed.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
				_ed = null;
			}
			for(var i:int = _list.length - 1; i >= 0; i--)
			{
				if(_list[i].frame == _index)
				{
					_list[i].parse(_list[i].data);
					_list[i].dispose();
					_list.splice(i,1);
				}
			}
			_index++;
		}
		
		public static function add(data:ByteArray,parse:Function,frame:int):void
		{
			_list.push(new parseInfo(data,parse,frame));
		}
	}
}
import flash.utils.ByteArray;

class parseInfo
{
	public var data:ByteArray;
	public var parse:Function;
	public var frame:int;
	
	public function parseInfo(data:ByteArray,parse:Function,frame:int)
	{
		this.data = data;
		this.parse = parse;
		this.frame = frame;
	}
	
	public function dispose():void
	{
		data = null;
		parse = null;
	}
}