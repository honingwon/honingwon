package sszt.core.data
{
	public class SharedObjectInfo
	{
		public var key:String;
		public var value:*;
		private var _record:*;
		
		public function SharedObjectInfo(key:String,value:* = null)
		{
			this.key = key;
			this.value = value;
			_record = value;
		}
		
		public function reset():void
		{
			value = _record;
		}
		
		public function update():void
		{
			_record = value;
		}
	}
}