package sszt.mounts.component
{
	import flash.display.Sprite;
	
	public class MountsInfoView extends Sprite implements IMountsView
	{
		public function MountsInfoView()
		{
		}
		public function assetsCompleteHandler():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
			
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			
		}
	}
}