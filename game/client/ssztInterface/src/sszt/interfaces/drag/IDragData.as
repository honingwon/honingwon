package sszt.interfaces.drag
{
	public interface IDragData
	{
		/**
		 * 设置获取拖动对象
		 * 
		 */		
		function get dragSource():IDragable;
		function set dragSource(value:IDragable):void;
		/**
		 * 设置获取放入对象
		 * 
		 */		
		function get dragTarget():IAcceptDrag;
		function set dragTarget(value:IAcceptDrag):void;
		/**
		 * 拖动类型
		 * 
		 */		
		function get action():int;
		function set action(value:int):void;
		/**
		 * 拖动参数
		 * 
		 */		
		function get dragParam():*;
		function set dragParam(value:*):void;
	}
}
