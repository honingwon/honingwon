package sszt.stall.compoments.itemView
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.stall.StallMessageItemInfo;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.core.view.tips.TargetMenuTip;
	
	public class MessageContentItemView extends Sprite
	{
		private var _messageContent:StallMessageItemInfo;
		private var _nickTextField:MAssetLabel;
		private var _contentTextField:MAssetLabel;
		private var _width:int;
		private var _nickBackground:Sprite;
		public function MessageContentItemView(value:StallMessageItemInfo,argWidth:int)
		{
			super();
			_messageContent = value;
			_width = argWidth;
			updateView();
			initialEvents();
		}
		
		private function updateView():void
		{
			_nickTextField = new MAssetLabel("",MAssetLabel.LABELTYPE1)
			_nickTextField.autoSize = TextFieldAutoSize.LEFT;
			_nickTextField.selectable = false;
			_nickTextField.x = 0;
			_nickTextField.y = 0;
			_nickTextField.htmlText = "<u>" + _messageContent.nick + "</u>";
			_nickTextField.height = _nickTextField.textHeight;
			_nickTextField.width = _nickTextField.textWidth;
			addChild(_nickTextField);
			
			_nickBackground = new Sprite();
			_nickBackground.graphics.beginFill(0,0);
			_nickBackground.graphics.drawRect(_nickTextField.x,_nickTextField.y,_nickTextField.width,_nickTextField.height);
			_nickBackground.graphics.endFill();
			_nickBackground.buttonMode = true;
			addChild(_nickBackground);
			
			_contentTextField = new MAssetLabel("",MAssetLabel.LABELTYPE14);
			_contentTextField.multiline = true;
			_contentTextField.wordWrap = true;
			_contentTextField.autoSize = TextFieldAutoSize.LEFT;
			_contentTextField.x =_nickTextField.x + _nickTextField.textWidth +4;
			_contentTextField.y = 0;
			_contentTextField.text = "给你留言：" + _messageContent.messageContent;
			_contentTextField.height = _contentTextField.textHeight;
			_contentTextField.width = _width - _nickTextField.x - _nickTextField.width;
			addChild(_contentTextField);
		}
		
		private function initialEvents():void
		{
			_nickBackground.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvents():void
		{
			_nickBackground.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		private function clickHandler(e:MouseEvent):void
		{
			ChatPlayerTip.getInstance().show(0,_messageContent.userId,_messageContent.nick,new Point(e.stageX,e.stageY));
		}
		
		public function dispose():void
		{
			removeEvents();
			_messageContent = null;
			_nickTextField = null;
			_contentTextField = null;
			_nickBackground = null;
		}
	}
}