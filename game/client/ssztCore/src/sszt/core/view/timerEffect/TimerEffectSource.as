package sszt.core.view.timerEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.tick.ITick;

	public class TimerEffectSource
	{
		public var datas:Array;
		
		public var datas1:Array;
		
		public function TimerEffectSource()
		{
			datas = [];
			datas1 = [];
			init();
		}
		
		private function init():void
		{
			var container:Sprite = new Sprite();
			
			var tmpX:Number,tmpY:Number;
			var bd:BitmapData;
			var i:int = 0;
			for(i = -90; i <= 270; i++)
			{
				container.graphics.clear();
				container.graphics.beginFill(0,0.5);
				if(i < 225)
				{
					container.graphics.moveTo(0,0);
					container.graphics.lineTo(15,0);
					container.graphics.lineTo(15,15);
					if(i <= -45)
					{
						tmpX = 15 / Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(15 - tmpX,0);
						container.graphics.lineTo(30,0);
						container.graphics.lineTo(30,30);
						container.graphics.lineTo(0,30);
						container.graphics.lineTo(0,0);
					}
					else if(i < 0)
					{
						tmpY = 15 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(30,15 + tmpY);
						container.graphics.lineTo(30,30);
						container.graphics.lineTo(0,30);
						container.graphics.lineTo(0,0);
					}
					else if(i < 45)
					{
						tmpY = 15 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(30,tmpY + 15);
						container.graphics.lineTo(30,30);
						container.graphics.lineTo(0,30);
						container.graphics.lineTo(0,0);
					}
					else if(i < 90)
					{
						tmpX = 15 / Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(15 + tmpX,30);
						container.graphics.lineTo(0,30);
						container.graphics.lineTo(0,0);
					}
					else if(i < 135)
					{
						tmpX = 15 / Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(tmpX + 15,30);
						container.graphics.lineTo(0,30);
						container.graphics.lineTo(0,0);
					}
					else if(i < 180)
					{
						tmpY = 15 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(0,15 - tmpY);
						container.graphics.lineTo(0,0);
					}
					else if(i < 225)
					{
						tmpY = 15 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(0,15 - tmpY);
						container.graphics.lineTo(0,0);
					}
				}
				else
				{
					tmpX = 15 / Math.tan(i / 180 * Math.PI);
					container.graphics.moveTo(tmpX,0);
					container.graphics.lineTo(15,0);
					container.graphics.lineTo(15,15);
					container.graphics.lineTo(15 - tmpX,0);
				}
				bd = new BitmapData(30,30,true,0);
				bd.draw(container);
				datas.push(bd);
			}
			
			container = new Sprite;
			for(i = -90; i <= 270; i++)
			{
				container.graphics.clear();
				container.graphics.beginFill(0,0.5);
				if(i < 225)
				{
					container.graphics.moveTo(0,0);
					container.graphics.lineTo(20,0);
					container.graphics.lineTo(20,20);
					if(i <= -45)
					{
						tmpX = 20 / Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(20 - tmpX,0);
						container.graphics.lineTo(40,0);
						container.graphics.lineTo(40,40);
						container.graphics.lineTo(0,40);
						container.graphics.lineTo(0,0);
					}
					else if(i < 0)
					{
						tmpY = 20 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(40,20 + tmpY);
						container.graphics.lineTo(40,40);
						container.graphics.lineTo(0,40);
						container.graphics.lineTo(0,0);
					}
					else if(i < 45)
					{
						tmpY = 20 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(40,tmpY + 20);
						container.graphics.lineTo(40,40);
						container.graphics.lineTo(0,40);
						container.graphics.lineTo(0,0);
					}
					else if(i < 90)
					{
						tmpX = 20 / Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(20 + tmpX,40);
						container.graphics.lineTo(0,40);
						container.graphics.lineTo(0,0);
					}
					else if(i < 135)
					{
						tmpX = 20 / Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(tmpX + 20,40);
						container.graphics.lineTo(0,40);
						container.graphics.lineTo(0,0);
					}
					else if(i < 180)
					{
						tmpY = 20 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(0,20 - tmpY);
						container.graphics.lineTo(0,0);
					}
					else if(i < 225)
					{
						tmpY = 20 * Math.tan(i / 180 * Math.PI);
						container.graphics.lineTo(0,20 - tmpY);
						container.graphics.lineTo(0,0);
					}
				}
				else
				{
					tmpX = 20 / Math.tan(i / 180 * Math.PI);
					container.graphics.moveTo(tmpX,0);
					container.graphics.lineTo(20,0);
					container.graphics.lineTo(20,20);
					container.graphics.lineTo(20 - tmpX,0);
				}
				bd = new BitmapData(40,40,true,0);
				bd.draw(container);
				datas1.push(bd);
			}
		}
	}
}