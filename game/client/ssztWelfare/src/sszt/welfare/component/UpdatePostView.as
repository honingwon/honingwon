package sszt.welfare.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTextArea;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.welfare.BoxBgAsset;
	import ssztui.welfare.updateTitleAsset;

	public class UpdatePostView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _content:MTextArea;
		
		public function UpdatePostView()
		{
			initView();
		}
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(0,0,666,361)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(0,4,666,33)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(114,10,419,20),new Bitmap(new updateTitleAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,38,650,315),new BoxBgAsset()),
			]);
			addChild(_bg as DisplayObject);
			
			_content = new MTextArea();
			_content.textField.defaultTextFormat = new TextFormat("SimSun",12,0xe2d8b8,null,null,null,null,null,null,null,null,null,8);
			_content.setSize(641,296);
			_content.move(22,48);
			_content.editable = false;
			_content.enabled = true;
			_content.verticalScrollPolicy = ScrollPolicy.AUTO;
			_content.horizontalScrollPolicy = ScrollPolicy.OFF;
			_content.appendText("");
			addChild(_content);
			
			_content.htmlText = LanguageManager.getWord("ssztl.welfare.updatePost");
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}