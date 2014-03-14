package com.codeTooth.actionscript.interaction.dragDrop.core
{
	public interface IDropReceiver
	{
		function dropMouseOver(dragData:DragData):void;
		
		function dropMouseOut(dragData:DragData):void;
		
		function allowDrop(dragData:DragData):Boolean;
		
		function setDropData(dragData:DragData):void;
	}
}