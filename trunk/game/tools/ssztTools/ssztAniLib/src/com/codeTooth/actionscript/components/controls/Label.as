package com.codeTooth.actionscript.components.controls
{
	import com.codeTooth.actionscript.components.core.AbstractComponent;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 标签
	 */	
	
	public class Label extends AbstractComponent
	{
		// 文本框
		private var _textField:TextField;
		
		public function Label()
		{
			_textField = new TextField();
			addChild(_textField);
			
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			
			_width = _textField.width;
			_height = _textField.height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set enabled(bool:Boolean):void
		{
			if(_enabled != bool)
			{
				mouseChildren = bool;
				mouseEnabled = bool;
				_enabled = bool;
				updateTextFormat();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */		
		override public function set width(width:Number):void
		{
			_textField.width = width;
			_width = _textField.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(height:Number):void
		{
			_textField.height = height;
			_height = _textField.height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写 IStyleable 接口
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _enabledTextFormat:TextFormat;
		
		private var _disabledTextFormat:TextFormat;
		
		/**
		 * @inheritDoc
		 */
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
		// 是否可选
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 标签的文本框是否可选
		 */		
		public function set selectable(bool:Boolean):void
		{
			_textField.selectable = bool;
		}
		
		/**
		 * @private
		 */		
		public function get selectable():Boolean
		{
			return _textField.selectable;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 设置文本
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 显示的文本
		 */		
		public function set text(text:String):void
		{
			_textField.text = text;
			_height = _textField.height;
		}
		
		/**
		 * @private
		 */		
		public function get text():String
		{
			return _textField.text;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 换行
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 显示的文本是否换行
		 */		
		public function set worldWap(bool:Boolean):void
		{
			_textField.wordWrap = bool;
		}
		
		/**
		 * @private
		 */		
		public function get worldWap():Boolean
		{
			return _textField.wordWrap;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 文本样式
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 文本的样式
		 */		
		public function set textFormat(textFormat:TextFormat):void
		{
			_textField.setTextFormat(textFormat);
		}
		
		/**
		 * @private
		 */		
		public function get textFormat():TextFormat
		{
			return _textField.getTextFormat();
		}
	}
}