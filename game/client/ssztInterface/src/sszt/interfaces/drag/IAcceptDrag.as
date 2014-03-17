package sszt.interfaces.drag
{
	/**
	 * 定义了可接受拖放操作的对象接口。实现此接口的类一般也会实现IDragable接口。一般由可放置技能或物品的格子类等实现。
	 */
	public interface IAcceptDrag
	{
		/**
		 * 设接口实现类为目标，则方法被拖拽目标释放在目标上时调用。
		 * @param data 被拖拽目标数据
		 * @return 拖动动作类型，一般为IDragable的dragStop方法所用。
		 * @see sszt.constData DragActionType
		 */		
		function dragDrop(data:IDragData):int;
	}
}