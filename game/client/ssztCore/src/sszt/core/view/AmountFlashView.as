package sszt.core.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.label.MAssetLabel;

	public class AmountFlashView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _text:MAssetLabel;

		public function AmountFlashView(clickBoolean:Boolean = false)
		{
			setClick(clickBoolean);
			init();
		}
		private function init():void
		{
			
			_bg = GlobalAPI.movieManagerApi.getMovieWrapper(AssetUtil.getAsset("ssztui.common.MailAsset",MovieClip) as MovieClip,29,29,7);
			_bg.x = -4;
			_bg.y = -7;
			_bg.play();
			addChild(_bg as DisplayObject);
			
			
			_text = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_text.move(8.5,-1);
			_text.setLabelType([new TextFormat("Tahoma",10,0xfffccc,true,null,null,null,null,TextFormatAlign.CENTER)]);
			addChild(_text);
		}
		
		public function setValue(n:String):void
		{
			_text.setHtmlValue(n);
		}
		public function setClick(b:Boolean):void
		{
			this.mouseEnabled = this.mouseChildren = b;
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose()
				_bg = null;
			}
			_text = null;
		}
		
	}
}