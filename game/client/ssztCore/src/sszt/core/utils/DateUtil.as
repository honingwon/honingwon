package sszt.core.utils
{
	import sszt.core.data.CountDownInfo;

	public class DateUtil
	{
		
		public static function millsecondsToMinutes(milliseconds:Number):Number
		{
			return (secondsToMinutes(millsecondsToSecond(milliseconds)));
		}
		/**
		 * @param time
		 * @return xx:xx:xx
		 * 
		 */
		public static function getLeftTime(time:int):String
		{
			if(time <= 0)
				return "0:0:0";
			var des:String = "";
			var h:int = Math.floor(time/3600);
			if(h >= 10)
				des += time.toString();
			if(h<=9)
				des += "0"+h.toString() + ":";
			time = time - h*3600;
			var m:int=Math.floor(time/60);
			if(m>=10)
				des += m.toString() + ":";
			if(m<=9)
				des +="0"+m.toString()+":";
			time = time - m * 60;
			if(time >= 10)
				des += time.toString();
			if(time<=9)
				des += "0"+time.toString();
			return des;	
			
		}
		
		
		/**
		 * 一个月里有几天
		 * @param year
		 * @param month
		 * @return 
		 * 
		 */		
		public static function getDaysInMonth(year:Number,month:Number):uint
		{
			return (new Date(year,++month,0)).getDate();
		}
		
		/**
		 * 返回相差的日期数
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public static function deltaDay(start:Date,end:Date):int
		{
			var dtday:int = getDayOfTheYear(end) - getDayOfTheYear(start);
			var t:int = end.fullYear - start.fullYear;
			if(t > 0)
			{
				for(var i:int = 0; i < t; i++)
				{
					dtday += isLeapYear(start.fullYear + i) ? 366 : 365;
				}
			}
			return dtday;
		}
		
		/**
		 * 是一年中的第几天
		 * @param d
		 * @return 
		 * 
		 */		
		public static function getDayOfTheYear(d:Date):uint
		{
			var firstDay:Date = new Date(d.getFullYear(),0,1);
			return (d.getTime() - firstDay.getTime()) / 86400000;
		}
		
		public static function getTimeBetween(start:Date,end:Date):Number
		{
			return end.getTime() - start.getTime();
		}
		/**
		 * 返回二个时间之间的一个差值countdowninfo
		 * 返回：天-时-分-秒
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */		
		public static function getCountDownByDay(startTimer:Number,endTimer:Number):CountDownInfo
		{
			var days:Number = millisecondsToDays(endTimer - startTimer);
			var hours:Number = daysToHours(days % 1);
			var mins:Number = hoursToMinutes(hours % 1);
			var secs:Number = minutesToSeconds(mins % 1);
			var mills:Number = secondsToMillSeconds(secs % 1);
			
			return new CountDownInfo(days,hours,mins,secs,mills);
		}
		
		/**
		 * 返回结束时间的countdowninfo
		 * 返回：天-时-分-秒
		 * @param end
		 * @return 
		 * 
		 */		
		public static function getCountDownByEndDay(endTimer:Number):CountDownInfo
		{
			var days:Number = millisecondsToDays(endTimer);
			var hours:Number = daysToHours(days % 1);
			var mins:Number = hoursToMinutes(hours % 1);
			var secs:Number = minutesToSeconds(mins % 1);
			var mills:Number = secondsToMillSeconds(secs % 1);
			
			return new CountDownInfo(days,hours,mins,secs,mills);
		}
		
		/**
		 * 返回：小时-分钟-秒
		 * @param startTimer
		 * @param endTimer
		 * @return 
		 * 
		 */		
		public static function getCountDownByHour(startTimer:Number,endTimer:Number):CountDownInfo
		{
			var hours:Number = millisecondsToHours(endTimer - startTimer);
			var mins:Number = hoursToMinutes(hours % 1);
			var secs:Number = minutesToSeconds(mins % 1);
			var mills:Number = secondsToMillSeconds(secs % 1);
			
			return new CountDownInfo(0,hours,mins,secs,mills);
		}
		
		/**
		 * 是否润年
		 * @param year
		 * @return 
		 * 
		 */		
		public static function isLeapYear(year:Number):Boolean
		{
			return getDaysInMonth(year,1) == 29;
		}
				
		/**
		 * 毫秒转为天
		 * @return 
		 * 
		 */		
		public static function millisecondsToDays(milliseconds:Number):Number
		{
			return hoursToDays(minutesToHours(secondsToMinutes(millsecondsToSecond(milliseconds))));
		}
		
		public static function millisecondsToHours(milliseconds:Number):Number
		{
			return minutesToHours(secondsToMinutes(millsecondsToSecond(milliseconds)));
		}
		
		public static function millsecondsToSecond(millseconds:Number):Number
		{
			return millseconds / 1000;
		}
		
		public static function secondsToMinutes(seconds:Number):Number
		{
			return seconds / 60;
		}
		
		public static function minutesToHours(minutes:Number):Number
		{
			return minutes / 60;
		}
		
		public static function hoursToDays(hours:Number):Number
		{
			return hours / 24;
		}
		
		public static function daysToHours(days:Number):Number
		{
			return days * 24;
		}
		
		public static function hoursToMinutes(hours:Number):Number
		{
			return hours * 60;
		}
		
		public static function minutesToSeconds(minutes:Number):Number
		{
			return minutes * 60;
		}
		
		public static function secondsToMillSeconds(seconds:Number):Number
		{
			return seconds * 1000;
		}
		
		/**
		 * 
		 * @param date 2009-12-10 14:15:14
		 * 
		 */		
		public static function parseDate(date:String):Date
		{
			var d:Array = date.split(" ");
			if(d.length < 2)return null;
			var y:Array = d[0].split("-");
			if(y.length < 3)return null;
			var t:Array = d[1].split(":");
			if(t.length < 3)return null;
			return new Date(int(y[0]),int(y[1])-1,int(y[2]),int(t[0]),int(t[1]),int(t[2]));
		}
	}
}

