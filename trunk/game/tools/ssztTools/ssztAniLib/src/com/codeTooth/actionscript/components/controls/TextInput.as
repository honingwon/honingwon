package com.codeTooth.actionscript.components.controls
{
	import com.codeTooth.actionscript.components.core.AbstractComponent;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class TextInput extends AbstractComponent
	{
		public function TextInput()
		{
			_width = 100;
			_height = 22;
			
			_textField = new TextField();
			addChild(_textField);
			_textField.type = TextFieldType.INPUT;
			_textField.width = _width;
			_textField.height = _height;
		}

		//---------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */		
		override public function set width(width:Number):void
		{
			_width = width;
			_backgroundEnabled.width = _width;
			_backgroundDisabled.width = _width;
			_textField.width = _width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(height:Number):void
		{
			_height = height;
			_backgroundEnabled.height = _height;
			_backgroundDisabled.height = _height;
			_textField.height = _height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set enabled(bool:Boolean):void
		{
			if(_enabled != bool)
			{
				_enabled = bool;
				
				removeChild(_currentBackground);
				_currentBackground = _enabled ? _backgroundEnabled : _backgroundDisabled;
				addChildAt(_currentBackground, 0);
				
				if(_enabled)
				{
					_textField.type = _editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
				}
				else
				{
					_textField.type = TextFieldType.DYNAMIC
				}
				
				updateTextFormat();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写 IStyleable 接口
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _enabledTextFormat:TextFormat;
		
		private var _disabledTextFormat:TextFormat;
		
		override public function updateStyle():void
		{
			var textFormats:Object = _stylesManager.createStyle(_styleName);
			_enabledTextFormat = textFormats.enabledTextFormat;
			_disabledTextFormat = textFormats.disabledTextFormat;
			
			updateTextFormat();
		}
		
		private function updateTextFormat():void
		{
			if(_enabled)
			{
				_textField.defaultTextFormat = _enabledTextFormat;
				_textField.setTextFormat(_enabledTextFormat);
			}
			else
			{
				_textField.defaultTextFormat = _disabledTextFormat;
				_textField.setTextFormat(_disabledTextFormat);
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写 ISkinable 接口
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _currentBackground:DisplayObject;
		
		private var _skinNameBackgroundEnabled:String;
		
		private var _backgroundEnabled:DisplayObject;
		
		private var _skinNameBackgroundDisabled:String;
		
		private var _backgroundDisabled:DisplayObject;
		
		/**
		 * @inheritDoc
		 */
		override public function updateSkin():void
		{
			_backgroundEnabled = _skinsManager.createSkin(_skinNameBackgroundEnabled);
			_backgroundEnabled.width = _width;
			_backgroundEnabled.height = _height;
			
			_backgroundDisabled = _skinsManager.createSkin(_skinNameBackgroundDisabled);
			_backgroundDisabled.width = _width;
			_backgroundDisabled.height = _height;
			
			if(_currentBackground != null)
			{
				removeChild(_currentBackground);
			}
			
			_currentBackground = _enabled ? _backgroundEnabled : _backgroundDisabled;
			addChildAt(_currentBackground, 0);
		}
		
		/**
		 * @private
		 */
		public function set skinNameBackgroundEnabled(skinName:String):void
		{
			_skinNameBackgroundEnabled = skinName;
		}
		
		/**
		 * @private
		 */
		public function get skinNameBackgroundEnabled():String
		{
			return _skinNameBackgroundEnabled;
		}
		
		/**
		 * @private
		 */
		public function set skinNameBackgroundDisabled(skinName:String):void
		{
			_skinNameBackgroundDisabled = skinName;
		}
		
		/**
		 * @private
		 */
		public function get skinNameBackgroundDisabled():String
		{
			return _skinNameBackgroundDisabled;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 输入框
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _textField:TextField;
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 显示为密码文本字段
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 显示为密码文本字段
		 */		
		public function set displayAsPassword(bool:Boolean):void
		{
			_textField.displayAsPassword = bool;
		}
		
		/**
		 * @private
		 */
		public function get displayAsPassword():Boolean
		{
			return _textField.displayAsPassword;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 最多包含的字符数
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 最多包含的字符数
		 */		
		public function set maxChars(maxChars:int):void
		{
			_textField.maxChars = maxChars;
		}
		
		/**
		 * @private
		 */
		public function get maxChars():int
		{
			return _textField.maxChars;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 文本
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 文本
		 */		
		public function set text(text:String):void
		{
			_textField.text = text;
		}
		
		/**
		 * @private
		 */
		public function get text():String
		{
			return _textField.text;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 是否可以输入
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _editable:Boolean = true;
		
		/**
		 * 是否可以输入
		 */		
		public function set editable(bool:Boolean):void
		{
			if(_editable != bool)
			{
				_editable = bool;
				
				_textField.type = _editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			}
		}
		
		/**
		 * @private
		 */
		public function get editable():Boolean
		{
			return _editable;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 可接受的字符串
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 可接受的字符串
		 */		
		public function set restrict(restrict:String):void
		{
			_textField.restrict = restrict;
		}
		
		/**
		 * @private
		 */
		public function get restrict():String
		{
			return _textField.restrict;
		}
	}
}