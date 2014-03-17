package sszt.ui.button
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;

	public class MTextButton extends MSprite
	{
		private var _labelText:String;
		private var _label:MAssetLabel;
		private var _upColor:int;
		private var _overColor:int;
		private var _underline:Boolean;
		private var _btnMode:MSprite;
		
		public function MTextButton(text:String,upColor:int=0xfffccc,overColor:int=0,underline:Boolean=true)
		{
			_labelText = text;
			_upColor = upColor;
			_overColor = overColor==0?upColor:overColor;
			_underline = underline;
			initView();
			initEvent();
		}
		private function initView():void
		{
			_label = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_label.textColor = _upColor;
			addChild(_label);
			var con:String = !_underline?_labelText:"<u>"+ _labelText +"</u>";
			_label.setHtmlValue(con);
			
			_btnMode = new MSprite();
			_btnMode.graphics.beginFill(0,0);
			_btnMode.graphics.drawRect(0,0,_label.textWidth,20);
			_btnMode.graphics.endFill();
			addChild(_btnMode);
			_btnMode.buttonMode = true;
			
		}
		private function initEvent():void
		{
			_btnMode.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btnMode.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function removeEvent():void
		{
			_btnMode.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btnMode.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			var con:String = _underline?_labelText:"<u>"+ _labelText +"</u>";
			_label.setHtmlValue(con);
			_label.textColor = _upColor;
		}
		private function outHandler(e:MouseEvent):void
		{
			var con:String = !_underline?_labelText:"<u>"+ _labelText +"</u>";
			_label.setHtmlValue(con);
			_label.textColor = _overColor;
		}
		override public function dispose() : void
		{
			removeEvent();
			_labelText = null;
			if(_btnMode)
			{
				_btnMode.graphics.clear();
				_btnMode = null;
			}
			_label = null;
			super.dispose();
		}
	}
}