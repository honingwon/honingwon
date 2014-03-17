/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-26 下午3:39:31 
 * 
 */ 
package
{
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	[SWF(backgroundColor=0x000000,frameRate=25)]
	public class ssztGameLoader extends Sprite
	{
		public var backgroundColor:uint = 0x000000;
		private var _nameInput:TextField;
		private var _portInput:TextField;
		public function ssztGameLoader()
		{
			super();
			new Declear2();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			this.loaderInfo.addEventListener(Event.COMPLETE, ssztPrepare);
		}			
		
		
		private function ssztPrepare(e:Event):void
		{
			var paras:Object =  LoaderInfo(e.target).parameters;
			//paras = {
			//	user:"fdsafdsaferrrfff",site:"sszt",time:1353920555,sign:"" ,fcm : 1,ip : "127.0.0.1",port :8010,guest : "0"
			//}
//			var t:SsztPrepare2 = new SsztPrepare2(paras.user,paras.site,paras.time,paras.sign,paras.fcm,paras.ip,paras.port,paras.guest);
//			t.setup(this);
		}
		
	}
}