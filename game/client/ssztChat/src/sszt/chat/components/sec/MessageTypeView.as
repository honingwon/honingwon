package sszt.chat.components.sec
{
	import fl.controls.CheckBox;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.chat.events.ChatInnerEvent;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.MessageType;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	
	public class MessageTypeView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _checkboxList:Array;
		private var _messageTypes:Array;
		private var _type:int;
		
		public function MessageTypeView()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([new BackgroundInfo(BackgroundType.BORDER_4,new Rectangle(0,0,65,110))]);
			addChild(_bg as DisplayObject);
			
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
				GlobalData.chatInfo.getShowList()[_messageTypes[index]] = checkbox.selected;
			}
			else
			{
				GlobalData.chatInfo.getShowList()[MessageType.SYSTEM] = checkbox.selected;
				GlobalData.chatInfo.getShowList()[MessageType.CHAT] = checkbox.selected;
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
				_bg.height = 110;
				labels = [LanguageManager.getWord("ssztl.common.world") ,
					LanguageManager.getWord("ssztl.common.camp"),
					LanguageManager.getWord("ssztl.common.club"),
					LanguageManager.getWord("ssztl.common.team"),
					LanguageManager.getWord("ssztl.common.near")];
				_messageTypes = [MessageType.WORLD,MessageType.CMP,MessageType.CLUB,MessageType.GROUP,MessageType.CURRENT];
			}
			else
			{
				_bg.height = 35;
				labels = [LanguageManager.getWord("ssztl.common.system")];
				_messageTypes = [MessageType.SYSTEM];
			}
			for(var i:int = 0; i < labels.length; i++)
			{
				var checkbox:CheckBox = new CheckBox();
				checkbox.label = labels[i];
				checkbox.selected = GlobalData.chatInfo.getShowList()[_messageTypes[i]];
				checkbox.setSize(55,20);
				checkbox.move(7,6 + i * 19);
				checkbox.addEventListener(MouseEvent.CLICK,checkboxClickHandler);
				checkbox.addEventListener(Event.CHANGE,checkboxChangeHandler);
				addChild(checkbox);
				_checkboxList.push(checkbox);
			}
			GlobalAPI.layerManager.getPopLayer().addChild(this);
			GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.CLICK,hideHandler);
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
			GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		private function hideHandler(e:MouseEvent):void
		{
			hide();
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_checkboxList = null;
			super.dispose();
		}
	}
}