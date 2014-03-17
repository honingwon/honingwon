package sszt.scene.components.sceneObjs
{
    import flash.display.*;
    import flash.geom.*;

    public class BloodBars1 extends Bitmap
    {
        private var _lifeBitmap:Bitmap;
        private var _width:Number = 50;
        private var _height:Number = 3;
        private static var _bitmapdataAry:Array;

        public function BloodBars1()
        {
			var bitmapData:BitmapData;
			var ret:Rectangle;
			var i:int;
			super();
			if (_bitmapdataAry == null){
				_bitmapdataAry = [null];
				ret = new Rectangle(0, 0, this._width, this._height);
				i = 0;
				while (i <= 100) {
					bitmapData = new BitmapData(this._width, this._height, true, 0);
					ret.width = this._width;
					ret.height = this._height;
					bitmapData.fillRect(ret, 0x66000000);
					ret.width = this._width * i * 0.01;
					bitmapData.fillRect(ret, 0xFFFF0000);
					_bitmapdataAry[i] = bitmapData;
					i++;
				}
			}
        }

        public function setLife(currentHp:int,totalHp:int) : void
        {
            var pre:int = currentHp / totalHp * 100;
            if (pre > 100)
            {
				pre = 100;
            }
            var bitmapData:BitmapData = _bitmapdataAry[pre];
            if (_bitmapdataAry[pre] != this.bitmapData)
            {
                this.bitmapData = bitmapData;
            }
        }
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}

    }
}
