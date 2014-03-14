package com.codeTooth.actionscript.lang.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	public class Size 
	{
		static public function rectangleMatching(originRect:Rectangle, targetRect:Rectangle):Rectangle 
		{
			var p:Number;
			var result:Rectangle = new Rectangle();
			var originP:Number = originRect.width / originRect.height;
			var targetP:Number = targetRect.width / targetRect.height;
			if (originP >= targetP) 
			{
				p = targetRect.width / originRect.width;
				result.width = originRect.width * p;
				result.height = originRect.height * p;
			}
			else 
			{
				p =  targetRect.height / originRect.height;
				result.width = originRect.width * p;
				result.height = originRect.height * p;
			}
			return result;
		}
	}
	
}