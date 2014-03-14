package com.codeTooth.actionscript.interaction.dragDrop.core
{
	
	public interface IDragInitiator
	{
		function get dragData():DragData;
		
		function get dragEnabled():Boolean;
		
		function dragToReceiver(result:Boolean, dragData:DragData):void;
	}
}