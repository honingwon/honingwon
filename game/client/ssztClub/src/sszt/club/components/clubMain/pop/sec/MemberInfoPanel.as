package sszt.club.components.clubMain.pop.sec
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.components.clubMain.pop.items.MemberlistItem;
	import sszt.club.components.clubMain.pop.sec.src.AppointmentView;
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubDutyInfoUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.memberInfo.ClubMemberInfo;
	import sszt.core.data.club.memberInfo.ClubMemberInfoUpdateEvent;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	public class MemberInfoPanel extends MSprite implements IClubMainPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _evenRowBg:Shape;
		private var _checkbox:CheckBox;
		private var _tile:MTile;
		private var _list:Array;
		private var _totalField:TextField,_viceMasterField:TextField,_honorField:TextField;
		private var _showOnline:Boolean;
		private var _titles:Array;
		private var _sortNick:Boolean,_sortDuty:Boolean,_sortCareer:Boolean,_sortSex:Boolean,_sortLevel:Boolean;
		private var _sortContribute:Boolean,_sortFight:Boolean,_sortOnline:Boolean;
		private var _selecteItem:MemberlistItem ;
		private var _appointmentView:AppointmentView;
		
		
		private var _appointmentDutyBtn:MCacheAssetBtn1;
		private var _kickMemberBtn:MCacheAssetBtn1;
		
//		private var 
//		private var _bg2:IMovieWrapper;
		
		public function MemberInfoPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
			_mediator.getMemberInfo();
		}
		
		private function initView():void
		{						
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(5,4,625,316)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,319,625,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(67,328,62,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(178,328,62,22)), 
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(278,328,62,22)), 
				
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(9,8,617,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(202,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(256,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(296,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(338,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(460,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(532,9,2,19),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,58,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,86,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,114,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,142,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,170,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,198,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,226,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,254,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,282,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,310,617,2))
				
			]);
			addChild(_bg as DisplayObject);
			_evenRowBg = new Shape();	
			_evenRowBg.graphics.beginFill(0x172527,1);
			_evenRowBg.graphics.drawRect(9,60,617,25);
			_evenRowBg.graphics.drawRect(9,116,617,25);
			_evenRowBg.graphics.drawRect(9,172,617,25);
			_evenRowBg.graphics.drawRect(9,228,617,25);
			_evenRowBg.graphics.drawRect(9,284,617,25);
			addChild(_evenRowBg);
			
//			_bg2 = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.BORDER_8,new Rectangle(0,17,80,19)),
//				]);
//			_bg2.visible = false;
//			addChild(_bg2 as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(10,11,140,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.name"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(152,11,50,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.job"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(204,11,50,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer2"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(260,11,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.sex"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(300,11,40,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(340,11,120,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.personalContribute"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(462,11,70,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.strike"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(534,11,91,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.underLineTime"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.CENTER)));
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(20,331,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubMemberNum") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(140,331,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.subClubLeader") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(243,331,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.zhanglao") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			
			_showOnline = false;
			_checkbox = new CheckBox();
			_checkbox.label = LanguageManager.getWord("ssztl.club.jonlyShowOnlinePlayer");
			_checkbox.setSize(120,20);
			_checkbox.move(361,331);
			addChild(_checkbox);
			_checkbox.selected = _showOnline;
			
			_totalField = new TextField();
			_totalField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_totalField.mouseEnabled = _totalField.mouseWheelEnabled = false;
			_totalField.width = 62;
			_totalField.height = 18;
			_totalField.x = 67;
			_totalField.y = 331;
			addChild(_totalField);
			_viceMasterField = new TextField();
			_viceMasterField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_viceMasterField.mouseEnabled = _viceMasterField.mouseWheelEnabled = false;
			_viceMasterField.width = 62;
			_viceMasterField.height = 18;
			_viceMasterField.x = 178;
			_viceMasterField.y = 331;
			addChild(_viceMasterField);
			_honorField = new TextField();
			_honorField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_honorField.mouseEnabled = _honorField.mouseWheelEnabled = false;
			_honorField.width = 62;
			_honorField.height = 18;
			_honorField.x = 278;
			_honorField.y = 331;
			addChild(_honorField);
			
			_titles = [];
			var poses:Array = [new Point(65,14),new Point(161,14),new Point(214,14),new Point(263,14),new Point(303,14),
								new Point(370,14),new Point(480,14),new Point(550,14)];
			for(var i:int = 0; i < poses.length; i++)
			{
				var sp:Sprite = new Sprite();
				var w:int = i < 5 ? 32 : 60;
				sp.graphics.beginFill(0,0);
				sp.graphics.drawRect(0,0,w,20);
				sp.graphics.endFill();
				sp.x = poses[i].x;
				sp.y = poses[i].y;
				sp.buttonMode = true;
				sp.tabEnabled = false;
				addChild(sp);
				_titles.push(sp);
			}
			
			_list = [];
			_tile = new MTile(617,28);
			_tile.setSize(617,280);
			_tile.horizontalScrollPolicy = "off";
			_tile.move(9,31);
			_tile.itemGapH = 0;
			_tile.verticalScrollBar.lineScrollSize = 28;
			addChild(_tile);
			
			_appointmentDutyBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.appointmentDuty"));
			_appointmentDutyBtn.move(485,328);
			_appointmentDutyBtn.enabled = false;
			addChild(_appointmentDutyBtn);
			
			_kickMemberBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.kickOutClub"));
			_kickMemberBtn.move(559,328);
			_kickMemberBtn.enabled = false;
			addChild(_kickMemberBtn);
			
			if(GlobalData.selfPlayer.clubDuty == ClubDutyType.PREPARE || GlobalData.selfPlayer.clubDuty == ClubDutyType.NULL)
			{
				_appointmentDutyBtn.visible = false;
				_kickMemberBtn.visible = false;
			}else
			{
				_appointmentDutyBtn.visible = true;
				_kickMemberBtn.visible = true;
			}
			
			createList();
//			_tile.sortOn(["duty"],[Array.NUMERIC]);
				
		}
		
		public function assetsCompleteHandler():void
		{
			//_bg1.bitmapData = AssetUtil.getAsset("ssztui.club.ClubListBgAsset",BitmapData) as BitmapData;
		}
		private function initEvent():void
		{
			_checkbox.addEventListener(Event.CHANGE,checkboxChangeHandler);
			for each(var sp:Sprite in _titles)
			{
				sp.addEventListener(MouseEvent.CLICK,titleClickHandler);
			}
			GlobalData.clubMemberInfo.addEventListener(ClubMemberInfoUpdateEvent.MEMBERINFO_UPDATE,updateHandler);
			GlobalData.clubMemberInfo.addEventListener(ClubMemberInfoUpdateEvent.MEMBER_DUTY_UPDATE,updateDutyInfo);
//			GlobalData.clubMemberInfo.addEventListener(ClubMemberInfoUpdateEvent.REMOVE_MEMBER, removeMemberHandler);
			_appointmentDutyBtn.addEventListener(MouseEvent.CLICK,appointmentClickHandler);
			_kickMemberBtn.addEventListener(MouseEvent.CLICK,kickClickHandler);
		}
		
		private function removeEvent():void
		{
			_checkbox.removeEventListener(Event.CHANGE,checkboxChangeHandler);
			for each(var sp:Sprite in _titles)
			{
				sp.removeEventListener(MouseEvent.CLICK,titleClickHandler);
			}
			GlobalData.clubMemberInfo.removeEventListener(ClubMemberInfoUpdateEvent.MEMBERINFO_UPDATE,updateHandler);
			GlobalData.clubMemberInfo.removeEventListener(ClubMemberInfoUpdateEvent.MEMBER_DUTY_UPDATE,updateDutyInfo);
//			GlobalData.clubMemberInfo.removeEventListener(ClubMemberInfoUpdateEvent.REMOVE_MEMBER, removeMemberHandler);
			_appointmentDutyBtn.removeEventListener(MouseEvent.CLICK,appointmentClickHandler);
			_kickMemberBtn.removeEventListener(MouseEvent.CLICK,kickClickHandler);
		}
		
//		private function removeMemberHandler(event:ClubMemberInfoUpdateEvent):void
//		{
//			var memberItemInfo:ClubMemberItemInfo = event.data as ClubMemberItemInfo;
//			var memberListItemView:MemberlistItem;
//			for(var i:int = 0; i<_list.length; i++)
//			{
//				memberListItemView = _list[i] as MemberlistItem;
//				if(memberListItemView.info == memberItemInfo)
//				{
//					_list.splice(i,1);
//					memberListItemView.dispose();
//					_tile.removeItem(memberListItemView);
//					memberListItemView = null;
//					break;
//				}
//			}
//		}
		
		private function updateHandler(evt:ClubMemberInfoUpdateEvent):void
		{
//			var memberInfo:ClubMemberInfo = _mediator.clubInfo.clubMemberInfo;
//			_totalField.text = memberInfo.currentMember + "/" + memberInfo.totalMember;
//			_viceMasterField.text = memberInfo.currentViceMaster + "/" + memberInfo.totalViceMaster;
//			_honorField.text = memberInfo.currentHonor + "/" + memberInfo.totalHonor;
			createList();
		}
		
		private function kickClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_selecteItem == null) return;
			if(_appointmentView && _appointmentView.parent)_appointmentView.hide();
			
			MAlert.show(LanguageManager.getWord('ssztl.club.kickOutAlert',_selecteItem.info.name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.kick(_selecteItem.info.id);
				}
			}
		}
		
		private function appointmentClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			if(_selecteItem == null) return;
			if(_appointmentView == null)
			{
				_appointmentView = new AppointmentView(_mediator);
			}
			_appointmentView.setInfo(_selecteItem.info.id,_selecteItem.info.duty);
//			_appointmentView.move(e.stageX,e.stageY - _appointmentView.height - 20);
			_appointmentView.move(485,190);
			if(_appointmentView && _appointmentView.parent)_appointmentView.hide();
			else addChild(_appointmentView); //_appointmentView.show();
		}
		
		
		
		private function checkboxChangeHandler(e:Event):void
		{
			_showOnline = _checkbox.selected;
			createList();
		}
		
		private function updateDutyInfo(e:ClubMemberInfoUpdateEvent=null):void
		{
			var memberInfo:ClubMemberInfo = GlobalData.clubMemberInfo;
			_totalField.text = memberInfo.currentMember + "/" + memberInfo.totalMember;
			_viceMasterField.text = memberInfo.currentViceMaster + "/" + memberInfo.totalViceMaster;
			_honorField.text = memberInfo.currentHonor + "/" + memberInfo.totalHonor;
		}
		
		private function createList():void
		{
			updateDutyInfo();
			clearList();
			var memberInfo:ClubMemberInfo = GlobalData.clubMemberInfo;
			var list:Array = memberInfo.list;
			for each(var info:ClubMemberItemInfo in list)
			{
				if(_showOnline == false || (_showOnline && info.isOnline))
				{
					var item:MemberlistItem = new MemberlistItem(info,_mediator);
					item.addEventListener(MouseEvent.CLICK,itemClickHandler);
					_tile.appendItem(item);
					_list.push(item);
				}
			}
		}
		
		private function clearList():void
		{
			_tile.clearItems();
			for each(var item:MemberlistItem in _list)
			{
				item.dispose();
				item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			_list.length = 0;
		}
		
		private function titleClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _titles.indexOf(e.currentTarget as Sprite);
			switch(index)
			{
				case 0:
					if(_sortNick)
						_tile.sortOn(["nick"],[Array.CASEINSENSITIVE]);
					else
						_tile.sortOn(["nick"],[Array.CASEINSENSITIVE | Array.DESCENDING]);
					_sortNick = !_sortNick;
					
					break;
				case 1:
					if(_sortDuty)
						_tile.sortOn(["duty"],[Array.NUMERIC | Array.DESCENDING]);
					else
						_tile.sortOn(["duty"],[Array.NUMERIC]);
					_sortDuty = !_sortDuty;
					break;
				case 2:
					if(_sortCareer)
						_tile.sortOn(["career"],[Array.NUMERIC]);
					else
						_tile.sortOn(["career"],[Array.NUMERIC | Array.DESCENDING]);
					_sortCareer = !_sortCareer;
					break;
				case 3:
					if(_sortSex)
						_tile.sortOn(["sex"],[Array.NUMERIC]);
					else
						_tile.sortOn(["sex"],[Array.NUMERIC | Array.DESCENDING]);
					_sortSex = !_sortSex;
					break;
				case 4:
					if(_sortLevel)
						_tile.sortOn(["level"],[Array.NUMERIC | Array.DESCENDING]);
					else
						_tile.sortOn(["level"],[Array.NUMERIC]);
					_sortLevel = !_sortLevel;
					break;
				case 5:
					if(_sortContribute)
						_tile.sortOn(["contribute"],[Array.NUMERIC | Array.DESCENDING]);
					else
						_tile.sortOn(["contribute"],[Array.NUMERIC]);
					_sortContribute = !_sortContribute;
					break;
				case 6:
					if(_sortFight)
						_tile.sortOn(["fight"],[Array.NUMERIC | Array.DESCENDING]);
					else
						_tile.sortOn(["fight"],[Array.NUMERIC]);
					_sortFight = !_sortFight;
					break;
				case 7:
					if(_sortOnline)
						_tile.sortOn(["isOnline","outTime"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
					else
						_tile.sortOn(["isOnline","outTime"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
					_sortOnline = !_sortOnline;
					break;
			}
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			if(_selecteItem)
			{
				_selecteItem.hideBg();
			}
			
			var item:MemberlistItem = e.currentTarget as MemberlistItem;
			if(item)
			{
				item.showBg();
			}
			_selecteItem = item;
			
			if(ClubDutyType.getIsOverHonor(GlobalData.selfPlayer.clubDuty) && (GlobalData.selfPlayer.clubDuty < _selecteItem.duty))
			{
				_appointmentDutyBtn.enabled = true;
				_kickMemberBtn.enabled = true;
			}
			else
			{
				_appointmentDutyBtn.enabled = false;
				_kickMemberBtn.enabled = false;
			}
			if(_appointmentView && _appointmentView.parent)_appointmentView.hide();
		}
//		private function titleMouseOverHandler(e:MouseEvent):void
//		{
//			
//			var index:int = _titles.indexOf(e.currentTarget as Sprite);
//			var vx:int = 0;
//			var bWidth:int = 80;
//			switch(index)
//			{
//				case 0:
//					vx = 3;
//					bWidth = 137;
//					break;
//				case 1:
//					vx = 152;
//					bWidth = 46;
//					break;
//				case 2:
//					vx = 204;
//					bWidth = 46;
//					break;
//				case 3:
//					vx = 256;
//					bWidth = 46;
//					break;
//				case 4:
//					vx = 299;
//					bWidth = 46;
//					break;
//				case 5:
//					vx = 341;
//					bWidth = 110;
//					break;
//				case 6:
//					vx = 463;
//					bWidth = 72;
//					break;
//				case 7:
//					vx = 535;
//					bWidth = 90;
//					break;
//				
//			}
//			_bg2.x = vx;
//			_bg2.width = bWidth;
//			_bg2.visible = true;
//		}
//		
//		private function titleMouseOutHandler(e:MouseEvent):void
//		{
//			_bg2.visible = false;
//		}
		
		
		public function show():void
		{
			_mediator.getMemberInfo();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvent();
//			_mediator.clubInfo.clearMemberInfo();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_evenRowBg)
			{
				_evenRowBg = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_appointmentDutyBtn)
			{
				_appointmentDutyBtn.dispose();
				_appointmentDutyBtn = null;
			}
			if(_kickMemberBtn)
			{
				_kickMemberBtn.dispose();
				_kickMemberBtn = null;
			}
			if(_appointmentView)
			{
				_appointmentView.dispose();
				_appointmentView = null;
			}
			if(_list)
			{
				for each(var item:MemberlistItem in _list)
				{
					item.dispose();
				}
			}
			if(_selecteItem)
			{
				_selecteItem = null;
			}
			_totalField = null;
			_viceMasterField = null;
			_honorField = null;
			_list = null;
			_titles = null;
			_checkbox = null;
			_mediator = null;
			super.dispose();
		}
	}
}