package sszt.stall.compoments.emptyCell
{
	import flash.display.Shape;
	
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	
	public class StallCellBaseEmpty extends Shape implements IAcceptDrag
	{
		public function StallCellBaseEmpty()
		{
			super();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,228,114);
			graphics.endFill();
		}
		
		public function dragDrop(data:IDragData):int
		{
			return 0;
		}
		
		public function move(argX:int,argY:int):void
		{
			this.x = argX;
			this.y = argY;
		}
		
		public function dispose():void
		{
			if(parent)parent.removeChild(this);
		}
	}
}