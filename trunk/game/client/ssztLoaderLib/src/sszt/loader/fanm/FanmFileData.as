package sszt.loader.fanm
{
	import flash.display.BitmapData;
	import sszt.interfaces.loader.*;
	
	public class FanmFileData implements IPackageFileData 
	{
		
		private var _data:BitmapData;
		private var _x:Number;
		private var _y:Number;
		
		public function FanmFileData(bd:BitmapData, x:Number, y:Number)
		{
			this._data = bd;
			this._x = x;
			this._y = y;
		}
		public function getBD():BitmapData
		{
			return this._data;
		}
		public function getX():Number
		{
			return this._x;
		}
		public function getY():Number
		{
			return this._y;
		}
		public function dispose():void
		{
			if (this._data){
				this._data.dispose();
			}
			this._data = null;
		}
		
	}
}
