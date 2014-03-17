package sszt.club.components.clubMain.pop.items
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.container.MSprite;
	
	import sszt.club.datas.eventInfo.ClubEventItemInfo;
	import sszt.core.manager.LanguageManager;
	
	public class ClubEventItem extends MSprite
	{
		private var _info:ClubEventItemInfo;
		private var _eventField:TextField,_dateField:TextField;
		
		public function ClubEventItem(info:ClubEventItemInfo)
		{
			_info = info;
			super();
			initView();
		}
		
		private function initView():void
		{
			_eventField = new TextField();
			_eventField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_eventField.mouseEnabled = _eventField.mouseWheelEnabled = false;
			_eventField.width = 380;
			_eventField.height = 18;
			_eventField.x = 21;
			_eventField.text = _info.mes;
			addChild(_eventField);
			
			_dateField = new TextField();
			_dateField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_dateField.mouseEnabled = _dateField.mouseWheelEnabled = false;
			_dateField.width = 80;
			_dateField.height = 18;
			_dateField.x = 448;
			_dateField.text = getDateString();
			addChild(_dateField);
		}
		
		private function getDateString():String
		{
			var date:Date = _info.date;
			var month:String = (date.month + 1 > 9) ? String(date.month + 1) : "0" + String(date.month + 1);
			var day:String = (date.date > 9) ? String(date.date) : "0" + String(date.date);
			var hour:String = (date.hours > 9) ? String(date.hours) : "0" + String(date.hours);
			var minute:String = (date.minutes > 9) ? String(date.minutes) : "0" + String(date.minutes);
			return month + "-" + day + " " + hour + ":" + minute;
		}
		
		override public function dispose():void
		{
			_info = null;
			super.dispose();
		}
	}
}