package sszt.loader.resource
{
	import flash.utils.ByteArray;
	
	public class DataFileInfo extends BaseDataFileInfo 
	{
		
		private var _rect:Array;
		private var _data:Array;
		
		public function DataFileInfo(path:String, source:ByteArray)
		{
			this._rect = [];
			this._data = [];
			super(path, source);
		}
		override public function set rects(value:Array):void
		{
			this._rect = value;
		}
		override public function get rects():Array
		{
			return (this._rect);
		}
		override public function set datas(value:Array):void
		{
			this._data = value;
		}
		override public function get datas():Array
		{
			return (this._data);
		}
		override public function dispose():void
		{
			var i:int;
			if (this._data){
				i = 0;
				while (i < this._data.length) {
					if (this._data[i]){
						this._data[i].dispose();
					};
					i++;
				};
				this._data = null;
			};
			super.dispose();
		}
		
	}
}
