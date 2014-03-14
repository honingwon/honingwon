package com.codeTooth.actionscript.game.tilesMapDynamicLoader.core 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.objectPool.IReuseable;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	
	/**
	 * @private
	 * 
	 * 地图块加载器
	 */
	
	internal class CellLoader extends Sprite 
													implements IDestroy, IReuseable
	{
		
		/**
		 * 构造函数
		 * 
		 * @param	width 地图块的宽度
		 * @param	height 地图块的高度
		 */
		public function CellLoader(width:int, height:int) 
		{
			_width = width;
			_height = height;
			
			_loader = new Loader();
			addChild(_loader);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 地图块所处的行号了列号
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _row:int;
		
		private var _col:int;
		
		public function set row(row:int):void
		{
			_row = row;
		}
		
		public function get row():int
		{
			return _row;
		}
		
		public function set col(col:int):void
		{
			_col = col;
		}
		
		public function get col():int
		{
			return _col;
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// Loader的宽高
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _width:int;
		
		private var _height:int;
		
		//----------------------------------------------------------------------------------------------------------------------
		// Loader
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _loader:Loader;
		
		public function load(url:String):void
		{
			_loader.load(new URLRequest(url));
		}
		
		private function completeHandler(event:Event):void
		{
			_loader.width = _width;
			_loader.height = _height;
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 实现 IReuseable 接口
		//----------------------------------------------------------------------------------------------------------------------
		
		public function reuse():void
		{	
			if (_loader.content != null && _loader.content is Bitmap)
			{
				Bitmap(_loader.content).bitmapData.dispose();
			}
			
			_loader.unload();
			
			try
			{
				_loader.close();
			}
			catch (error:Error)
			{
				
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			removeChild(_loader);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			reuse();
			_loader = null;
		}
		
	}

}