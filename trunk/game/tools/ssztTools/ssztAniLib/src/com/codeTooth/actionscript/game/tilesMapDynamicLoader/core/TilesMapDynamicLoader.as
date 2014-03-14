package com.codeTooth.actionscript.game.tilesMapDynamicLoader.core 
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.objectPool.ObjectPool;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 地图动态分块加载
	 */
	
	public class TilesMapDynamicLoader extends Sprite 
																	implements IDestroy
	{
		
		/**
		 * 构造函数
		 * 
		 * @param	screenWidth 屏幕的宽度
		 * @param	screenHeight 屏幕的高度
		 * @param	mapWidth 地图的宽度
		 * @param	mapHeight 地图的高度
		 * @param	cellWidth 地图块的宽度
		 * @param	cellHeight 地图块的高度
		 * @param	urlTemplate 加载地图块的url模板
		 * @param	cushionCellAmount 缓冲区地图块的圈数
		 * @param rowStart 起始行号
		 * @param colStart 起始列号
		 * @param	rowPlaceholder 模板中行的占位符
		 * @param	colPlaceholder 模板中列的占位符
		 */
		public function TilesMapDynamicLoader(screenWidth:int, screenHeight:int,
															  mapWidth:int, mapHeight:int,
															  cellWidth:int, cellHeight:int,
															  urlTemplate:String,
															  cushionCellAmount:int = 2,
															  rowStart:int = 1, colStart:int = 1, 
															  rowPlaceholder:String = "_$row$_", colPlaceholder:String = "_$col$_") 
		{
			_screenWidth = screenWidth;
			_screenHeight = screenHeight;
			
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			
			_bounds = new Rectangle(-_cellWidth * cushionCellAmount, -_cellHeight * cushionCellAmount, 
												 _screenWidth + _cellWidth * cushionCellAmount * 2, 
												 _screenHeight + _cellHeight * cushionCellAmount * 2);
			
			var rows:int = int(Math.ceil(_bounds.height / _cellHeight));
			var cols:int = int(Math.ceil(_bounds.width / _cellWidth));
			
			_rows = int(Math.ceil(mapHeight / _cellHeight));
			_cols = int(Math.ceil(mapWidth / _cellWidth));
			
			_cushionCellAmount = cushionCellAmount;
			
			_loadersPool = new ObjectPool(CellLoader, rows * cols * 2);
			
			_loaders = new Dictionary();
			
			_lastMapX = int.MIN_VALUE;
			_lastMapY = int.MIN_VALUE;
			
			parseURLBlocks(urlTemplate, rowPlaceholder, colPlaceholder);
			
			_rowStart = rowStart;
			_colStart = colStart;
			
			load(0, 0);
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 加载地图块
		//----------------------------------------------------------------------------------------------------------------------
		
		//上一次地图的x坐标
		private var _lastMapX:Number;
		
		//上一次地图的y坐标
		private var _lastMapY:Number;
		
		/**
		 * 加载地图
		 * 
		 * @param	mapX 当前地图的x坐标
		 * @param	mapY 当前地图的y坐标
		 */
		public function load(mapX:Number, mapY:Number):void
		{
			if (Math.abs(_lastMapX - mapX) >= _cellWidth || Math.abs(_lastMapY - mapY) >= _cellHeight)
			{
				_lastMapX = mapX - mapX % _cellWidth;
				_lastMapY = mapY - mapY % _cellHeight;
				_bounds.x = -mapX - _cushionCellAmount * _cellWidth;
				_bounds.y = -mapY - _cushionCellAmount * _cellHeight;
				
				var rowFrom:int = int(Math.max(_bounds.y / _cellHeight, 0));
				var rowTo:int = int(Math.min(Math.ceil((_bounds.y + _bounds.height) / _cellHeight), _rows));
				var colFrom:int = int(Math.max(_bounds.x / _cellWidth, 0));
				var colTo:int = int(Math.min(Math.ceil((_bounds.x + _bounds.width) / _cellWidth), _cols));
				
				var cellLoader:CellLoader;
				
				for (var pName:Object in _loaders)
				{
					cellLoader = CellLoader(_loaders[pName]);
					if (cellLoader.row < rowFrom || cellLoader.row >= rowTo || cellLoader.col < colFrom || cellLoader.col >= colTo)
					{
						delete _loaders[pName];
						
						_loadersPool.reuse(cellLoader);
						removeChild(cellLoader);
					}
				}
				
				var rowCol:String;
				
				for (var row:int = rowFrom; row < rowTo; row++) 
				{
					for (var col:int = colFrom; col < colTo; col++) 
					{
						rowCol = String(row) + String(col);
						if (_loaders[rowCol] == undefined)
						{
							cellLoader = CellLoader(_loadersPool.createObject([_cellWidth, _cellHeight]));
							addChild(cellLoader);
							_loaders[rowCol] = cellLoader;
							cellLoader.row = row;
							cellLoader.col = col;
							cellLoader.x = _cellWidth * col;
							cellLoader.y = _cellHeight * row;
							cellLoader.load(_rowFirst ? (_urlBlocks[0] + (row + _rowStart) + _urlBlocks[1] + (col + _colStart) + _urlBlocks[2]) : 
																 (_urlBlocks[0] + (col + _colStart) + _urlBlocks[1] + (row + _rowStart) + _urlBlocks[2]));
						}
					}
				}
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 各种参数
		//----------------------------------------------------------------------------------------------------------------------
		
		//屏幕宽度
		private var _screenWidth:int;
		
		//屏幕高度
		private var _screenHeight:int;
		
		//地图块的宽度
		private var _cellWidth:int;
		
		//地图块的高度
		private var _cellHeight:int;
		
		//地图块的行数
		private var _rows:int;
		
		//地图块的列数
		private var _cols:int;
		
		//缓冲区地图块的圈数
		private var _cushionCellAmount:int;
		
		//起始行号
		private var _rowStart:int;
		
		//起始列号
		private var _colStart:int;
		
		//----------------------------------------------------------------------------------------------------------------------
		// 
		//----------------------------------------------------------------------------------------------------------------------
		
		//加载地图块的url
		private var _urlBlocks:Array;
		
		//加载路径中是否是行优先
		private var _rowFirst:Boolean;
		
		private function parseURLBlocks(urlTemplate:String, rowPlaceholder:String, colPlaceholder:String):void
		{
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
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 
		//----------------------------------------------------------------------------------------------------------------------
		
		//地图块加载器池
		private var _loadersPool:ObjectPool;
		
		//范围边界
		private var _bounds:Rectangle;
		
		//----------------------------------------------------------------------------------------------------------------------
		// 所有的 CellLoader
		//----------------------------------------------------------------------------------------------------------------------
		
		//所有显示的地图块
		private var _loaders:Dictionary;
		
		//----------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy接口
		//----------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			var reuseableIterator:IIterator = _loadersPool.reuseableIterator();
			while (reuseableIterator.hasNext())
			{
				CellLoader(reuseableIterator.next()).destroy();
			}
			reuseableIterator.destroy();
			
			_loadersPool.destroy();
			_loadersPool = null;
			
			DestroyUtil.breakArray(_urlBlocks);
			_urlBlocks = null;
			
			for each(var cellLoader:CellLoader in _loaders)
			{
				removeChild(cellLoader);
			}
			DestroyUtil.destroyMap(_loaders);
			_loaders = null;
		}
	}

}