package sszt.interfaces.drag
{
	import flash.display.DisplayObject;
	
	import sszt.interfaces.dispose.IDispose;

	/**
	 * 定义了可拖动目标的接口。实现此接口的类不一定会实现IAcceptDrag接口。一般由技能快捷键、技能树或物品的格子类等实现。
	 */
	public interface IDragable extends IDispose
	{
		/**
		 * 获取可拖动目标源的类型。如果可拖动目标为格子，则获取格子类型。
		 * @return 可拖动目标的类型,一般为IAcceptDrag的dragDrop方法所用。
		 * @see sszt.core.view.cell CellType
		 * @see sszt.core.view.cell ICell
		 */		
		function getSourceType():int;
		
		/**
		 * 获取被拖拽目标图像，在拖拽过程中用来指示被拖拽目标
		 * @return 返回显示对象类型，一般要转换为具体的显示对象类型，如Bitmap，Sprite等。
		 * 
		 */		
		function getDragImage():DisplayObject;
		
		/**
		 * 该方法在拖放动作结束后调用。
		 * @param data 被拖拽目标的操作数据
		 * 
		 */		
		function dragStop(data:IDragData):void;
		
		/**
		 * 获取被拖拽目标数据。若拖拽目标为物品格子，则获取物品信息，如物品名称、类型等。
		 * @return 返回为Object类型，一般需要转化为具体的数据类型。
		 */		
		function getSourceData():Object;
	}
}