package sszt.interfaces.layer
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	public interface ILayerManager
	{
		/**
		 * 模块层，舞台最底层
		 * @return 
		 * 
		 */		
		function getModuleLayer():DisplayObjectContainer;
		/**
		 * 弹窗层
		 * @return 
		 * 
		 */		
		function getPopLayer():DisplayObjectContainer;
		/**
		 * 提示层，最高层，模块过渡动画放在此层
		 * 各种效果放在此层
		 * @return 
		 * 
		 */		
		function getTipLayer():DisplayObjectContainer;
		
		/**
		 * 特效层 
		 * @return 
		 * 
		 */		
		function getEffectLayer():DisplayObjectContainer;
		/**
		 * 显示居中
		 * @param display
		 * 
		 */		
		function setCenter(display:DisplayObject):void;
		/**
		 * 添加弹出窗
		 * @param panel
		 * @param closeWhenModuleChangle
		 * @param swapWhenClick
		 * 
		 */		
		function addPanel(panel:IPanel,closeWhenModuleChangle:Boolean = true,swapWhenClick:Boolean = true):void;
		
		function getTopPanelRec():Rectangle;
		/**
		 * 获得最顶层的窗口
		 * @return 
		 * 
		 */		
		function getTopPanel():IPanel;
		/**
		 * ESC键按下
		 * 
		 */		
		function escPress():void;
	}
}