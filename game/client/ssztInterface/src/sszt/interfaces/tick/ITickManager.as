package sszt.interfaces.tick
{
	public interface ITickManager
	{
		function addTick(tick:ITick):void;
		function removeTick(tick:ITick):void;
		function inTick(tick:ITick):Boolean;
	}
}