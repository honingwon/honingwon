package sszt.ui.mcache.cells
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ssztui.ui.CellBgAsset;
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.CellBigBoxBgAsset;
	import ssztui.ui.CellBoxBgAsset;
	import ssztui.ui.CellSelectedAsset;

	public class CellCaches
	{
		private static var _cellBg:BitmapData;
		public static function getCellBg():BitmapData
		{
			if(_cellBg == null)
			{
				_cellBg = new CellBgAsset();
			}
			return _cellBg;
		}
		private static var _cellSelectedBox:BitmapData;
		public static function getCellSelectedBox():BitmapData
		{
			if(_cellSelectedBox == null)
			{
				_cellSelectedBox = new CellSelectedAsset();
			}
			return _cellSelectedBox;
		}
		
		
		private static var _cellBigBg:BitmapData;
		public static function getCellBigBg():BitmapData
		{
			if(_cellBigBg == null)
			{
				_cellBigBg = new CellBigBgAsset();
			}
			return _cellBigBg;
		}
		
		/** 格子装饰底框   44x44 / 54x54 **/
		private static var _cellBoxBg:BitmapData;
		public static function getCellBoxBg():BitmapData
		{
			if(_cellBoxBg == null)
			{
				_cellBoxBg = new CellBoxBgAsset();
			}
			return _cellBoxBg;
		}
		private static var _cellBigBoxBg:BitmapData;
		public static function getCellBigBoxBg():BitmapData
		{
			if(_cellBigBoxBg == null)
			{
				_cellBigBoxBg = new CellBigBoxBgAsset();
			}
			return _cellBigBoxBg;
		}
		
		
		/**
		 * 6格单行背景
		 */		
		private static var _cellBgPanel6:BitmapData;
		public static function getCellBgPanel6():BitmapData
		{
			if(_cellBgPanel6 == null)
			{
				_cellBgPanel6 = new BitmapData(38 * 6,38,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 6; i++)
				{
					_cellBgPanel6.copyPixels(cell,cell.rect,new Point(i * 38,0));
				}
			}
			return _cellBgPanel6;
		}
		/**
		 * 6格1间距单行背景
		 */		
		private static var _cellBgPanel61:BitmapData;
		public static function getCellBgPanel61():BitmapData
		{
			if(_cellBgPanel61 == null)
			{
				_cellBgPanel61 = new BitmapData(39 * 6,38,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 6; i++)
				{
					_cellBgPanel61.copyPixels(cell,cell.rect,new Point(i * 39,0));
				}
			}
			return _cellBgPanel61;
		}
		
		/**
		 * 背包格子单行背景
		 */		
		private static var _cellBgPanel2:BitmapData;
		public static function getCellBgPanel2():BitmapData
		{
			if(_cellBgPanel2 == null)
			{
				_cellBgPanel2 = new BitmapData(40 * 8,40,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 8; i++)
				{
					_cellBgPanel2.copyPixels(cell,cell.rect,new Point(i * 40,0));
				}
			}
			return _cellBgPanel2;
		}
		
		/**
		 *7格单行背景 
		 */	
		private static var _cellBgPanel3:BitmapData;
		public static function getCellBgPanel3():BitmapData
		{
			if(_cellBgPanel3 == null)
			{
				_cellBgPanel3 = new BitmapData(40 * 7,40,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 7; i++)
				{
					_cellBgPanel3.copyPixels(cell,cell.rect,new Point(i * 40,0));
				}
			}
			return _cellBgPanel3;			
		}
		/**
		 *4格单行背景 
		 */
		private static var _cellBgPanel4:BitmapData;
		public static function getCellBgPanel4():BitmapData
		{
			if(_cellBgPanel4 == null)
			{
				_cellBgPanel4 = new BitmapData(40 * 4,40,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 4; i++)
				{
					_cellBgPanel4.copyPixels(cell,cell.rect,new Point(i * 40,0));
				}
			}
			return _cellBgPanel4;
		}
		/**
		 * 9格单行背景
		 */		
		private static var _cellBgPanel5:BitmapData;
		public static function getCellBgPanel5():BitmapData
		{
			if(_cellBgPanel5 == null)
			{
				_cellBgPanel5 = new BitmapData(408,40,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 9; i++)
				{
					_cellBgPanel5.copyPixels(cell,cell.rect,new Point(i * 46,0));
				}
			}
			return _cellBgPanel5;
		}
		
		
		/**
		 * 10格单行背景
		 */
		private static var _cellBgPanel10:BitmapData;
		public static function getCellBgPanel10():BitmapData
		{
			if(_cellBgPanel10 == null)
			{
				_cellBgPanel10 = new BitmapData(38*10,38,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 10; i++)
				{
					_cellBgPanel10.copyPixels(cell,cell.rect,new Point(i * 38,0));
				}
			}
			return _cellBgPanel10;
		}
		
		/**
		 * 8格单行背景
		 */
		private static var _cellBgPanel8:BitmapData;
		public static function getCellBgPanel8():BitmapData
		{
			if(_cellBgPanel8 == null)
			{
				_cellBgPanel8 = new BitmapData(38*8,38,true,0);
				var cell:BitmapData = getCellBg();
				for(var i:int = 0; i < 8; i++)
				{
					_cellBgPanel8.copyPixels(cell,cell.rect,new Point(i * 38,0));
				}
			}
			return _cellBgPanel8;
		}
	}
}