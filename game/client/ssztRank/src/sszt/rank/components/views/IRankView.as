package sszt.rank.components.views
{
	public interface IRankView
	{
		function show():void;
		function hide():void;
		function setSize(width:int, height:int):void;
		function move(x:int, y:int):void;
		function initEvents():void;
		function removeEvents():void;
		function dispose():void;
	}
}