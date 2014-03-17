package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	public class RoleAlert extends Sprite
	{
//		private var _asset:RoleAlertAsset;
		private var _btn:RoleBtn;
		private var _content:String;
		private var _contentField:TextField;
		private var _link:String;
		
		public function RoleAlert()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_btn
			graphics.beginFill(0,0);
			graphics.drawRect(-2000,-2000,2000,2000);
			graphics.endFill();
			
			x = 350;
			y = 190;
			
//			_asset = new RoleAlertAsset();
//			addChild(_asset);
			_contentField = new TextField();
			_contentField.width = 258;
			_contentField.height = 20;
			_contentField.x = 35;
			_contentField.y = 71;
			var format:TextFormat = new TextFormat("宋体",12,0xfffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_contentField.setTextFormat(format);
			_contentField.defaultTextFormat = format;
			addChild(_contentField);
			_btn = new RoleBtn("确定");
			_btn.x = 127;
			_btn.y = 124;
			addChild(_btn);
		}
		
		public function show(descript:String,container:DisplayObjectContainer,link:String = ""):void
		{
			_contentField.text = descript;
			_link = link;
			container.addChild(this);
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		private function initEvent():void
		{
			_btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		private function removeEvent():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			hide();
			if(_link != null)
			{
				navigateToURL(new URLRequest(_link),"_self");
			}
		}
		
		public function dispose():void
		{
			hide();
		}
	}
}