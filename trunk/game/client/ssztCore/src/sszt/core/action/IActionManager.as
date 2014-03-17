package sszt.core.action
{
	import sszt.interfaces.tick.ITick;

	public interface IActionManager extends ITick
	{
		function addAction(action:IAction):void;
		function removeAction(action:IAction):void;
//		function getAction(type:String):Vector.<IAction>;
		function getAction(type:String):Array;
		function dispose():void;
	}
}