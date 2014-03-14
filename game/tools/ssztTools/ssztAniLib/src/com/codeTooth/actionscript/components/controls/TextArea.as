package com.codeTooth.actionscript.components.controls
{
	import com.codeTooth.actionscript.components.core.AbstractComponent;
	import com.codeTooth.actionscript.components.core.ComponentsApplication;
	import com.codeTooth.actionscript.components.events.ScrollBarEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class TextArea extends AbstractComponent
	{
		public function TextArea()
		{
			_width = 150;
			_height = 100;
			
			_textField = new TextField();
			addChild(_textField);
			_textField.wordWrap = true;
			_textField.multiline = true;
			_textField.addEventListener(Event.CHANGE, textFieldChangeHandler);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 垂直滚动条
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _vScrollBar:VScrollBar;
		
		private function resizeScrollBarHeight():void
		{
			_vScrollBar.height = _height;
		}
		
		private function repositionVScrollBar():void
		{
			_vScrollBar.x = _width - _vScrollBar.width;
		}
		
		private function resetVScrollBar():void
		{
			_vScrollBar.pageHeight = _textField.numLines - _textField.maxScrollV + 1;
			_vScrollBar.scrollHeight = _textField.numLines;
			_vScrollBar.minScrollPosition = 1;
			_vScrollBar.maxScrollPosition = _textField.maxScrollV;
			_vScrollBar.scrollPosition = _textField.bottomScrollV;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 文本框
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _textField:TextField;
		
		// 当文本框中的文字发生变化时触发
		private function textFieldChangeHandler(event:Event):void
		{
			if(_textField.maxScrollV > 1)
			{
				if(_vScrollBar == null)
				{
					_vScrollBar = ComponentsApplication.getInstance().createComponent("vScrollBar");
					_vScrollBar.addEventListener(ScrollBarEvent.SCROLL, vScrollBarScrollHandler);
					repositionVScrollBar();
					resizeScrollBarHeight();
				}
				addChild(_vScrollBar);
				resetVScrollBar();
			}
			else
			{
				if(_vScrollBar != null && contains(_vScrollBar))
				{
					removeChild(_vScrollBar);
				}
			}
		}
		
		private function resizeTextFieldWidth(width:Number):void
		{
			_textField.width = width;
		}
		
		private function resizeTextFieldHeight(height:Number):void
		{
			_textField.height = height;
		}
		
		private function vScrollBarScrollHandler(event:ScrollBarEvent):void
		{
			_textField.scrollV = event.scrollPosition;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set width(width:Number):void
		{
			if(_width != width)
			{
				_width = width;
				resizeBackgroundWidth();
				resizeTextFieldWidth(_width);
				repositionVScrollBar();
			}
		}
		
		override public function set height(height:Number):void
		{
			if(_height != height)
			{
				_height = height;
				resizeBackgroundHeight();
				resizeTextFieldHeight(_height);
				resizeScrollBarHeight();
				resetVScrollBar();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set enabled(bool:Boolean):void
		{
			if(_enabled != bool)
			{
				setEnabledInternal(bool);
			}
		}
		
		private function setEnabledInternal(bool:Boolean):void
		{
			_enabled = bool;
			_textField.type = _enabled ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			changeSkin();
			updateTextFormat();
			
			if(_vScrollBar != null)
			{
				_vScrollBar.enabled = _enabled;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写 IStyleable 接口  
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _enabledTextFormat:TextFormat;
		
		private var _disabledTextFormat:TextFormat;
		
		override public function updateStyle():void
		{
			var style:Object = _stylesManager.createStyle(_styleName);
			_enabledTextFormat = style.enabledTextFormat;
			_disabledTextFormat = style.disabledTextFormat;
			
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
		
		private var _skinNameBackgroundEnabled:String;
		
		private var _skinNameBackgroundDisabled:String;
		
		private var _backgroundEnabled:DisplayObject;
		
		private var _backgroundDisabled:DisplayObject;
		
		private var _currentBackground:DisplayObject
		
		override public function updateSkin():void
		{
			_backgroundEnabled = _skinsManager.createSkin(_skinNameBackgroundEnabled);
			_backgroundDisabled = _skinsManager.createSkin(_skinNameBackgroundDisabled);
			resizeBackgroundWidth();
			resizeBackgroundHeight();
			resizeTextFieldWidth(_width);
			resizeTextFieldHeight(_height);
			
			setEnabledInternal(_enabled);
		}
		
		private function changeSkin():void
		{
			if(_currentBackground != null)
			{
				removeChild(_currentBackground);
			}
			
			_currentBackground = _enabled ? _backgroundEnabled : _backgroundDisabled;
			addChildAt(_currentBackground, 0);
		}
		
		private function resizeBackgroundWidth():void
		{
			_backgroundEnabled.width = _width;
			_backgroundDisabled.width = _width;
		}
		
		private function resizeBackgroundHeight():void
		{
			_backgroundEnabled.height = _height;
			_backgroundDisabled.height = _height;
		}
		
		public function get skinNameBackgroundDisabled():String
		{
			return _skinNameBackgroundDisabled;
		}

		public function set skinNameBackgroundDisabled(value:String):void
		{
			_skinNameBackgroundDisabled = value;
		}

		public function get skinNameBackgroundEnabled():String
		{
			return _skinNameBackgroundEnabled;
		}

		public function set skinNameBackgroundEnabled(value:String):void
		{
			_skinNameBackgroundEnabled = value;
		}
	}
}