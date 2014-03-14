package com.codeTooth.actionscript.classesLoader.core
{		
	import flash.utils.ByteArray;
	
	/**
	 * 二进制修改器接口
	 */
	
	public interface IByteArrayModifier
	{
		/**
		 * 修改二进制数据，
		 * 二进制加载器会把加载到的字节数组作为参数传入该方法，
		 * 用户自定义方法来修改字节数组
		 * 
		 * @param byteArray 
		 */		
		function modifyByteArray(byteArray:ByteArray):void;
	}
}