package com.codeTooth.actionscript.game.tilesMap.core 
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.display.bitmap.BigBitmap;
	import com.codeTooth.actionscript.lang.utils.objectPool.ObjectPool;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * 地图分块加载
	 */
	
	public class TilesMap extends Sprite 
														implements IDestroy
	{
		
		/**
		 * 构造函数
		 * 
		 * @param	mapWidth 地图宽度
		 * @param	mapHeight 地图高度
		 * @param	cellWidth 地图块的宽度
		 * @param	cellHeight 地图块的高度
		 * @param	urlTemplate 加载快路径模板
		 * @param	rowStart 起始行号
		 * @param	colStart 起始列号
		 * @param	rowPlaceholder 模板中行的占位符
		 * @param	colPlaceholder 模板中列的占位符
		 * @param	loaderPoolCapability 缓存地图加载快的数量
		 */
		public function TilesMap(mapWidth:int, mapHeight:int, 
										   cellWidth:int, cellHeight:int, 
										   urlTemplate:String,
										   rowStart:int = 0, colStart:int = 0,  
										   rowPlaceholder:String = "_$row$_", colPlaceholder:String = "_$col$_", 
										   loaderPoolCapability:int = 20)
		{
			_canvas = new BigBitmap(mapWidth, mapHeight);
			addChild(_canvas);
			
			_cellLoadersPool = new ObjectPool(CellLoader, loaderPoolCapability);
			
			_loadedRowsCols = new Dictionary();
			
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			
			_rowStart = rowStart;
			_colStart = colStart;
			
			var rows:int = int(Math.ceil(mapHeight / cellHeight));
			var cols:int = int(Math.ceil(mapWidth / cellWidth));
			_cellsTotal = rows * cols;
			
			var rowIndexOf:int = urlTemplate.indexOf(rowPlaceholder);
			var colIndexOf:int = urlTemplate.indexOf(colPlaceholder);
			_rowFirst = rowIndexOf < colIndexOf;
			if(rowIndexOf < colIndexOf)
			{
				_urlBlocks = [urlTemplate.substring(0, rowIndexOf), 
				  				   urlTemplate.substring(rowIndexOf + rowPlaceholder.length, colIndexOf),
				 				   urlTemplate.substring(colIndexOf + colPlaceholder.length, urlTemplate.length)];
			}
			else
			{
				_urlBlocks = [urlTemplate.substring(0, colIndexOf), 
				 				   urlTemplate.substring(colIndexOf + colPlaceholder.length, rowIndexOf),
				 				   urlTemplate.substring(rowIndexOf + rowPlaceholder.length, urlTemplate.length)];
			}
			
			addEventListener(CellLoaderEvent.CELL_LOAD_COMPLETE, cellLoadCompleteHandler);
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 地图位图画布
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _canvas:BigBitmap;
		
		private var _cellWidth:int;
		
		private var _cellHeight:int;
		
		/**
		 * 在地图上画一个对象
		 * 
		 * @param	source
		 * @param	tx
		 * @param	ty
		 */
		public function draw(source:IBitmapDrawable, tx:int, ty:int):void
		{
			_canvas.draw(source, ty, ty);
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 加载地图块
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _cellsTotal:int = 0;
		
		private var _cellsLoading:int = 0;
		
		private var _cellsLoaded:int = 0;
		
		private var _cellLoadersPool:ObjectPool;
		
		private var _loadedRowsCols:Dictionary;
		
		private var _urlBlocks:Array;
		
		private var _rowFirst:Boolean;
		
		private var _rowStart:int;
		
		private var _colStart:int;
		
		/**
		 * 判断所有的地图块是否都已经全部加载完成了
		 * 
		 * @return
		 */
		public function loadClosed():Boolean
		{
			return _cellsLoading == _cellsTotal;
		}
		
		/**
		 * 根据地图坐标加载
		 * 
		 * @param	mapX
		 * @param	mapY
		 * @param	mapScaleX
		 * @param	mapScaleY
		 * @param	screenWidth
		 * @param	screenHeight
		 */
		public function loadByMapXY(mapX:Number, mapY:Number, mapScaleX:Number, mapScaleY:Number, screenWidth:int, screenHeight:int):void
		{
			if (!loadClosed())
			{
				var rowFrom:int = int(-mapY / (_cellHeight * mapScaleY));
				var rowTo:int = Math.ceil((-mapY + screenHeight) / _cellHeight / mapScaleY);
				var colFrom:int = int(-mapX / (_cellWidth * mapScaleX));
				var colTo:int = Math.ceil((-mapX + screenWidth) / _cellWidth / mapScaleX);
				
				for (var row:int = rowFrom; row < rowTo; row++) 
				{
					for (var col:int = colFrom; col < colTo; col++) 
					{
						loadByRolCol(row + _rowStart, col + _colStart);
					}
				}
			}
		}
		
		/**
		 * 根据行列加载
		 * 
		 * @param	row
		 * @param	col
		 */
		public function loadByRolCol(row:int, col:int):void
		{	
			var rowCol:String = String(row) + String(col);
			
			if(_loadedRowsCols[rowCol] == undefined)
			{
				_loadedRowsCols[rowCol] = true;
				
				_cellsLoading++;
				
				var cellLoader:CellLoader = CellLoader(_cellLoadersPool.createObject());
				addChild(cellLoader);
				if(_rowFirst)
				{
					cellLoader.load(_urlBlocks[0] + row + _urlBlocks[1] + col + _urlBlocks[2], row, col);
				}
				else
				{
					cellLoader.load(_urlBlocks[0] + col + _urlBlocks[1] + row + _urlBlocks[2], row, col);
				}
			}
		}
		
		private function cellLoadCompleteHandler(event:CellLoaderEvent):void
		{
			event.stopImmediatePropagation();
			
			removeChild(event.cellLoader);
			
			_canvas.draw(event.cellLoader.loader(),
								 _cellWidth * (event.cellLoader.col - _rowStart), 
								 _cellHeight * (event.cellLoader.row - _colStart));
								 
			_cellLoadersPool.reuse(event.cellLoader);
			
			if (++_cellsLoaded == _cellsTotal && _cellsLoading == _cellsTotal)
			{
				if (!_destroiedLoader)
				{
					_destroiedLoader = true;
					destroyLoader();
				}
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 销毁加载器
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _destroiedLoader:Boolean = false;
		
		private function destroyLoader():void
		{	
			removeEventListener(CellLoaderEvent.CELL_LOAD_COMPLETE, cellLoadCompleteHandler);
			
			var loadersIterator:IIterator = _cellLoadersPool.reuseableIterator();
			while (loadersIterator.hasNext())
			{
				CellLoader(loadersIterator.next()).destroy();
			}
			loadersIterator.destroy();
			
			_cellLoadersPool.destroy();
			_cellLoadersPool = null;
			
			DestroyUtil.breakMap(_loadedRowsCols);
			_loadedRowsCols = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			_canvas.destroy();
			removeChild(_canvas);
			_canvas = null;
			
			if(_cellLoadersPool != null)
			{
				destroyLoader();
				_cellLoadersPool = null;
			}
		}
	}
}