package com.codeTooth.actionscript.interaction.dragDrop.core
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class DragData implements IDestroy
	{
		private var _image:DisplayObject = null;
		
		private var _data:Object = null;
		
		private var _alpha:Number = -1;
		
		private var _offsetX:Number = -1;
		
		private var _offsetY:Number = -1;
		
		public function DragData(image:DisplayObject, 
												data:Object, alpha:Number = .5, 
												offsetX:Number = 0, offsetY:Number = 0)
		{
			if(image == null)
			{
				throw new NullPointerException("Null image");
			}
			
			if(data == null)
			{
				throw new NullPointerException("Null data");
			}
			
			_image = image;
			if(_image is DisplayObjectContainer)
			{
				var imageContainer:DisplayObjectContainer = DisplayObjectContainer(_image);
				imageContainer.mouseChildren = false;
				imageContainer.mouseEnabled = false;
			}
			
			_data = data;
			
			_alpha = alpha;
			
			_offsetX = offsetX;
			
			_offsetY = offsetY;
		}
		
		public function get image():DisplayObject
		{
			return _image;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		//-------------------------------------------------------------------------------------------
		// 实现IDestroy接口
		//-------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_image = null;
			_data = null;
		}
	}
}