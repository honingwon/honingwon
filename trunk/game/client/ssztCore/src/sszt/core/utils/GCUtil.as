package sszt.core.utils
{
	import flash.net.LocalConnection;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.interfaces.tick.ITick;

	public class GCUtil implements ITick
	{		
		public static function gc():void
		{
			if(GlobalData.GCTIME <= 0)return;
			try
			{
				new LocalConnection().connect("gc5");
				new LocalConnection().connect("gc5");
			}
			catch(e:Error)
			{
			}
		}
		
		public static const instance:GCUtil = new GCUtil();
		
		private var _current:Number;
		
		public function GCUtil():void
		{
			
		}
		
		public function start():void
		{
			_current = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(GlobalData.GCTIME <= 0)return;
			var n:Number = getTimer();
			if(n - _current < GlobalData.GCTIME)return;
			_current = n;
			gc();
//			trace("gc");
		}
	}
}