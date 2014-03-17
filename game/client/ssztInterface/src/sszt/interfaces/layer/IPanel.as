package sszt.interfaces.layer
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import sszt.interfaces.dispose.IDispose;

	public interface IPanel extends IEventDispatcher,IDispose
	{
		function doEscHandler():void;
	}
}