package com.codeTooth.actionscript.components.controls
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 带有标签的开关模式按钮
	 */	
	
	public class LabelSwitchButton extends AbstractButton
	{
		public function LabelSwitchButton()
		{
			_width = 14;
			_height = 14;
			
			_mode = ButtonMode.SWITCH;
			
			_label = new TextField();
			addChild(_label);
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.selectable = false;
			_label.x = _width;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写是否可用
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set enabled(bool:Boolean):void
		{
			if(_enabled != bool)
			{
				updateTextFormat(bool);
			}
			
			super.enabled = bool;
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
			_disabledTextFormat = textFormats.disabledTextFormat
			
			updateTextFormat(_enabled);
			positionLabelY();
			calculateHeight();
			calculateWidth();
		}
		
		private function updateTextFormat(enabled:Boolean):void
		{
			if(enabled)
			{
				_label.defaultTextFormat = _enabledTextFormat;
				_label.setTextFormat(_enabledTextFormat);
			}
			else
			{
				_label.defaultTextFormat = _disabledTextFormat;
				_label.setTextFormat(_disabledTextFormat);
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写模式
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set mode(mode:String):void
		{
			// do nothing
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set width(width:Number):void
		{
			// do nothing
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(height:Number):void
		{
			// do nothing
		}
		
		private function calculateHeight():void
		{
			_height = Math.max(super.height, _label.height);
		}
		
		private function calculateWidth():void
		{
			_width = super.width + _label.width;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 标签
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _label:TextField;
		
		/**
		 * 显示的标签
		 */		
		public function set label(label:String):void
		{
			_label.text = label;
			positionLabelY();
			calculateHeight();
			calculateWidth();
		}
		
		/**
		 * @private
		 */		
		public function get label():String
		{
			return _label.text;
		}
		
		// 定位标签的y坐标
		private function positionLabelY():void
		{
			_label.y = (_height - _label.height) * .5
			calculateHeight();
		}
	}
}