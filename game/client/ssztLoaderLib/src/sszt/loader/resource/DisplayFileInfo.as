package sszt.loader.resource
{
	import flash.display.BitmapData;
	import sszt.interfaces.loader.*;
	
	public class DisplayFileInfo implements IDisplayFileInfo 
	{
		
		private var _data:BitmapData;
		private var _path:String;
		
		public function get data():BitmapData
		{
			return (this._data);
		}
		public function set data(value:BitmapData):void
		{
			this._data = value;
		}
		public function get path():String
		{
			return (this._path);
		}
		public function set path(value:String):void
		{
			this._path = value;
		}
		public function dispose():void
		{
			if (this._data){
				this._data.dispose();
				this._data = null;
			};
		}
		
	}
}
