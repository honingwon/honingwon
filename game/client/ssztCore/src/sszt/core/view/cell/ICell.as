package sszt.core.view.cell
{
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragable;
	
	import flash.events.IEventDispatcher;
	
	public interface ICell extends IDragable, IEventDispatcher
	{
		function set info(value:ILayerInfo):void;
		function get info():ILayerInfo;
	}
}