package com.codeTooth.actionscript.game.tilesMap.core 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.objectPool.IReuseable;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * @private
	 */
	
	internal class CellLoader extends Sprite 
														implements IReuseable, IDestroy
	{
		public function CellLoader()
		{
			_loader = new Loader();
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 加载
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _loader:Loader;
		
		public function loader():Loader
		{
			return _loader;
		}
		
		public function load(url:String, row:int, col:int):void
		{
			_row = row;
			_col = col;
			
			removeLoaderListeners();
			addLoaderListeners();
			
			_loader.load(new URLRequest(url));
		}
		
		private function addLoaderListeners():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplateHandler);
		}
		
		private function removeLoaderListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplateHandler);
		}
		
		private function loadComplateHandler(event:Event):void
		{
			var newEvent:CellLoaderEvent = new CellLoaderEvent(CellLoaderEvent.CELL_LOAD_COMPLETE, true);
			newEvent.cellLoader = this;
			dispatchEvent(newEvent);
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 
		//----------------------------------------------------------------------------------------------------------------------
		
		private var _row:int;
		
		private var _col:int;
		
		public function get row():int
		{
			return _row;
		}
		
		public function get col():int
		{
			return _col;
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 
		//----------------------------------------------------------------------------------------------------------------------
		
		public function reuse():void
		{
			removeLoaderListeners();
			
			if(_loader.content != null && _loader.content is Bitmap)
			{
				Bitmap(_loader.content).bitmapData.dispose();
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------
		// 
		//----------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			reuse();
			
			_loader = null;
		}
	}
}