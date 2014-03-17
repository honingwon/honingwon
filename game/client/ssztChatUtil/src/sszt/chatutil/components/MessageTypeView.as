package sszt.chatutil.components
{
	import fl.controls.CheckBox;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.container.MSprite;
	
	import sszt.chatutil.StageUtil;
	import sszt.chatutil.data.ChatInfo;
	import sszt.core.data.chat.MessageType;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
//	import mhsm.ui.BorderAsset5;
	
	public class MessageTypeView extends MSprite
	{
//		private var _bg:BorderAsset5;
		private var _checkboxList:Array;
		private var _messageTypes:Array;
		private var _type:int;
		private var _chatInfo:ChatInfo;
		
		public function MessageTypeView(chatInfo:ChatInfo)
		{
			_chatInfo = chatInfo;
			super();
			initView();
		}
		
		private function initView():void
		{
//			_bg = new BorderAsset5();
//			_bg.width = 65;
//			_bg.height = 110;
//			addChild(_bg);
		}
		
		private function checkboxClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		private function checkboxChangeHandler(e:Event):void
		{
			var checkbox:CheckBox = e.currentTarget as CheckBox;
			var index:int;
			index = _checkboxList.indexOf(checkbox);
			if(_type == 1)
			{
				_chatInfo.getShowList()[_messageTypes[index]] = checkbox.selected;
			}
			else
			{
				_chatInfo.getShowList()[MessageType.SYSTEM] = checkbox.selected;
				_chatInfo.getShowList()[MessageType.CHAT] = checkbox.selected;
			}
		}
		
		public function show(type:int):void
		{
			_type = type;
			_checkboxList = [];
			_messageTypes = [];
			var labels:Array;
			if(_type == 1)
			{
//				_bg.height = 110;
				labels = ["世界",
					"阵营",
					"帮会",
					"队伍",
					"附近"];
				_messageTypes = [MessageType.WORLD,MessageType.CMP,MessageType.CLUB,MessageType.GROUP,MessageType.CURRENT];
			}
			else
			{
//				_bg.height = 35;
				labels = ["系统"];
				_messageTypes = [MessageType.SYSTEM];
			}
			for(var i:int = 0; i < labels.length; i++)
			{
				var checkbox:CheckBox = new CheckBox();
				checkbox.label = labels[i];
				checkbox.selected = _chatInfo.getShowList()[_messageTypes[i]];
				checkbox.setSize(55,20);
				checkbox.move(7,6 + i * 19);
				checkbox.addEventListener(MouseEvent.CLICK,checkboxClickHandler);
				checkbox.addEventListener(Event.CHANGE,checkboxChangeHandler);
				addChild(checkbox);
				_checkboxList.push(checkbox);
			}
			StageUtil.stage.addChild(this);
			StageUtil.stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
		}
		
		private function stageClickHandler(evt:MouseEvent):void
		{
			hide();
		}
		
		public function hide():void
		{
			if(_checkboxList)
			{
				for each(var checkbox:CheckBox in _checkboxList)
				{
					checkbox.removeEventListener(MouseEvent.CLICK,checkboxClickHandler);
					checkbox.removeEventListener(Event.CHANGE,checkboxChangeHandler);
					if(checkbox.parent)checkbox.parent.removeChild(checkbox);
				}
			}
			if(parent)parent.removeChild(this);
		}
		
		private function hideHandler(e:MouseEvent):void
		{
			hide();
		}
		
		override public function dispose():void
		{
//			if(_bg)
//			{
//				_bg.dispose();
//				_bg = null;
//			}
			_checkboxList = null;
			super.dispose();
		}
	}
}