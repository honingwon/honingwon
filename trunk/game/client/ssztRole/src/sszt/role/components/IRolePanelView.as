package sszt.role.components
{
	import sszt.core.data.player.DetailPlayerInfo;

	public interface IRolePanelView 
	{
		function assetsCompleteHandler():void;
		function hide():void;
		function show():void;
		function dispose():void;
	}
}