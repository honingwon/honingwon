package com.codeTooth.actionscript.lang.utils.display.bitmap
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 位图Scale9Grid
	 */	
	public class Scale9GridBitmap extends Sprite 
																	implements IDestroy
	{
		private var _cornerWidth:Number;
		private var _cornerHeight:Number;
		private var _slicingGrapincs:Array;
		private var _width:Number;
		private var _height:Number;
		
		public function Scale9GridBitmap(bitmapData:BitmapData, cornerWidth:Number = 1, cornerHeight:Number = 1) 
		{
			if(bitmapData == null)
			{
				throw new NullPointerException("Null bitmapData");
			}
			
			_cornerHeight = cornerHeight;
			_cornerWidth = cornerWidth;
			_slicingGrapincs = new Array();
			
			_width = bitmapData.width;
			_height = bitmapData.height;
			
			if(_cornerWidth * 2 >= _width)
			{
				throw new IllegalParameterException("Illegal cornerWidth \"" + _cornerWidth + "\"");
			}
			
			if(_cornerHeight * 2 >= _height)
			{
				throw new IllegalParameterException("Illegal cornerHeight \"" + _cornerHeight + "\"");
			}
			
			splicegraphic(bitmapData);
			setSize(_width, _height);
		}
		override public function set height(height:Number):void
		{
			_height = height;
			setSize(_width, _height);
		}
		override public function get height():Number
		{
			return _height;
		}
		override public function set width(width:Number):void
		{
			_width = width;
			setSize(_width, height);
		}
		override public function get width():Number
		{
			return _width;
		}
		public function setSize(width:Number, height:Number):void
		{
			var bitmap:Bitmap;
			
			bitmap = getSlice(UP_LEFT);
			bitmap.x = 0;
			bitmap.y = 0;
			
			bitmap = getSlice(UP);
			bitmap.x = _cornerWidth;
			bitmap.y = 0;
			bitmap.width = width - _cornerWidth * 2;
			
			bitmap = getSlice(UP_RIGHT);
			bitmap.x = width - _cornerWidth;
			bitmap.y = 0;
			
			bitmap = getSlice(LEFT);
			bitmap.x = 0;
			bitmap.y = _cornerHeight;
			bitmap.height = height - _cornerHeight * 2;
			
			bitmap = getSlice(CENTER);
			bitmap.x = _cornerWidth;
			bitmap.y = _cornerHeight;
			bitmap.width = width - _cornerWidth * 2;
			bitmap.height = height - _cornerHeight * 2;
			
			bitmap = getSlice(RIGHT);
			bitmap.x = width - _cornerWidth;
			bitmap.y = _cornerHeight;
			bitmap.height = height - _cornerHeight * 2;
			
			bitmap = getSlice(DOWN_LEFT);
			bitmap.x = 0;
			bitmap.y = height - _cornerHeight;
			
			bitmap = getSlice(DOWN);
			bitmap.x = _cornerWidth;
			bitmap.y = height - _cornerHeight;
			bitmap.width = width - _cornerWidth * 2;
			
			bitmap = getSlice(DOWN_RIGHT);
			bitmap.x = width - _cornerWidth;
			bitmap.y = height - _cornerHeight;
		}
		
		public function destroy():void
		{	
			var slice:Bitmap = null;
			var numberSlice:int = _slicingGrapincs.length;
			for(var i:int = numberSlice - 1; i >= 0; i--)
			{
				slice = Bitmap(_slicingGrapincs[i]);
				slice.bitmapData.dispose();
				removeChild(slice);
				_slicingGrapincs[i] = null;
			}
			_slicingGrapincs.length = 0;
			_slicingGrapincs = null;
		}
		
		private function splicegraphic(graphics:BitmapData):void
		{
			var bitmapData:BitmapData;
			var rectangle:Rectangle;
			var point:Point = new Point();
			
			//UP_LEFT corner
			rectangle = new Rectangle(0, 0, _cornerWidth, _cornerHeight);
			bitmapData = new BitmapData(_cornerWidth, _cornerHeight);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//UP bar
			rectangle = new Rectangle(_cornerWidth, 0, _width - _cornerWidth * 2, _cornerHeight);
			bitmapData = new BitmapData(_width - _cornerWidth * 2, _cornerHeight);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//UP_RIGHT corner
			rectangle = new Rectangle(_width - _cornerWidth, 0, _cornerWidth, _cornerHeight);
			bitmapData = new BitmapData(_cornerWidth, _cornerHeight);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//LEFT bar
			rectangle = new Rectangle(0, _cornerHeight, _cornerWidth, _height - _cornerHeight * 2);
			bitmapData = new BitmapData(_cornerWidth, _height - _cornerHeight * 2);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//CENTER
			rectangle = new Rectangle(_cornerWidth, _cornerHeight, _width - _cornerWidth * 2, _height - _cornerHeight * 2);
			bitmapData = new BitmapData(_width - _cornerWidth * 2, _height - _cornerHeight * 2);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//RIGHT bar
			rectangle = new Rectangle(_width - _cornerWidth, _cornerHeight, _cornerWidth, _height - _cornerHeight * 2);
			bitmapData = new BitmapData(_cornerWidth, _height - _cornerHeight * 2);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//DOWN_LEFT bar
			rectangle = new Rectangle(0, _height - _cornerHeight, _cornerWidth, _cornerHeight);
			bitmapData = new BitmapData(_cornerWidth, _cornerHeight);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//DOWN bar
			rectangle = new Rectangle(_cornerWidth, _height - _cornerHeight, _width - _cornerWidth * 2, _cornerHeight);
			bitmapData = new BitmapData(_width - _cornerWidth * 2, _cornerHeight);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			//DOWN_RIGHT bar
			rectangle = new Rectangle(_width - _cornerWidth, _height - _cornerHeight, _cornerWidth, _cornerHeight);
			bitmapData = new BitmapData(_cornerWidth, _cornerHeight);
			bitmapData.copyPixels(graphics, rectangle, point);
			_slicingGrapincs.push(new Bitmap(bitmapData, PixelSnapping.ALWAYS, true));
			
			for (var i:int = 0; i < _slicingGrapincs.length; i++) 
			{
				addChild(_slicingGrapincs[i]);
			}
		}
		
		private const UP_LEFT:uint = 0;
		private const UP:uint = 1;
		private const UP_RIGHT:uint = 2;
		private const LEFT:uint = 3;
		private const CENTER:uint = 4;
		private const RIGHT:uint = 5;
		private const DOWN_LEFT:uint= 6;
		private const DOWN:uint = 7;
		private const DOWN_RIGHT:uint = 8;
		private function getSlice(sign:uint):Bitmap
		{
			return _slicingGrapincs[sign];
		}
	}
	
}