package sszt.swordsman.components
{
	public interface IPanel
	{
		function initView():void;
		function initEvent():void;
		function initData():void;
		function removeEvent():void;
		function move(x:Number,y:Number):void;
		function dispose():void
	}
}