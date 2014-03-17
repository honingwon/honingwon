package sszt.scene.components.sceneObjs
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.tick.ITick;
	
	public class SpritEffect extends Sprite implements ITick
	{
//		private var COLORS:Array = [0xFFFFCC,0x00ffff,0xFFFFCC];
//		private var ALPHAS:Array = [1,1,1];
//		private var RATIOS:Array = [0,127,0xFF];
		private var _count:int=0;
		private var _time:int;
		public function SpritEffect(time:int)
		{
			super();
			_time= time;
			init();
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function init():void
		{
			graphics.beginFill(0xFFFF33,1);
//			graphics.beginGradientFill(GradientType.LINEAR,COLORS,ALPHAS,RATIOS);
//			graphics.lineStyle(0, 0);
//			graphics.moveTo(200,200);  //要是这里改成  200 + Math.cos(a)*10, 200 + Math.sin(a)*10  就画不了圆？
//			graphics.lineTo(200 + Math.cos(a)*10, 200 + Math.sin(a)*10);
//			graphics.endFill();
			graphics.drawCircle(0,0,1);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x= x;
			this.y= y;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{			
			_count++;
			this.alpha-=0.02;
			this.y+=1;
			if(_count == _time)
				dispose();
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);	
			if(this.parent.contains(this))
				this.parent.removeChild(this);		
		}
	}
}