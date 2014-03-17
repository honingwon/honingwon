package sszt.ui.button
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	public class MTabButton extends MSelectButton
	{		
		public function MTabButton(source:Object,label:String = "",width:Number = -1,height:Number = -1,xscale:Number = 1,yscale:Number = 1,scale9Grid:Rectangle = null)
		{
			_labelYOffset = 0;
			super(source, label,width,height,xscale,yscale,scale9Grid);
			
		}
				
		override protected function initEvent():void
		{
			addEventListener(MouseEvent.ROLL_OVER,overHandler);
			addEventListener(MouseEvent.ROLL_OUT,outHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			addEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		override protected function removeEvent():void
		{
			removeEventListener(MouseEvent.ROLL_OVER,overHandler);
			removeEventListener(MouseEvent.ROLL_OUT,outHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN,downHandler);
			removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
	}
}