package sszt.core.data.buff
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.LayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	
	public class BuffItemInfo extends EventDispatcher
	{
		public var templateId:int;
		public var isExist:Boolean;
//		public var startTime:Date;
		/**
		 * 结束时间
		 */		
		public var endTime:Date;
		/**
		 * 剩余量(血包)
		 */		
		public var remain:int;
		/**
		 * 是否暂停(多倍经验)
		 */		
		public var isPause:Boolean;
		/**
		 * 暂停时间
		 */		
		public var pauseTime:Date;
		/**
		 * 总值
		 */		
		public var totalValue:int;
		
		public function BuffItemInfo()
		{
			super();
		}
		
		public function getTemplate():BuffTemplateInfo
		{
			return BuffTemplateList.getBuff(templateId);
		}
		
		public function setPause(value:Boolean):void
		{
			isPause = value;
			dispatchEvent(new BuffItemInfoUpdateEvent(BuffItemInfoUpdateEvent.PAUSE_UPDATE));
		}
		
		public function remainTimeString():String
		{
			var remain:CountDownInfo = getRemainCountDown();
			var result:String = "";

			remain.days > 0 ? result += LanguageManager.getWord("ssztl.common.dayValue",remain.days) : "";
			remain.hours > 0 ? result += LanguageManager.getWord("ssztl.common.hour",result += remain.hours): "";
			remain.minutes > 0 ? result += LanguageManager.getWord("ssztl.common.minuteValue",remain.minutes) : "";
			remain.seconds > 0 ? result += LanguageManager.getWord("ssztl.common.secondValue",remain.seconds) : "";
			if(result == "")
			{
				LanguageManager.getWord("ssztl.common.passDayLine");
			}
			return result;
		}
		
		public function getRemainCountDown():CountDownInfo
		{
			var remain:CountDownInfo;
			if(isPause)
			{
				remain = DateUtil.getCountDownByDay(pauseTime.getTime(),endTime.getTime());
			}
			else
			{
				remain = DateUtil.getCountDownByDay(GlobalData.systemDate.getSystemDate().getTime(),endTime.getTime());
			}
			return remain;
		}
	}
}