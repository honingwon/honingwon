package com.codeTooth.actionscript.components.controls
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 标准按钮
	 */	
	
	public class Button extends AbstractButton
	{
		public function Button()
		{
			_label = new TextField();
			addChild(_label);
			_label.selectable = false;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.mouseEnabled = false;
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
			_disabledTextFormat = textFormats.disabledTextFormat;
			
			updateTextFormat(_enabled);
			repositionLabelX();
			repositionLabelY();
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
		// 重写宽高
		//--------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set width(width:Number):void
		{
			super.width = width;
			
			repositionLabelX();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(height:Number):void
		{
			super.height = height;
			
			repositionLabelY();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 按钮标签
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _label:TextField;
		
		/**
		 * 按钮显示的标签文字
		 */		
		public function set label(label:String):void
		{
			_label.text = label;
			repositionLabelX();
			repositionLabelY();
		}
		
		/**
		 * @private
		 */		
		public function get label():String
		{
			return _label.text;
		}
		
		// 设置文字的位置居中
		private function repositionLabelX():void
		{
			_label.x = (_width - _label.width) * .5;
		}
		
		private function repositionLabelY():void
		{
			_label.y = (_height - _label.height) * .5;
		}
	}
}