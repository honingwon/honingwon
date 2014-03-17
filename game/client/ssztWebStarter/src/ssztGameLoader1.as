/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-26 下午3:39:31 
 * 
 */ 
package
{
	
	import com.adobe.crypto.MD5;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	[SWF(backgroundColor=0x000000,frameRate=25)]
	public class ssztGameLoader1 extends Sprite
	{
		public var backgroundColor:uint = 0x000000;
		private var _nameInput:TextField;
		private var _portInput:TextField;
		public function ssztGameLoader1()
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
			var time:String = String(int(new Date().getTime() / 1000));
			var site:String = "sszt";
			var serverid:int = 0;
			var user:String = "7376EDD0C1A9937EBDE652CC499DC6F3";
			var tick:String = time + "|0|0|0|0|1";
			var sign:String = MD5.hash(user + site + tick + "qq-zone-7101545-911-cm");// "qq-zone-710-5000-cm3d");  qq-zone-7101545-911-cm  s0.app100722626.twsapp.com
			paras = {
				user:user,site:"sszt",tick:tick,sign:sign ,fcm : 1,pf:"" ,pfKey:"",openKey:"" ,zoneId:0,domain:"119.147.19.43",ip : "s17.app100722626.qqopenapp.com",port :8001,guest : "0",isYellowVip:0,isYellowYearVip:0,yellowVipLevel:0,isYellowHighVip:0
			}
			var t:SsztPrepare2 = new SsztPrepare2(paras.user,paras.site,paras.serverid,paras.tick,paras.sign,paras.fcm,paras.pf, paras.pfKey, paras.openKey, paras.zoneId,paras.domain,paras.ip,paras.port,paras.guest,paras.isYellowVip,paras.isYellowYearVip,paras.yellowVipLevel,paras.isYellowHighVip);
			t.setup(this);
		}
		
	}
}