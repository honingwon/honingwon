package sszt.rank.components.views
{
	import flash.display.Sprite;
	
	public class RankViewImpl extends Sprite implements IRankView
	{
		public function RankViewImpl()
		{
			super();
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function setSize(width:int, height:int):void
		{
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function initEvents():void
		{
		}
		
		public function removeEvents():void
		{
		}
		
		public function dispose():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}