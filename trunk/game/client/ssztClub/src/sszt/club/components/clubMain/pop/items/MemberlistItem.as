package sszt.club.components.clubMain.pop.items
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubDutyChangeSocketHandler;
	import sszt.constData.CareerType;
	import sszt.constData.VipType;
	import sszt.core.caches.VipIconCaches;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.memberInfo.ClubMemberInfoUpdateEvent;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.ClubPlayerTip;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	
	public class MemberlistItem extends MSprite
	{
		private var _info:ClubMemberItemInfo;
		private var _mediator:ClubMediator;
		private var _nameField:TextField,_careerField:TextField,_sexField:TextField,_levelField:TextField;
		private var _dutyField:TextField,_contributeField:TextField,_fightField:TextField,_timeField:TextField;
//		private var _combobox:ComboBox;
//		private var _asset:Bitmap;
		private var _clickBg:Sprite;
		private var _wordType:String = "Tahoma";
		
		//公开属性(排序用)
		public var nick:String;
		public var duty:int;
		public var career:int;
		public var sex:Boolean;
		public var level:int;
		public var contribute:int;
		public var fight:int;
		public var isOnline:Boolean;
		public var outTime:int;
		
		private var _bg:IMovieWrapper;
		
		
		public function MemberlistItem(info:ClubMemberItemInfo,mediator:ClubMediator)
		{
			_info = info;
			_mediator = mediator;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_3,new Rectangle(0,0,618,27))
			]);		
			
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			
//			var type:int = VipType.getVipType(_info.vipType);
//			if(type != 0)
//			{
//				if(type == 1)_asset = new Bitmap(VipIconCaches.vipCache[1]);
//				else if(type == 2)_asset = new Bitmap(VipIconCaches.vipCache[2]);
//				else if(type == 3)_asset = new Bitmap(VipIconCaches.vipCache[3]);
//				_asset.x = 5;
//				_asset.y = 7;
//				addChild(_asset);
//			}
			
			_nameField = new TextField();
			_nameField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT);
			_nameField.mouseEnabled = _nameField.mouseWheelEnabled = false;
			_nameField.width = 120;
			_nameField.height = 18;
			_nameField.x = 26;
			_nameField.y = 4;
			addChild(_nameField);
			
			var _bg:Sprite = new Sprite();
			_bg.graphics.beginFill(0,0);
			_bg.graphics.drawRect(0,0,617,28);
			_bg.graphics.endFill();
			addChild(_bg);
			_bg.buttonMode = true;
			
			_clickBg = new Sprite();
			_clickBg.graphics.beginFill(0,0);
			_clickBg.graphics.drawRect(0,0,132,28);
			_clickBg.graphics.endFill();
			addChild(_clickBg);
			_clickBg.buttonMode = true;
			
			
			_dutyField = new TextField();
			_dutyField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_dutyField.mouseEnabled = _dutyField.mouseWheelEnabled = false;
			_dutyField.width = 50;
			_dutyField.height = 18;
			_dutyField.x = 143;
			_dutyField.y = 4;
			addChild(_dutyField);
			
			
			_careerField = new TextField();
			_careerField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_careerField.mouseEnabled = _careerField.mouseWheelEnabled = false;
			_careerField.width = 50;
			_careerField.height = 18;
			_careerField.x = 195;
			_careerField.y = 4;
			addChild(_careerField);
			
			_sexField = new TextField();
			_sexField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_sexField.mouseEnabled = _sexField.mouseWheelEnabled = false;
			_sexField.width = 40;
			_sexField.height = 18;
			_sexField.x = 247;
			_sexField.y = 4;
			addChild(_sexField);
			
			_levelField = new TextField();
			_levelField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_levelField.mouseEnabled = _levelField.mouseWheelEnabled = false;
			_levelField.width = 40;
			_levelField.height = 18;
			_levelField.x = 294;
			_levelField.y = 4;
			addChild(_levelField);
			
			_contributeField = new TextField();
			_contributeField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_contributeField.mouseEnabled = _contributeField.mouseWheelEnabled = false;
			_contributeField.width = 120;
			_contributeField.height = 18;
			_contributeField.x = 331;
			_contributeField.y = 4;
			addChild(_contributeField);
			
			_fightField = new TextField();
			_fightField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_fightField.mouseEnabled = _fightField.mouseWheelEnabled = false;
			_fightField.width = 70;
			_fightField.height = 18;
			_fightField.x = 453;
			_fightField.y = 4;
			addChild(_fightField);
			
			_timeField = new TextField();
			_timeField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_timeField.mouseEnabled = _timeField.mouseWheelEnabled = false;
			_timeField.width = 91;
			_timeField.height = 18;
			_timeField.x = 525;
			_timeField.y = 4;
			addChild(_timeField);
			
//			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty) && (GlobalData.selfPlayer.clubDuty < _info.duty))
//			{
//				_combobox = new ComboBox();
//				_combobox.setSize(70,20);
//				_combobox.move(140,0);
//				_combobox.editable = false;
//				_combobox.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.common.subClubLeader") ,value:2},
//					{label:LanguageManager.getWord("ssztl.common.zhanglao"),value:3},
//					{label:LanguageManager.getWord("ssztl.common.jingying"),value:4},
//					{label:LanguageManager.getWord("ssztl.common.crowd"),value:5}]);
//				addChild(_combobox);
//				_combobox.addEventListener(Event.CHANGE,comboBoxChangeHandler);
//			}
//			else
//			{
//				_dutyField = new TextField();
//				_dutyField.defaultTextFormat = new TextFormat(_wordType,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
//				_dutyField.mouseEnabled = _dutyField.mouseWheelEnabled = false;
//				_dutyField.width = 70;
//				_dutyField.height = 18;
//				_dutyField.x = 137;
//				_dutyField.y = 1;
//				addChild(_dutyField);
//			}
			
			itemInfoUpdateHandler(null);
		}
		
		private function initEvent():void
		{
			_info.addEventListener(ClubMemberInfoUpdateEvent.MEMBER_ITEMINFO_UPDATE,itemInfoUpdateHandler);
			_clickBg.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvent():void
		{
			_info.removeEventListener(ClubMemberInfoUpdateEvent.MEMBER_ITEMINFO_UPDATE,itemInfoUpdateHandler);
			_clickBg.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			if(GlobalData.selfPlayer.userId == _info.id) return;
			ClubPlayerTip.getInstance().show(_info.serverId,_info.id,_info.name,new Point(evt.stageX,evt.stageY),_info.level);
		}
		
		private function itemInfoUpdateHandler(e:ClubMemberInfoUpdateEvent):void
		{
			if(GlobalData.selfPlayer.userId == _info.id) _nameField.text =  _info.name;
			else _nameField.htmlText = "<u>" + _info.name + "</u>";
			_careerField.text = CareerType.getNameByCareer(_info.career);
			_sexField.text = _info.sex ? LanguageManager.getWord("ssztl.common.male") : LanguageManager.getWord("ssztl.common.female") ;
			_levelField.text = String(_info.level);
			_contributeField.text = _info.currentExploit + "/" + _info.totalExploit;
			_fightField.text = String(_info.fightCapacity);
			_timeField.text = getOnlineString();
			_dutyField.text = ClubDutyType.getDutyName(_info.duty);
//			if(ClubDutyType.getIsOverViceMaster(GlobalData.selfPlayer.clubDuty) && (GlobalData.selfPlayer.clubDuty < _info.duty))
//			{
//				if(_combobox)_combobox.selectedItem = _combobox.dataProvider.getItemAt(_info.duty - 2);
//				if(_dutyField)_dutyField.visible = false;
//			}
//			else
//			{
//				if(_combobox)_combobox.visible = false;
//				if(_dutyField)_dutyField.text = ClubDutyType.getDutyName(_info.duty);
//			}
			
			if(!_info.isOnline)setTextColor(0x777164);
			else
			{
				if(_info.duty == ClubDutyType.MASTER)setTextColor(0xfd5fff);
				else if(_info.duty == ClubDutyType.VICEMASTER)setTextColor(0x00deff);
				else setTextColor(0xFFFFFF);
			}
			
			nick = "[" + _info.serverId + "]" + _info.name;
			duty = _info.duty;
			career = _info.career;
			sex = _info.sex;
			level = _info.level;
			contribute = _info.totalExploit;
			fight = _info.fightCapacity;
			isOnline = _info.isOnline;
			outTime = DateUtil.getCountDownByHour(_info.outTime.getTime(),GlobalData.systemDate.getSystemDate().getTime()).hours + 1;
		}
		
		private function getOnlineString():String
		{
			if(_info.isOnline)return LanguageManager.getWord("ssztl.common.online");
			else
			{
				var countdown:CountDownInfo = DateUtil.getCountDownByHour(_info.outTime.getTime(),GlobalData.systemDate.getSystemDate().getTime());
				var hours:int = countdown.hours;
				
				if(hours == 0 )
					return LanguageManager.getWord("ssztl.common.leave");
				else if(hours<=24)
					return LanguageManager.getWord("ssztl.common.hour",hours);
				else if(hours<=720) 
				{
					return LanguageManager.getWord("ssztl.common.dayValue",int(hours/24));
				}
				else
					return LanguageManager.getWord("ssztl.common.bigMonth");
			}
			return "";
		}
		
//		private function comboBoxChangeHandler(e:Event):void
//		{
//			var duty:int = _combobox.selectedItem.value;
//			_combobox.selectedItem = _combobox.dataProvider.getItemAt(_info.duty - 2);
//			
//			if(duty == ClubDutyType.VICEMASTER && _mediator.clubInfo.clubMemberInfo.currentMaster >= 1)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.club.subClubLeaderFull"));
//				_combobox.selectedItem = _combobox.dataProvider.getItemAt(_info.duty - 2);
//			}
//			else if(duty == ClubDutyType.HONOR && _mediator.clubInfo.clubMemberInfo.currentHonor >= _mediator.clubInfo.clubMemberInfo.totalHonor && _info.duty != ClubDutyType.VICEMASTER)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.club.zhanglaoFull"));
//				_combobox.selectedItem = _combobox.dataProvider.getItemAt(_info.duty - 2);
//			}
//			else if(duty == ClubDutyType.NORMAL && _mediator.clubInfo.clubMemberInfo.currentNormal >= _mediator.clubInfo.clubMemberInfo.totalNormal)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.club.jingyingFull"));
//				_combobox.selectedItem = _combobox.dataProvider.getItemAt(_info.duty - 2);
//			}
//			else if(duty == ClubDutyType.PREPARE && _mediator.clubInfo.clubMemberInfo.currentPrepare >= _mediator.clubInfo.clubMemberInfo.totalPrepare)
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.club.crowdFull"));
//				_combobox.selectedItem = _combobox.dataProvider.getItemAt(_info.duty - 2);
//			}
//			else
//			{
//				ClubDutyChangeSocketHandler.send(_info.id,duty);
//			}
//		}
		
		private function setTextColor(color:uint):void
		{
			_nameField.textColor = color;
			_careerField.textColor = color;
			_sexField.textColor = color;
			_levelField.textColor = color;
			if(_dutyField)_dutyField.textColor = color;
			_contributeField.textColor = color;
			_fightField.textColor = color;
			_timeField.textColor = color;
		}
		
		public function showBg():void
		{
			addChildAt(_bg as DisplayObject,0);
		}
		
		public function hideBg():void
		{
			var ds:DisplayObject = _bg as DisplayObject;
			if(ds && this.contains(ds))
			{
				removeChild(_bg as DisplayObject);
			}
		}
		
		public function get info():ClubMemberItemInfo
		{
			return _info;
		}
		
		override public function dispose():void
		{
			removeEvent();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
//			if(_combobox)
//			{
//				_combobox.removeEventListener(Event.CHANGE,comboBoxChangeHandler);
//				_combobox = null;
//			}
			_info = null;
			_clickBg = null;
			_mediator = null;
			super.dispose();
		}
	}
}