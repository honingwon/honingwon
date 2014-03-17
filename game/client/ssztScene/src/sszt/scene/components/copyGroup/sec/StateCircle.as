package sszt.scene.components.copyGroup.sec
{
	import flash.display.Sprite;
	
	public class StateCircle extends Sprite
	{
		public function StateCircle()
		{
			super();
			init();
		}
		
		private function init():void
		{
			graphics.beginFill(0xffd400,1);
			graphics.drawCircle(13,13,13);
			graphics.endFill();
		}
		
		public function set state(type:int):void
		{
			var color:int = 0;
			graphics.clear();
			switch (type)
			{
				case 0:
					color = 0xffd400;
					break;
				case 1:
					color = 0x00ff00;
					break;
				case 2:
					color = 0x888888;
					break;
			}
			graphics.beginFill(color,1);
			graphics.drawCircle(13,13,13);
			graphics.endFill();
		}
		
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
		}
	}
}