package sszt.ui.container
{
	import ssztui.ui.BarAsset3;
	
	public class SelectedBorder extends BarAsset3
	{
		public function SelectedBorder()
		{
			super();
		}
		
		public function setSize(w:Number,h:Number):void
		{
			width = w;
			height = h;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}