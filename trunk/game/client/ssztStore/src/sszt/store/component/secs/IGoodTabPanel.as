package sszt.store.component.secs
{
	public interface IGoodTabPanel
	{
		function hide():void;
		function show():void;
		function move(x:Number,y:Number):void;
		function dispose():void;
		function showGoods(page:int,type:int):void;
		function assetsCompleteHandler():void;
	}
}