package sszt.exStore.component.secs
{
	public interface IExStorePanel
	{
		function hide():void;
		function show():void;
		function move(x:Number,y:Number):void;
		function dispose():void;
		function showGoods(page:int,type:int=0):void;
		function assetsCompleteHandler():void;
	}
}