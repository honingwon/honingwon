package sszt.scene.actions
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	
	import mhqy.ui.FlowerBorder;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.action.BaseAction;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	
	public class RoseAction extends BaseAction
	{
		private var _flowerSource1:BitmapData;
		private var _flowerSource2:BitmapData;
		
		private var _flowers1:Array;
		private var _startTime:Number = -300000;
		private var _lastCount:int;
		
		public function RoseAction()
		{
			super(0);
			_flowers1 = [];
			GlobalAPI.loaderAPI.getPicFile(GlobalAPI.pathManager.getAssetPath("flower1.png"),flower1Complete,SourceClearType.NEVER);
			GlobalAPI.loaderAPI.getPicFile(GlobalAPI.pathManager.getAssetPath("flower2.png"),flower2Complete,SourceClearType.NEVER);
		}
		
		private function flower1Complete(data:BitmapData):void
		{
			_flowerSource1 = data;
			
		}
		private function flower2Complete(data:BitmapData):void
		{
			_flowerSource2 = data;
		}
		
		override public function configure(...parameters):void
		{
			_startTime = getTimer();
			_lastCount = 0;
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			var dn:Number = getTimer() - _startTime;
			if(dn > 40000)
			{
				clear();
			}
			else if(dn > 18000)
			{
			}
			else
			{
				var count:int = int(dn / 300);
				if(count > _lastCount)
				{
					_lastCount = count;
					var flower:Bitmap = getAFlower();
					if(flower)
					{
						//flower,dir,changeIndex,currentIndex,xspeed,yspeed
						_flowers1.push([flower,Math.random() > 0.5 ? 1 : -1,int(Math.random() * 150),0,int(Math.random() * 5) + 1,int(Math.random() * 5) + 1]);
						GlobalAPI.layerManager.getTipLayer().addChild(flower);
						flower.x = int(CommonConfig.GAME_WIDTH * Math.random());
						flower.y = -70;
					}
				}
			}
			for(var i:int = _flowers1.length - 1; i >= 0; i--)
			{
				var f:Array = _flowers1[i];
				if(f[0].y > CommonConfig.GAME_HEIGHT + 30)
				{
					if(f[0].parent)f[0].parent.removeChild(f[0]);
					_flowers1.splice(i,1);
					continue;
				}
				else
				{
					f[0].y += f[5];
					f[0].x += f[1] * f[4];
					f[3]++;
					if(f[3] == f[2])
					{
						f[2] *= -1;
					}
				}
			}
		}
		
		private function getAFlower():Bitmap
		{
			var s:BitmapData;
			if(_flowerSource1 && _flowerSource2)
			{
				s = Math.random() > 0.5 ? _flowerSource1 : _flowerSource2;
			}
			else if(_flowerSource1)
			{
				s = _flowerSource1;
			}
			else if(_flowerSource2)
			{
				s = _flowerSource2;
			}
			if(s)return new Bitmap(s);
			return null;
		}
		
		public function clear():void
		{
			var i:int = 0;
			for(i = 0; i < _flowers1.length; i++)
			{
				if(_flowers1[i][0] && _flowers1[i][0].parent)_flowers1[i][0].parent.removeChild(_flowers1[i][0]);
			}
			_flowers1.length = 0;
			_startTime = -300000;
			_lastCount = 0;
		}
	}
}