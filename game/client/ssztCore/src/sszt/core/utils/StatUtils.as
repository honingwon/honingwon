package sszt.core.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;

	public class StatUtils
	{
		public static function doStat(type:int,id:Number = 0):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR,statErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,statErrorHandler);
//			loader.load(new URLRequest(GlobalAPI.pathManager.getStatPath() + "?type=" + type + "&user_id=" + (id != 0 ? id : GlobalData.selfPlayer.userId) + "&rnd=" + Math.random()));
			loader.load(new URLRequest(GlobalAPI.pathManager.getStatPath() + "?type=" + type + "&user_name=" + GlobalData.tmpUserName + "&rnd=" + Math.random()));
			
		}
		
		private static function statErrorHandler(evt:Event):void
		{
		}
	}
}