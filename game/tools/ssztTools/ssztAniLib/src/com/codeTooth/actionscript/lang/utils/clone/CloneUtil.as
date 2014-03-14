package com.codeTooth.actionscript.lang.utils.clone
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.clone.ICloneable;
	
	import flash.utils.ByteArray;
	
	/**
	 * 克隆对象助手
	 */	
	
	public class CloneUtil
	{
		/**
		 * 浅克隆一个对象<br/>
		 * 如果对象中存储的不是简单数据类型，将直接复制引用<br/>
		 * 如果传入的对象实现了ICloneabl接口，将直接返回ICloneable的clone方法的返回值
		 * 
		 * @param sourceObject 要进行克隆的对象
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 传入的是null
		 * 
		 * @return 
		 */		
		public static function shallowClone(sourceObject:Object):Object
		{
			if(sourceObject == null)
			{
				throw new NullPointerException("Null target object");
			}
			
			if(sourceObject is ICloneable)
			{
				return ICloneable(sourceObject).clone();
			}
			else
			{
				var object:Object = new Object();
				for(var pName:Object in sourceObject)
				{
					object[pName] = sourceObject[pName];
				}
				
				return object;
			}
		}
		
		/**
		 * 深克隆一个对象，将对传入的对象做一个完全一样的拷贝，并且对结果对象的操作不会影响到原对象<br/>
		 * 如果传入的对象实现了ICloneabl接口，将直接返回ICloneable的clone方法的返回值<br/>
		 * 对于传入的对象将只深拷贝所有的寄存器和属性，方法将不会被拷贝，并且不能对克隆的对象进行强制类型转换
		 * 
		 * @param sourceObject 要进行克隆的对象
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的克隆对象是null
		 * 
		 * @return 
		 */		
		public static function deepClone(sourceObject:Object):Object
		{
			if(sourceObject == null)
			{
				throw new NullPointerException("Null target object");
			}
			
			if(sourceObject is ICloneable)
			{
				return ICloneable(sourceObject).clone();
			}
			else
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeObject(sourceObject);
				byteArray.position = 0;
				return byteArray.readObject();
			}
		}
	}
}