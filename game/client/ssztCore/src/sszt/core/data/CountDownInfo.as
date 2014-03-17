package sszt.core.data
{
	public class CountDownInfo
	{
		public var years:int;
		public var months:int;
		public var days:int;
		public var hours:int;
		public var minutes:int;
		public var seconds:int;
		public var millseconds:int
		
		public function CountDownInfo(days:int = 0,hours:int = 0,minutes:int = 0,seconds:int = 0,millseconds:int = 0)
		{
			this.days = days;
			this.hours = hours;
			this.minutes = minutes;
			this.seconds = seconds;
			this.millseconds = millseconds;
		}
		
		public function getToInt():int
		{
			var time:int = hours * 3600 + minutes * 60 + seconds;
			return time;
		}
	}
}