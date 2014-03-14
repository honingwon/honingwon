package sszt.map.editor.components.map
{
	import flash.display.Sprite;
	
	public class CustomGrid extends Sprite
	{
		public var label:String;
		public var w:int = 25;
		public function CustomGrid(color:uint, gx:int, gy:int, lineStyle:int = 1)
		{
			super();
			this.graphics.beginFill(color, 1);
			this.graphics.lineStyle(lineStyle, 0xff0000);
			this.graphics.drawRect(gx, gy, w, w);
			this.graphics.endFill();
		}
		
		public function updateColor(colo:uint, gx:int, gy:int, lineStyle:int = 1):void
		{
			this.graphics.clear();
			this.graphics.beginFill(colo, 1);
			this.graphics.lineStyle(lineStyle, 0xff0000);
			this.graphics.drawRect(gx, gy, w, w);
			this.graphics.endFill();
		}
	}
}