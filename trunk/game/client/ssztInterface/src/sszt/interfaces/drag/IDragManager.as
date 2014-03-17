package sszt.interfaces.drag
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IDragManager
	{
		function setup(sp:DisplayObjectContainer):void;
		/**
		 * 开始拖动
		 * @param data 拖动参数
		 * @proxyEnable 拖动物品是否响应鼠标
		 * @return 
		 * 
		 */		
		function startDrag(data:IDragable,proxyEnable:Boolean = false):Boolean;
		/**
		 * 拖动结束
		 * 
		 */		
		function acceptDrag():void;
	}
}