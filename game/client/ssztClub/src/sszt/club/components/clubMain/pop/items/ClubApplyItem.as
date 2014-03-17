package sszt.club.components.clubMain.pop.items
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.datas.tryin.TryinItemInfo;
	import sszt.constData.CareerType;
	import sszt.constData.VipType;
	import sszt.core.caches.VipIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.ui.container.MSprite;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class ClubApplyItem extends MSprite
	{
		private var _info:TryinItemInfo;
		private var _acceptHandler:Function,_refuseHandler:Function;
		private var _nameField:TextField,_levelField:TextField,_careerField:TextField;
		private var _sexField:TextField,_dateField:TextField;
		private var _acceptBtn:MCacheAssetBtn1,_refuseBtn:MCacheAssetBtn1;
//		private var _asset:Bitmap;
		private var _clickBg:Sprite;
		
		public function ClubApplyItem(info:TryinItemInfo,acceptHandler:Function,refuseHandler:Function)
		{
			_info = info;
			_acceptHandler = acceptHandler;
			_refuseHandler = refuseHandler;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			var type:int = VipType.getVipType(_info.vipType);
			
			_nameField = new TextField();
			_nameField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffcc66,null,null,null,null,null,TextFormatAlign.LEFT);
			_nameField.mouseEnabled = _nameField.mouseWheelEnabled = false;
			//_nameField.width = 100;
			_nameField.height = 18;
			_nameField.x = 5;
			_nameField.y = 5;
			_nameField.htmlText = "<u>" + _info.name + "</u>";
			addChild(_nameField);
			
//			if(type != 0)
//			{
//				if(type == 1)_asset = new Bitmap(VipIconCaches.vipCache[1]);
//				else if(type == 2)_asset = new Bitmap(VipIconCaches.vipCache[2]);
//				else if(type == 3)_asset = new Bitmap(VipIconCaches.vipCache[3]);
//				_asset.x = _nameField.width + 2;
//				_asset.y = 7;
//				addChild(_asset);
//			}
			
			_levelField = new TextField();
			_levelField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_levelField.mouseEnabled = _levelField.mouseWheelEnabled = false;
			_levelField.width = 40;
			_levelField.height = 18;
			_levelField.x = 128;
			_levelField.y = 5;
			_levelField.text = String(_info.level);
			addChild(_levelField);
			
			_careerField = new TextField();
			_careerField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_careerField.mouseEnabled = _careerField.mouseWheelEnabled = false;
			_careerField.width = 60;
			_careerField.height = 18;
			_careerField.x = 170;
			_careerField.y = 5;
			_careerField.text = CareerType.getNameByCareer(_info.career);
			addChild(_careerField);
			
			_sexField = new TextField();
			_sexField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_sexField.mouseEnabled = _sexField.mouseWheelEnabled = false;
			_sexField.width = 40;
			_sexField.height = 18;
			_sexField.x = 232;
			_sexField.y = 5;
			_sexField.text = _info.sex ? LanguageManager.getWord("ssztl.common.male") : LanguageManager.getWord("ssztl.common.female");
			addChild(_sexField);
			
			_dateField = new TextField();
			_dateField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_dateField.mouseEnabled = _dateField.mouseWheelEnabled = false;
			_dateField.width = 80;
			_dateField.height = 18;
			_dateField.x = 274;
			_dateField.y = 5;
			_dateField.text = getDateString();
			addChild(_dateField);
			
			_acceptBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.accept"));
			
			_acceptBtn.move(360,1);
			addChild(_acceptBtn);
			_refuseBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.delete"));
			_refuseBtn.move(400,1);
			addChild(_refuseBtn);
			
			if(ClubDutyType.getIsOverHonor(GlobalData.selfPlayer.clubDuty))
			{
				_acceptBtn.enabled = _refuseBtn.enabled = true;
			}
			else
			{
				_acceptBtn.enabled = _refuseBtn.enabled = false;
			}
			
			_clickBg = new Sprite();
			_clickBg.graphics.beginFill(0,0);
			_clickBg.graphics.drawRect(0,0,134,28);
			_clickBg.graphics.endFill();
			_clickBg.buttonMode = true;
			addChild(_clickBg);
		}
		
		private function initEvent():void
		{
			_acceptBtn.addEventListener(MouseEvent.CLICK,acceptBtnClickHandler);
			_refuseBtn.addEventListener(MouseEvent.CLICK,refuseBtnClickHandler);
			_clickBg.addEventListener(MouseEvent.CLICK,checkClickHandler);
		}
		
		private function removeEvent():void
		{
			_acceptBtn.removeEventListener(MouseEvent.CLICK,acceptBtnClickHandler);
			_refuseBtn.removeEventListener(MouseEvent.CLICK,refuseBtnClickHandler);
			_clickBg.removeEventListener(MouseEvent.CLICK,checkClickHandler);
		}
		
		private function acceptBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_acceptHandler != null)_acceptHandler(_info);
		}
		
		private function refuseBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_refuseHandler != null)_refuseHandler(_info);
		}
		
		private function checkClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ChatPlayerTip.getInstance().show(_info.serverId,_info.id,_info.name,new Point(evt.stageX,evt.stageY));
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
			removeEvent();
			if(_acceptBtn)
			{
				_acceptBtn.dispose();
				_acceptBtn = null;
			}
			if(_refuseBtn)
			{
				_refuseBtn.dispose();
				_refuseBtn = null;
			}
			_clickBg = null;
//			_asset = null;
			_acceptHandler = null;
			_refuseHandler = null;
			_info = null;
			super.dispose();
		}
	}
}