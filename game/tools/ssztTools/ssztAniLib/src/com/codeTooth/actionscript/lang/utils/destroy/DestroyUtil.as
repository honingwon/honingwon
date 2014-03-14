package com.codeTooth.actionscript.lang.utils.destroy
{		
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 销毁对象助手
	 */
	
	public class DestroyUtil
	{
		/**
		 * 销毁指定的对象
		 * 
		 * @param object 销毁的对象
		 */		
		public static function destroyObject(object:Object):void
		{	
			if(object is IDestroy)
			{
				IDestroy(object).destroy();
			}
		}
		
		/**
		 * 销毁数组
		 * 
		 * @param array 要销毁的数组
		 *
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的数组是null 
		 */		
		public static function destroyArray(array:Array):void
		{
			if(array == null)
			{
				throw new NullPointerException("Null array");
			}
			
			var length:int = array.length;
			var item:IDestroy = null;
			for(var i:int = length - 1; i >= 0; i--)
			{
				destroyObject(array[i]);
				array[i] = null;
			}
			array.length = 0;
		}
		
		/**
		 * 销毁键值map
		 * 
		 * @param map	指定销毁的map
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的map是null
		 */		
		public static function destroyMap(map:Object):void
		{
			if(map == null)
			{
				throw new NullPointerException("Null map");
			}
			
			var value:Object = null;
			for(var key:Object in map)
			{
				value = map[key];
				destroyObject(value);
				destroyObject(key);
				delete map[key];
			}
		}
		
		/**
		 * 断开数组和每个元素之间的引用
		 * 
		 * @param array 指定操作的数组
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的数组是null
		 */		
		public static function breakArray(array:Array):void
		{
			if(array == null)
			{
				throw new NullPointerException("Null array");
			}
			
			var length:int = array.length;
			for(var i:int = 0; i < length; i++)
			{
				array[i] = null;
			}
			array.length = 0;
		}
		
		/**
		 * 断开map与每个元素之间的引用
		 * 
		 * @param map 指定操作的map
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的map是null
		 */		
		public static function breakMap(map:Object):void
		{
			if(map == null)
			{
				throw new NullPointerException("Null map");
			}
			
			for(var key:Object in map)
			{
				delete map[key];
			}
		}
		
		/**
		 * 递归移除容器中的所有显示对象
		 * 
		 * @param container
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的容器是null
		 */
		public static function removeChildrenRecursive(container:DisplayObjectContainer):void
		{
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			
			var numberChildren:int = container.numChildren;
			var child:DisplayObject = null;
			for(var i:int = 0; i < numberChildren; i++)
			{
				child = container.removeChildAt(0);
				
				if(child is DisplayObjectContainer)
				{
					removeChildrenRecursive(DisplayObjectContainer(child));
				}
			}
		}
		
		/**
		 * 移除容器中的所有显示对象
		 * 
		 * @param container
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的容器是null
		 */		
		public static function removeChildren(container:DisplayObjectContainer):void
		{
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			
			var numberChildren:int = container.numChildren;
			for(var i:int = 0; i < numberChildren; i++)
			{
				container.removeChildAt(0);
			}
		}
		
		/**
		 * 移除并且销毁容器中的所有位图
		 * 
		 * @param container
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的容器是null
		 */		
		public function removeDisposeBitmaps(container:DisplayObjectContainer):void
		{
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			
			var numberChildren:int = container.numChildren;
			var child:DisplayObject = null;
			var bitmap:Bitmap = null;
			for(var i:int = 0; i < numberChildren; i++)
			{
				child = container.getChildAt(i);
				
				if(child is Bitmap)
				{
					bitmap = Bitmap(child);
					bitmap.bitmapData.dispose();
					bitmap.bitmapData = null;
					
					container.removeChildAt(i);
					i--;
					numberChildren--;
				}
			}
		}
	}
}