package com.codeTooth.actionscript.components.controls
{
	import com.codeTooth.actionscript.components.core.AbstractComponent;
	
	import flash.display.DisplayObject;
	
	public class ProgressBar extends AbstractComponent
	{
		public function ProgressBar()
		{
			_width = 200;
			_height = 5;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 进度值
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _value:Number = .5;
		
		/**
		 * 当前的进度值，这个值在0到1之间
		 */		
		public function set value(value:Number):void
		{
			_value = Math.min(Math.max(value, 0), 1);
			
			_bar.width = _background.width * _value;
		}
		
		/**
		 * @private
		 */		
		public function get value():Number
		{
			return _value;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set width(width:Number):void
		{
			_width = width;
			_background.width = _width;
		}
		
		override public function set height(height:Number):void
		{
			_height = height;
			_background.height = _height;
			_bar.height = _height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写 ISkinable 接口
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _skinNameBackground:String;
		
		private var _skinNameBar:String;
		
		private var _background:DisplayObject;
		
		private var _bar:DisplayObject;
		
		/**
		 * @inheritDoc
		 */		
		override public function updateSkin():void
		{
			if(_background != null)
			{
				removeChild(_background);
			}
			
			if(_bar != null)
			{
				removeChild(_bar);
			}
			
			_background = _skinsManager.createSkin(_skinNameBackground);
			addChild(_background);
			_background.width = _width;
			_background.height = _height;
			
			_bar = _skinsManager.createSkin(_skinNameBar);
			addChild(_bar);
			_bar.height = _height;
			
			value = _value;
		}
		
		/**
		 * @private
		 */		
		public function get skinNameBackground():String
		{
			return _skinNameBackground;
		}
		
		/**
		 * @private
		 */
		public function set skinNameBackground(value:String):void
		{
			_skinNameBackground = value;
		}

		/**
		 * @private
		 */
		public function get skinNameBar():String
		{
			return _skinNameBar;
		}

		/**
		 * @private
		 */
		public function set skinNameBar(value:String):void
		{
			_skinNameBar = value;
		}
	}
}