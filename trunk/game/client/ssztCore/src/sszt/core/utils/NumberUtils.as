package sszt.core.utils
{
	public class NumberUtils
	{
		public static function getNumberInBound(min:Number,max:Number,n:Number):Number
		{
			if(n < min)return min;
			if(n > max)return max;
			return n;
		}
	}
}
