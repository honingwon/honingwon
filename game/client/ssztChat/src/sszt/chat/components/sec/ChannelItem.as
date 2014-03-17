package sszt.chat.components.sec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.utils.SHA256;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	
	import ssztui.ui.BorderAsset5;
	
	public class ChannelItem extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _textfield:TextField;
		private var _label:String;
		
		public function ChannelItem(label:String)
		{
			_label = label;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			this.buttonMode = true;
			
			_bg = BackgroundUtils.setBackground([new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,50,18),new Bitmap(new BorderAsset5() as BitmapData))]);
			addChild(_bg as DisplayObject);
			_bg.visible = false;
			
			_textfield = new TextField();
			_textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,TextFormatAlign.CENTER);
			_textfield.y = 1;
			_textfield.width = 50;
			_textfield.height = 16;
			_textfield.text = _label;			
			_textfield.mouseEnabled = false;
			addChild(_textfield);
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			_bg.visible = true;
//			_textfield.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER));
		}
		
		private function outHandler(e:MouseEvent):void
		{
			_bg.visible = false;
//			_textfield.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xF7EEA0,null,null,null,null,null,TextFormatAlign.CENTER));
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			_bg = null;
			_label = null;
			_textfield = null;
		}
	}
}