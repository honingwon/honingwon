package sszt.core.view.effects
{
	import sszt.interfaces.tick.ITick;
	
	public interface IEffect extends ITick
	{
		function play(clearType:int = 1,clearTime:int = 2147483647,priority:int = 3):void;	
		function stop():void;
		function move(x:Number,y:Number):void
		function dispose():void;
	}
}