package sszt.club.components.clubMain.pop.store
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import sszt.club.datas.storeInfo.ClubStoreRecordInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.label.MAssetLabel;
	
	public class ClubStoreRecord extends Sprite
	{
		private var _txtDate:MAssetLabel;
		private var _txtContent:MAssetLabel;
		private var _txtType:MAssetLabel;
		private var _info:ClubStoreRecordInfo;
		
		public static const TYPE_TXT_GET:String = LanguageManager.getWord('ssztl.club.get');
		public static const TYPE_TXT_ADD:String = LanguageManager.getWord('ssztl.club.add');

		public function ClubStoreRecord()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 382, 30);
			graphics.endFill();
			
			_txtDate = new MAssetLabel('...',MAssetLabel.LABEL_TYPE_EN,TextFieldAutoSize.LEFT);
			addChild(_txtDate);
			_txtDate.move(7, 6);
				
			_txtContent = new MAssetLabel('...',MAssetLabel.LABEL_TYPE_EN,TextFieldAutoSize.LEFT);
			addChild(_txtContent);
			_txtContent.move(98, 6);
				
			_txtType = new MAssetLabel('...',MAssetLabel.LABEL_TYPE_EN,TextFieldAutoSize.LEFT);
			addChild(_txtType);
			_txtType.move(330, 6);
			
			this.visible = false;
		}
		
		public function get info():ClubStoreRecordInfo
		{
			return _info;
		}
		
		public function set info(__info:ClubStoreRecordInfo):void
		{
			if(__info)
			{
				_info = __info;
				_txtDate.setValue( getDateString() );
				_txtContent.setHtmlValue(_info.content);
				_txtType.setValue( _info.type == ClubStoreRecordInfo.TYPE_ADD ? TYPE_TXT_ADD : TYPE_TXT_GET);
				this.visible = true;
			}
			else
			{
				this.visible = false;
			}
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
		
		public function dispose():void
		{
			if(_txtDate)
			{
				_txtDate = null;
			}
			if(_txtContent)
			{
				_txtContent = null;
			}
			if(_txtType)
			{
				_txtType = null;
			}
			if(_info)
			{
				_info = null;
			}
		}
	}
}