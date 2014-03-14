package com.codeTooth.actionscript.components.styles
{
	import flash.text.TextFormat;
	
	public class TextInputStyle implements IStyle
	{
		public function TextInputStyle()
		{
			_enabledTextFormat = new TextFormat(null, 13, 0x000000);
			_disabledTextFormat = new TextFormat(null, 13, 0xC0C0C0);
		}
		
		private var _enabledTextFormat:TextFormat;
		
		private var _disabledTextFormat:TextFormat;
		
		public function getStyle():*
		{
			return { enabledTextFormat:_enabledTextFormat, disabledTextFormat:_disabledTextFormat };
		}
	}
}