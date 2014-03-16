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
			var t:SsztPrepare2 = new SsztPrepare2(paras.user,paras.site,paras.serverid,paras.tick,paras.sign,paras.fcm,paras.pf, paras.pfKey, paras.openKey, paras.zoneId,paras.domain,paras.ip,paras.port,paras.guest,paras.isYellowVip,paras.isYellowYearVip,paras.yellowVipLevel,paras.isYellowHighVip);
			t.setup(this);
		}
		
	}
}