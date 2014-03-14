package com.codeTooth.actionscript.lang.utils.display.bitmap
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * 大位图，内存允许的情况下可以显示任意大小的位图
	 */	
	
	public class BigBitmap extends Sprite 
														implements IDestroy
	{	
		private var _width:int = -1;
		
		private var _height:int = -1;
		
		private var _cellWidth:int = -1;
		
		private var _cellHeight:int = -1;
		
		private var _rows:int = -1;
		
		private var _cols:int = -1;
		
		/**
		 * 构造函数
		 * 
		 * @param width 宽度
		 * @param height 高度
		 * @param cellWidth 单片位图的宽度
		 * @param cellHeight 单片位图的高度
		 * @param transparent 是否透明
		 * @param randomColor 初始化时是否填充随机颜色
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 指定非法的尺寸
		 */		
		public function BigBitmap(width:int, height:int, 
												cellWidth:int = 2880, cellHeight:int = 2880, 
												transparent:Boolean = false, randomColor:Boolean = true)
		{
			if(width <= 0)
			{
				throw new IllegalParameterException("Illegal bigBitmap width \"" + width + "\"")
			}
			
			if(height <= 0)
			{
				throw new IllegalParameterException("Illegal bigBitmap height \"" + height + "\"")
			}
			
			if(cellWidth <= 0)
			{
				throw new IllegalParameterException("Illegal bigBitmap cellWidth \"" + cellWidth + "\"");
			}
			
			if(cellHeight <= 0)
			{
				throw new IllegalParameterException("Illegal bigBitmap cellHeight \"" + cellHeight + "\"");
			}
			
			_width = width;
			_height = height;
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			
			_matrix = new Matrix();
			
			createCells(transparent, randomColor);
			
			mouseChildren = false;
		}
		
		private var _bounds:Rectangle = null;
		
		private var _matrix:Matrix = null;
		
		private var _drawable:IBitmapDrawable = null;
		
		/**
		 * 将对象画到指定的区域
		 * 
		 * @param source
		 * @param tx
		 * @param ty
		 */		
		public function draw(source:Object, tx:int = 0, ty:int = 0):void
		{
			_bounds = source.getBounds(source);
			
			var xFrom:Number = tx + _bounds.x;
			var xTo:Number = xFrom + _bounds.width;
			var yFrom:Number = ty + _bounds.y;
			var yTo:Number = yFrom + _bounds.height;
			
			var rowFrom:int = int(Math.max(0, yFrom / _cellHeight));
			var rowTo:int = int(Math.min(_rows, Math.ceil(yTo / _cellHeight)));
			var colFrom:int = int(Math.max(0, xFrom / _cellWidth));
			var colTo:int = int(Math.min(_cols, Math.ceil(xTo / _cellWidth)));
			
			_matrix.tx = -_bounds.x - (-_bounds.x - tx) % _cellWidth;
			_matrix.ty = -_bounds.y - (-_bounds.y - ty) % _cellHeight;
			var matrixTx:Number = _matrix.tx;
			
			_drawable = IBitmapDrawable(source);
			
			for(var row:int = rowFrom; row < rowTo; row++)
			{
				for(var col:int = colFrom; col < colTo; col++)
				{
					Bitmap(_cells[row][col]).bitmapData.draw(_drawable, _matrix);
					_matrix.tx -= _cellWidth;
				}
				
				_matrix.tx = matrixTx;
				_matrix.ty -= _cellHeight;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			var bitmap:Bitmap = null;
			for(var row:int = 0; row < _rows; row++)
			{
				for(var col:int = 0; col < _cols; col++)
				{
					bitmap = Bitmap(_cells[row][col]);
					bitmap.bitmapData.dispose();
					bitmap.bitmapData = null;
					_cells[row][col] = null;
					removeChild(bitmap);
				}
				_cells[row] = null;
			}
			
			_bounds = null;
			_matrix = null;
			_drawable = null;
		}
		
		private var _cells:Array = null;
		
		private function createCells(transparent:Boolean, randomColor:Boolean):void
		{
			_rows = int(Math.ceil(_height / _cellHeight));
			_cols = int(Math.ceil(_width / _cellWidth));
			_cells = new Array();
			
			var bitmap:Bitmap = null;
			var tWidth:int = -1;
			var tHeight:int = -1;
			
			for(var row:int = 0; row < _rows; row++)
			{
				_cells[row] = new Array();
				tHeight = row == _rows - 1 ? _height - row * _cellHeight : _cellHeight;
				
				for(var col:int = 0; col < _cols; col++)
				{
					tWidth = col == _cols - 1 ? _width - col * _cellWidth : _cellWidth;
					
					bitmap = new Bitmap(new BitmapData(tWidth,
																			  tHeight, 
																			  transparent, 
																			  randomColor ? Math.random() * 0x00FFFFFF : 0x00000000), 
													PixelSnapping.ALWAYS);
					(_cells[row] as Array).push(bitmap);
					addChild(bitmap);
					bitmap.x = col * _cellWidth;
					bitmap.y = row * _cellHeight;
				}
			}
		}
	}
}