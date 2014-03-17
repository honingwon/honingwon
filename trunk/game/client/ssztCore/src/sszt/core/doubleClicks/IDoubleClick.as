package sszt.core.doubleClicks
{
	import flash.events.IEventDispatcher;

	public interface IDoubleClick extends IEventDispatcher
	{
		function click():void;
		function doubleClick():void;
	}
}