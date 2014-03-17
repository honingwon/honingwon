package sszt.club.components.clubMain.pop.items
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MSprite;
	
	import sszt.club.datas.contributeLogInfo.ClubContributeLogItemInfo;
	import sszt.core.manager.LanguageManager;
	
	public class ClubContributeLogItem extends MSprite
	{
		private var _info:ClubContributeLogItemInfo;
		private var _mesField:TextField,_dateField:TextField;
		
		public function ClubContributeLogItem(info:ClubContributeLogItemInfo)
		{
			_info = info;
			super();
			initView();
		}
		
		private function initView():void
		{
			_mesField = new TextField();
			_mesField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_mesField.mouseEnabled = _mesField.mouseWheelEnabled = false;
			_mesField.width = 380;
			_mesField.height = 18;
			_mesField.x = 21;
			addChild(_mesField);
			_mesField.text = _info.mes;
			
			_dateField = new TextField();
			_dateField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_dateField.mouseEnabled = _dateField.mouseWheelEnabled = false;
			_dateField.width = 80;
			_dateField.height = 18;
			_dateField.x = 448;
			addChild(_dateField);
			_dateField.text = getDateString();
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