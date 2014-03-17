package sszt.scene.components.group.groupSec
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.view.tips.ChatPlayerTip;
	
	public class ChatItemView extends Sprite
	{
		private var _nameFiled:TextField;
		private var _clickBg:Sprite;
		private var _content:TextField;
		private var _info:ChatItemInfo;
		
		public function ChatItemView(info:ChatItemInfo)
		{
			_info = info;
			super();
			init();
		}
		
		private function init():void
		{
			_nameFiled = new TextField();
			_nameFiled.mouseEnabled = _nameFiled.mouseWheelEnabled = false;
			_nameFiled.x = 5;
			_nameFiled.y = 0;
			_nameFiled.height = 20;
			_nameFiled.textColor = 0x0000ff;
			_nameFiled.htmlText = "<u>["+_info.serverId+"]"+_info.fromNick + "</u>"
			addChild(_nameFiled);
			
			_clickBg = new Sprite();
			_clickBg.buttonMode = true;
			_clickBg.graphics.beginFill(0,0);
			_clickBg.graphics.drawRect(0,0,_nameFiled.textWidth,18);
			_clickBg.graphics.endFill();
			addChild(_clickBg);
			_clickBg.addEventListener(MouseEvent.CLICK,clickHandler);
			
			_content = new TextField();
			_content.textColor = 0xffffff;
			_content.wordWrap = true;
			_content.x = 5;
			_content.y = 20;
			_content.width = 270;
			_content.mouseEnabled = _content.mouseWheelEnabled = false;
			_content.text = _info.message;
			addChild(_content);
		}
		
		public function getHeight():int
		{
			return _nameFiled.height + _content.textHeight;
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			if(_info.fromId != GlobalData.selfPlayer.userId)
			{
				ChatPlayerTip.getInstance().show(_info.serverId,_info.fromId,_info.fromNick,new Point(evt.stageX,evt.stageY),_info.career);
			}	
		}
		
		public function dispose():void
		{
			_clickBg.removeEventListener(MouseEvent.CLICK,clickHandler);
			_clickBg = null;
			_nameFiled = null;
			_content = null;
			if(parent) parent.removeChild(this);
		}
		
	}
}