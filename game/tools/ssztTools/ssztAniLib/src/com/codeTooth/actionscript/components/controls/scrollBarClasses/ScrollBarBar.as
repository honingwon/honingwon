package com.codeTooth.actionscript.components.controls.scrollBarClasses
{
	import com.codeTooth.actionscript.components.controls.AbstractButton;
	
	public class ScrollBarBar extends AbstractButton
	{
		public function ScrollBarBar()
		{
			_width = 15;
			_height = 52;
		}
		
		override public function set mode(mode:String):void
		{
			// do nothing
		}
	}
}