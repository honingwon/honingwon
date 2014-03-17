package sszt.furnace.components
{
	public interface IFurnaceTabPanel
	{
		function move(x:Number,y:Number):void;
		function addAssets():void;
		function show():void;
		function hide():void;
		function dispose():void;
	}
}