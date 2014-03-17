package sszt.core.utils
{
	public class ArrayUtil
	{
		
		/**
		 * 删除前后空元素,数组是由字符串分割出来
		 * @param arr
		 * @return 
		 * 
		 */		
		public static function trimStringArray(arr:Array):Array
		{
			if(arr[0] == "" || arr[0] == undefined)arr.splice(0,1);
			if(arr.length > 0)
			{
				if(arr[arr.length - 1] == "" || arr[arr.length - 1] == undefined)
					arr.splice(arr.length,1);
			}
			return arr;
		}
	}
}