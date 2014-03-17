package sszt.core.caches
{

	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


    public class FightText extends TextField
    {
        private var format:TextFormat;
        private var _isScale:Boolean;
        private var _textColor:uint = 16765440;
		private var _textFont:String = null;
		private var _textSize:int = 0;

        public function FightText(str:String = null, isScale:Boolean = false, textColor:uint = 0xFFD200,offsetX:int = 0, offsetY:int = 0, 
								  textFont:String = null,textSize:int = 0)
        {
            this.embedFonts = true;
            this._textColor = textColor;
            this._textFont = textFont;
            this._textSize = textSize;
          
            this.setStyle();
            if (str != null)
            {
                this.text = str;
            }
            this._isScale = isScale;
			
            this.mouseEnabled = false;
            this.cacheAsBitmap = true;
        }


        private function setStyle() : void
        {
            this.format = new TextFormat();
            this.format.font = _textFont;
            this.format.size = _textSize;
            this.format.bold = true;
            this.format.align = "center";
            this.defaultTextFormat = this.format;
            this.selectable = false;
            this.textColor = _textColor;
			this.autoSize = TextFormatAlign.LEFT;
            this.filters = [new GlowFilter(0x000000,1,2,2,10)];
        }

    }
}
