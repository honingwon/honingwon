package sszt.interfaces.panel
{
	public interface IPanel
	{
		function initView():void;
		function initEvent():void;
		function initData():void;
		function clearData():void
		function removeEvent():void;
		function move(x:Number,y:Number):void;
	}
}