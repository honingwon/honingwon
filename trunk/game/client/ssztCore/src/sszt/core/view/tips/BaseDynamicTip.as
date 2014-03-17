package sszt.core.view.tips
{
	import flash.text.TextFormat;

	public class BaseDynamicTip extends BaseTip
	{
		protected var _currentIndex:int;
		
		public function BaseDynamicTip()
		{
			_currentIndex = 0;
			super();
		}
		
		protected function addStringToField(tip:String, format:TextFormat, wrap:Boolean = true, isHtml:Boolean = false, color:String = "#ffffff") : void
		{
			if (tip != "")
			{
				if (_text.length > 0 && wrap)
				{
					_text.appendText("\n");
				}
				if (isHtml)
				{
					_text.htmlText = _text.htmlText + "<font color = \'" + color + "\'>" + tip + "</font>";
				}
				else
				{
					_text.appendText(tip);
					if (this._currentIndex < _text.length)
					{
						_text.setTextFormat(format, this._currentIndex, _text.length);
					}
				}
				this._currentIndex = _text.length;
			}
		}
		
//		protected function addStringToField(tip:String,format:TextFormat,wrap:Boolean = true):void
//		{
//			if(tip != "")
//			{
//				if(_text.length > 0 && wrap)_text.appendText("\n");
//				_text.appendText(tip);
//				if(format!= null)
//					_text.setTextFormat(format,_currentIndex,_text.length);
//				_currentIndex = _text.length;
//			}
//		}
		
		override protected function clear():void
		{
			super.clear();
			_currentIndex = 0;
		}
	}
}