package com.codeTooth.actionscript.components.controls
{
	import com.codeTooth.actionscript.components.controls.numericStepperClasses.DecreaseButton;
	import com.codeTooth.actionscript.components.controls.numericStepperClasses.IncreaseButton;
	import com.codeTooth.actionscript.components.core.AbstractComponent;
	import com.codeTooth.actionscript.components.core.ComponentsApplication;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NumericStepper extends AbstractComponent
	{	
		public function NumericStepper()
		{
			_textInput = ComponentsApplication.getInstance().createComponent("textInput");
			addChild(_textInput);
			_textInput.restrict = "0-9";
			_textInput.addEventListener(Event.CHANGE, textInputChangeHandler);
			
			_increaseButton = ComponentsApplication.getInstance().createComponent("increaseButton");
			addChild(_increaseButton);
			_increaseButton.y = _textInput.height * .5 - _increaseButton.height;
			_increaseButton.addEventListener(MouseEvent.CLICK, increaseClickHandler);
			
			_decreaseButton = ComponentsApplication.getInstance().createComponent("decreaseButton");
			addChild(_decreaseButton);
			_decreaseButton.y = _increaseButton.y + _increaseButton.height;
			_decreaseButton.addEventListener(MouseEvent.CLICK, decreaseClickHandler);
			
			width = 100;
			updateTextInput();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  极限范围
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _value:int = 0;
		
		private var _minValue:int = 0;
		
		private var _maxValue:int = 10;

		public function get maxValue():int
		{
			return _maxValue;
		}

		public function set maxValue(value:int):void
		{
			_maxValue = value < _value ? _value : value;
		}
		
		public function get minValue():int
		{
			return _minValue;
		}
		
		public function set minValue(value:int):void
		{
			_minValue = value > _value ? _value : value;
		}
		
		public function set value(value:int):void
		{
			_value = getLimitedValue(value);
			updateTextInput();
		}
		
		public function get value():int
		{
			return _value;
		}
		
		private function getLimitedValue(value:int):int
		{
			return Math.min(Math.max(value, _minValue), _maxValue);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  重写是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set enabled(bool:Boolean):void
		{
			if(_enabled != bool)
			{
				_enabled = bool;
				_textInput.enabled = _enabled;
				_increaseButton.enabled = _enabled;
				_decreaseButton.enabled = _enabled;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set width(width:Number):void
		{
			if(_width != width)
			{
				_width = width;
				_textInput.width = _width;
				_increaseButton.x = _width - _increaseButton.width;
				_decreaseButton.x = _width - _decreaseButton.width;
			}
		}
		
		override public function set height(height:Number):void
		{
			// donothing
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  输入文本框
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _textInput:TextInput;
		
		private function updateTextInput():void
		{
			_textInput.text = String(_value);
		}
		
		private function textInputChangeHandler(event:Event):void
		{
			_value = getLimitedValue(int(_textInput.text));
			_textInput.text = String(_value);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		//  递增递减按钮
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _increaseButton:IncreaseButton;
		
		private var _decreaseButton:DecreaseButton;
		
		private function increaseClickHandler(event:MouseEvent):void
		{
			value++;
		}
		
		private function decreaseClickHandler(event:MouseEvent):void
		{
			value--;
		}
	}
}