package com.codeTooth.actionscript.game.tilesMap.core 
{
	import flash.events.Event;
	
	/**
	 * @private
	 */
	
	internal class CellLoaderEvent extends Event
	{
		public static const CELL_LOAD_COMPLETE:String = "cellLoadComplete";
		
		public var cellLoader:CellLoader;
		
		public function CellLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new CellLoaderEvent(type, bubbles, cancelable);
		}
	}
}