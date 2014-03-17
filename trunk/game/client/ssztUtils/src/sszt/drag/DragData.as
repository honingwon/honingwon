package sszt.drag
{
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.drag.*;
	
	public class DragData implements IDragData 
	{
		
		private var _dragTarget:IAcceptDrag;
		private var _dragSource:IDragable;
		private var _action:int;
		private var _dragParam:*;
		
		public function DragData(source:IDragable, data:*=null, action:int=0, target:IAcceptDrag=null)
		{
			_dragSource = source;
			_dragParam = data;
			_action = action;
			_dragTarget = target;
		}
		
		public function set dragTarget(value:IAcceptDrag):void
		{
			_dragTarget = value;
		}
		
		public function get dragTarget():IAcceptDrag
		{
			return _dragTarget;
		}
		
		public function set dragSource(value:IDragable):void
		{
			_dragSource = value;
		}
		
		public function set dragParam(value:*):void
		{
			_dragParam = value;
		}
		
		public function get dragParam():*
		{
			return _dragParam;
		}
		
		public function set action(value:int):void
		{
			_action = value;
		}
		
		public function get action():int
		{
			return _action;
		}
		
		public function get dragSource():IDragable
		{
			return (_dragSource);
		}
		
	}
}
