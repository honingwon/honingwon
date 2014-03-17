package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import sszt.ui.progress.ProgressBar;

	public class BloodBars
	{
		public static var _barList:Array = new Array();
		
		public static function getBloodBar(forData:BitmapData,bgData:BitmapData,currentHp:int,totalHp:int):ProgressBar
		{
			var t:ProgressBar;
			if(_barList.length > 0)
			{
				t = _barList.shift();
				t.setValue(totalHp,currentHp);
			}
			else
			{
				var bg:Bitmap = new Bitmap(bgData);
				bg.x = -2;
				bg.y = -1;
				t = new ProgressBar(new Bitmap(forData),currentHp,totalHp,50,6,false,false,bg);
				t.mouseChildren = t.mouseEnabled = t.tabChildren = t.tabEnabled = false;
			}
			return t;
		}
		
		public static function collectBloodBar(bar:ProgressBar):void
		{
			if(bar.parent)bar.parent.removeChild(bar);
			if(_barList.length < 100)
				_barList.push(bar);
		}
	}
}