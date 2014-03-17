package sszt.personal.components
{
	import fl.controls.ComboBox;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.personal.PersonalInfo;
	import sszt.core.data.personal.PersonalInfoUpdateEvents;
	import sszt.core.data.personal.PersonalMyInfo;
	import sszt.core.data.personal.item.PersonalDynamicItemInfo;
	import sszt.core.data.personal.template.PersonalCityTemplateInfo;
	import sszt.core.data.personal.template.PersonalCityTemplateList;
	import sszt.core.data.personal.template.PersonalProvinceTemplateInfo;
	import sszt.core.data.personal.template.PersonalProvinceTemplateList;
	import sszt.core.data.personal.template.PersonalStarTemplateInfo;
	import sszt.core.data.personal.template.PersonalStarTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import mhsm.personal.PersonalTitleAsset;
	import sszt.personal.commands.PersonalStartCommand;
	import sszt.personal.components.itemView.PersonalDynamicItemView;
	import sszt.personal.data.PersonalPartInfo;
	import sszt.personal.mediators.PersonalMediator;
	
	public class PersonalMainPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:PersonalMediator;
		
		private var _dayRewardsBtn:MCacheAsset1Btn;
		private var _changeSettingBtn:MCacheAsset1Btn;
		private var _getRewardsBtn:MCacheAsset1Btn;
		
		private var _nameLabel:MAssetLabel;
//		private var _starField:TextField;
		private var _starComboBox:ComboBox;
//		private var _provinceField:TextField;
		private var _provinceComboBox:ComboBox;
		
//		private var _cityComboBox:TextField;
		private var _cityComboBox:ComboBox;
		private var _moodField:TextField;
		private var _introduceField:TextField;
		private var _experienceLabel:MAssetLabel;
		private var _lifeExpLabel:MAssetLabel;
		private var _bindCopperLabel:MAssetLabel;
		
		private var _btns:Array;
		private var _handlers:Array;
		private var _headCell:PersonalHeadCell;
		private var _mTileFriend:MTile;
		private var _itemViewFriendList:Array;
		private var _mTileClub:MTile;
		private var _itemViewClubList:Array;
		private var _playerId:Number;
		private var	_changeHeadSprite:Sprite;
		private var _isMySelf:Boolean;
		
		public function PersonalMainPanel(argMediator:PersonalMediator,argPlayerId:Number)
		{
			_mediator = argMediator;
			_playerId = argPlayerId;
			//判断是否自己
			isMySelfHandler();
			super(new MCacheTitle1("",new Bitmap(new PersonalTitleAsset())),true,-1);
			personalPartInfo.initOtherMainInfo();
			initEvents();
			_mediator.sendMainInfo(argPlayerId);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			var t:BitmapData = AssetUtil.getAsset("mhsm.common.iconCellAsset",BitmapData) as BitmapData;
			setContentSize(526,488);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,526,488)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,8,367,123)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(378,8,142,123)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,135,513,51)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,242,93,238)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(104,242,416,238)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(128,22,98,19)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,96,354,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(72,105,294,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(435,22,78,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(435,50,78,19)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(435,78,78,19)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(72,142,440,37)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(74,231,446,2)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,242,93,238)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(104,242,416,238)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(74,231,446,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,14,59,58),new Bitmap(t)),
												
			]);
			addContent(_bg as DisplayObject);
			
//			var label1:MAssetLabel = new MAssetLabel("名称：",MAssetLabel.LABELTYPE14);
//			label1.move(90,24);
//			addContent(label1);
//			var label2:MAssetLabel = new MAssetLabel("星座：",MAssetLabel.LABELTYPE14);
//			label2.move(90,52);
//			addContent(label2);
//			var label3:MAssetLabel = new MAssetLabel("省份：",MAssetLabel.LABELTYPE14);
//			label3.move(240,24);
//			addContent(label3);
//			var label4:MAssetLabel = new MAssetLabel("城市：",MAssetLabel.LABELTYPE14);
//			label4.move(240,52);
//			addContent(label4);
//			var label5:MAssetLabel = new MAssetLabel("今天心情：",MAssetLabel.LABELTYPE14);
//			label5.move(11,106);
//			addContent(label5);
//			var label6:MAssetLabel = new MAssetLabel("经    验",MAssetLabel.LABELTYPE14);
//			label6.move(380,24);
//			addContent(label6);
//			var label7:MAssetLabel = new MAssetLabel("历    练",MAssetLabel.LABELTYPE14);
//			label7.move(380,52);
//			addContent(label7);
//			var label12:MAssetLabel = new MAssetLabel("绑定铜币",MAssetLabel.LABELTYPE14);
//			label12.move(380,78);
//			addContent(label12);
//			
//			var label8:MAssetLabel = new MAssetLabel("个人简介：",MAssetLabel.LABELTYPE14);
//			label8.move(11,142);
//			addContent(label8);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.name2") + "：",MAssetLabel.LABELTYPE14);
			label1.move(90,24);
			addContent(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.star"),MAssetLabel.LABELTYPE14);
			label2.move(90,52);
			addContent(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.province"),MAssetLabel.LABELTYPE14);
			label3.move(240,24);
			addContent(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.city"),MAssetLabel.LABELTYPE14);
			label4.move(240,52);
			addContent(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.personal.todayMood"),MAssetLabel.LABELTYPE14);
			label5.move(11,106);
			addContent(label5);
			var label6:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.experience4"),MAssetLabel.LABELTYPE14);
			label6.move(380,24);
			addContent(label6);
			var label7:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.liftExp2"),MAssetLabel.LABELTYPE14);
			label7.move(380,52);
			addContent(label7);
			var label12:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.bindCopper2") + "：",MAssetLabel.LABELTYPE14);
			label12.move(380,78);
			addContent(label12);
			
			var label8:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.personal.personalIntroduce"),MAssetLabel.LABELTYPE14);
			label8.move(11,142);
			addContent(label8);
			
//			var label9:MAssetLabel = new MAssetLabel("提示：每日首次修改个人中心信息即可获得丰富奖励。",MAssetLabel.LABELTYPE1);
//			label9.move(203,195);
//			addContent(label9);
			
			
//			var label10:MAssetLabel = new MAssetLabel("个人动态",MAssetLabel.LABELTYPE14);
//			label10.move(12,223);
//			addContent(label10);
//			
//			var label11:MAssetLabel = new MAssetLabel("点击更换头像",MAssetLabel.LABELTYPE16);
//			label11.move(15,74);
//			addContent(label11);
			var label10:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.personal.personalActive"),MAssetLabel.LABELTYPE14);
			label10.move(12,223);
			addContent(label10);
			
			var label11:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.personal.changeHead"),MAssetLabel.LABELTYPE16);
			label11.move(15,74);
			addContent(label11);
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_nameLabel.move(130,23);
			addContent(_nameLabel);
			
			_experienceLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_experienceLabel.move(440,22);
			addContent(_experienceLabel);
			
			_lifeExpLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_lifeExpLabel.move(440,50);
			addContent(_lifeExpLabel);
			
			_bindCopperLabel = new MAssetLabel("0",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_bindCopperLabel.move(440,78);
			addContent(_bindCopperLabel);
			
			_starComboBox = new ComboBox();
			_starComboBox.setSize(98,19);
			_starComboBox.move(130,52);
			addContent(_starComboBox);
			
			
			var dp:DataProvider = new DataProvider();
			var list:Dictionary = PersonalStarTemplateList.list;
			for each(var starInfo:PersonalStarTemplateInfo in list)
			{
				if(starInfo)
				{
					dp.addItem({label:starInfo.starName,value:starInfo.starId});
				}
			}
			_starComboBox.dataProvider = dp;
			
			_provinceComboBox = new ComboBox();
			_provinceComboBox.setSize(90,19);
			_provinceComboBox.move(280,24);
			addContent(_provinceComboBox);
			
			var dp1:DataProvider = new DataProvider();
			var list1:Dictionary = PersonalProvinceTemplateList.list;
			for each(var provinceInfo:PersonalProvinceTemplateInfo in list1)
			{
				if(provinceInfo)
				{
					dp1.addItem({label:provinceInfo.provinceName,value:provinceInfo.provinceId});
				}
			}
			_provinceComboBox.dataProvider = dp1;
			
			_cityComboBox = new ComboBox();
			_cityComboBox.setSize(90,19);
			_cityComboBox.move(280,52);
			addContent(_cityComboBox);
			
			_moodField = new TextField();
			_moodField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_moodField.filters = [new GlowFilter(0x1D250E,1,4,4,4.5)];
			_moodField.type = TextFieldType.INPUT;
			_moodField.maxChars = 25;
			_moodField.width = 294;
			_moodField.height = 19;
			_moodField.x = 74;
			_moodField.y = 107;
			addContent(_moodField);
			
			
			_introduceField = new TextField();
			_introduceField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
			_introduceField.filters = [new GlowFilter(0x1D250E,1,4,4,4.5)];
			_introduceField.type = TextFieldType.INPUT;
			_introduceField.multiline = true;
			_introduceField.wordWrap = true;
			_introduceField.maxChars = 70;
			_introduceField.width = 440;
			_introduceField.height = 37;
			_introduceField.x = 74;
			_introduceField.y = 144;
			addContent(_introduceField);
			
			_changeHeadSprite = new Sprite();
			_changeHeadSprite.buttonMode = true;
			_changeHeadSprite.graphics.beginFill(0,0);
			_changeHeadSprite.graphics.drawRect(15,74,76,17);
			_changeHeadSprite.graphics.endFill();
			addContent(_changeHeadSprite);
			
//			_dayRewardsBtn = new MCacheAsset1Btn(2,"每日奖励");
			_dayRewardsBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.personal.dayAward"));
			_dayRewardsBtn.move(14,190);
			_dayRewardsBtn.enabled = false;
			addContent(_dayRewardsBtn);
			
//			_getRewardsBtn = new MCacheAsset1Btn(2,"领取奖励");
			_getRewardsBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.getAward"));
			_getRewardsBtn.move(418,100);
			_getRewardsBtn.enabled = false;
			addContent(_getRewardsBtn);
			
//			_changeSettingBtn = new MCacheAsset1Btn(2,"修改设置");
			_changeSettingBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.changeSetting"));
			_changeSettingBtn.move(100,190);
			addContent(_changeSettingBtn);
			
			//-------------默认头像---------------------/
			_headCell = new PersonalHeadCell();
			_headCell.move(30,22);
			addContent(_headCell);
			var index:int;
			if(GlobalData.selfPlayer.career == 1)
			{
				index = 0;
			}
			else if(GlobalData.selfPlayer.career == 2)
			{
				index = 1;
			}
			else 
			{
				index = 2;
			}
			_headCell.updateHead(GlobalData.selfPlayer.sex,index);
			//---------------------------------//
			_btns = [];
			var poses:Array = [new Point(16,249),new Point(16,278),new Point(16,307),new Point(16,336),new Point(16,365),new Point(16,394),new Point(16,423),new Point(16,452)];
//			var nameList:Array = ["幸运轮盘","好友动态","帮会动态","师徒动态","情侣试炼","小游戏类","小游戏类","小游戏类"];
			var nameList:Array = [
				LanguageManager.getWord("ssztl.personal.luckyWheel"),
				LanguageManager.getWord("ssztl.personal.friendDynamic"),
				LanguageManager.getWord("ssztl.personal.clubDynamic"),
				LanguageManager.getWord("ssztl.personal.masterDynamic"),
				LanguageManager.getWord("ssztl.personal.circsPractice"),
				LanguageManager.getWord("ssztl.personal.smallGame"),
				LanguageManager.getWord("ssztl.personal.smallGame"),
				LanguageManager.getWord("ssztl.personal.smallGame")];
			var tmpBtn:MCacheAsset3Btn;
			for(var i:int = 0;i<nameList.length;i++)
			{
				tmpBtn = new MCacheAsset3Btn(2,nameList[i]);
				tmpBtn.move(poses[i].x,poses[i].y);
				tmpBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				_btns.push(tmpBtn);
				addContent(tmpBtn);
				tmpBtn.enabled = false;
			}
			_btns[5].enabled = false;
			_btns[6].enabled = false;
			_btns[7].enabled = false;
			
			_handlers = [luckyWeelClickHandler,friendClickHandler,clubClickHandler,masterClickHandler,loverClickHandler,loverClickHandler,loverClickHandler,loverClickHandler];
		
			_mTileFriend = new MTile(416,40);
			_mTileFriend.itemGapH = _mTileFriend.itemGapW = 0;
			_mTileFriend.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTileFriend.setSize(416,235);
			_mTileFriend.move(104,242);
//			addContent(_mTileFriend);
			_mTileClub = new MTile(416,40);
			_mTileClub.itemGapH = _mTileClub.itemGapW = 0;
			_mTileClub.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTileClub.setSize(416,235);
			_mTileClub.move(104,242);
//			addContent(_mTileClub);
			
			_itemViewFriendList = [];
			_itemViewClubList = [];
			//屏蔽某些动作
			forbbidBtn();
		}
		
		private function forbbidBtn():void
		{
			if(!_isMySelf)
			{
				_btns[0].enabled = false;
				_btns[1].enabled = false;
				_btns[2].enabled = false;
				_btns[3].enabled = false;
				_btns[4].enabled = false;
				_btns[5].enabled = false;
				_btns[6].enabled = false;
				_btns[7].enabled = false;
				_dayRewardsBtn.enabled = false;
				_changeSettingBtn.enabled = false;
				_changeHeadSprite.buttonMode = false;
				_changeHeadSprite.mouseChildren = _changeHeadSprite.mouseEnabled = false;
				_starComboBox.mouseEnabled =_starComboBox.mouseChildren = false;
				_provinceComboBox.mouseEnabled = _provinceComboBox.mouseChildren = false;
				_cityComboBox.mouseEnabled = _cityComboBox.mouseChildren = false;
				_moodField.mouseEnabled = false;
				_introduceField.mouseEnabled = false;
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheAsset3Btn);
			_handlers[index]();
		}
		private function spriteClickHandler(e:MouseEvent):void
		{
			_mediator.showChangeHeadPanel();
		}
		
		private function comboBoxChangeHandler(e:Event):void
		{
			updateCityComboBox(_provinceComboBox.selectedIndex);
		}
		
		private function updateCityComboBox(argSelectIndex:int):void
		{
			var dp:DataProvider = new DataProvider();
			var list:Array = PersonalCityTemplateList.getCityTemplateList(argSelectIndex);
			for each(var cityInfo:PersonalCityTemplateInfo in list)
			{
				if(cityInfo)
				{
					dp.addItem({label:cityInfo.cityName,value:cityInfo.cityId});
				}
			}
			_cityComboBox.dataProvider = dp;
			_cityComboBox.selectedIndex = myInfo.cityId;
		}
			
		
		private function luckyWeelClickHandler():void
		{
			_mediator.showPersonalLuckyWheelPanel(_playerId);
		}
		private function friendClickHandler():void
		{
			if(_mTileClub.parent)_mTileClub.parent.removeChild(_mTileClub);
			addContent(_mTileFriend);
			clearFriendList();
			for each(var i:PersonalDynamicItemInfo in GlobalData.personalInfo.personalFriendInfo.itemInfoList)
			{
				var tmpItemView:PersonalDynamicItemView = new PersonalDynamicItemView(_mediator,i);
				_itemViewFriendList.push(tmpItemView);
				_mTileFriend.appendItem(tmpItemView);
			}
		}
		private function clubClickHandler():void
		{
			if(_mTileFriend.parent)_mTileFriend.parent.removeChild(_mTileFriend);
			addContent(_mTileClub);
			clearClubList();
			for each(var i:PersonalDynamicItemInfo in GlobalData.personalInfo.personalClubInfo.itemInfoList)
			{
				var tmpItemView:PersonalDynamicItemView = new PersonalDynamicItemView(_mediator,i);
				_itemViewClubList.push(tmpItemView);
				_mTileClub.appendItem(tmpItemView);
			}
		}
		private function masterClickHandler():void
		{
		}
		private function loverClickHandler():void
		{
			
		}
		
		private function initEvents():void
		{
			if(_isMySelf)
			{
				_dayRewardsBtn.addEventListener(MouseEvent.CLICK,otherBtnClickHandler);
				_getRewardsBtn.addEventListener(MouseEvent.CLICK,otherBtnClickHandler);
				_changeSettingBtn.addEventListener(MouseEvent.CLICK,otherBtnClickHandler);
				myInfo.addEventListener(PersonalInfoUpdateEvents.PERSONAL_MY_HEAD_UPDATE,updateHead);
				GlobalData.personalInfo.personalFriendInfo.addEventListener(PersonalInfoUpdateEvents.PERSONAL_FRIENDINFO_UPDATE,updateFriendDynamicInfoHandler);
				GlobalData.personalInfo.personalClubInfo.addEventListener(PersonalInfoUpdateEvents.PERSONAL_CLUBINFO_UPDATE,updateClubDynamicInfoHandler);
				_changeHeadSprite.addEventListener(MouseEvent.CLICK,spriteClickHandler);
				_provinceComboBox.addEventListener(Event.CHANGE,comboBoxChangeHandler);
			}
			myInfo.addEventListener(PersonalInfoUpdateEvents.PERSONAL_MY_INFO_UPDATE,updateDataHandler);
			
		}
		
		private function removeEvents():void
		{
			if(_isMySelf)
			{
				_dayRewardsBtn.removeEventListener(MouseEvent.CLICK,otherBtnClickHandler);
				_getRewardsBtn.removeEventListener(MouseEvent.CLICK,otherBtnClickHandler);
				_changeSettingBtn.removeEventListener(MouseEvent.CLICK,otherBtnClickHandler);
				myInfo.removeEventListener(PersonalInfoUpdateEvents.PERSONAL_MY_HEAD_UPDATE,updateHead);
				GlobalData.personalInfo.personalFriendInfo.removeEventListener(PersonalInfoUpdateEvents.PERSONAL_FRIENDINFO_UPDATE,updateFriendDynamicInfoHandler);
				GlobalData.personalInfo.personalClubInfo.removeEventListener(PersonalInfoUpdateEvents.PERSONAL_CLUBINFO_UPDATE,updateClubDynamicInfoHandler);
				_changeHeadSprite.removeEventListener(MouseEvent.CLICK,spriteClickHandler);
				_provinceComboBox.removeEventListener(Event.CHANGE,comboBoxChangeHandler);
			}
			myInfo.removeEventListener(PersonalInfoUpdateEvents.PERSONAL_MY_INFO_UPDATE,updateDataHandler);
		}
		
		private function updateDataHandler(e:PersonalInfoUpdateEvents):void
		{
			 _nameLabel.text = "[" + myInfo.serverId + "]" + myInfo.nick;
			 _starComboBox.selectedIndex = myInfo.starId;
			 _provinceComboBox.selectedIndex = myInfo.provinceId;
			 _cityComboBox.selectedIndex = myInfo.cityId;
			 updateCityComboBox(_provinceComboBox.selectedIndex);
			 _moodField.text = myInfo.mood;
			 _introduceField.text = myInfo.introduce;
			 _experienceLabel.text = myInfo.winNum.toString();
			 _lifeExpLabel.text = myInfo.failNum.toString();
			 
			 if(myInfo.isCanGetRewards && _isMySelf)
			 {
				 _dayRewardsBtn.enabled = true;
			 }
			 else
			 {
				 _dayRewardsBtn.enabled = false;
			 }
			 if(myInfo.headIndex !=-1)
				 _headCell.updateHead(GlobalData.selfPlayer.sex,myInfo.headIndex);
		}
		
		private function updateHead(e:PersonalInfoUpdateEvents):void
		{
			_headCell.updateHead(GlobalData.selfPlayer.sex,myInfo.headIndex);
		}
		
		private function updateFriendDynamicInfoHandler(e:PersonalInfoUpdateEvents):void
		{
			var tmpItemInfo:PersonalDynamicItemInfo = e.data as PersonalDynamicItemInfo;
			if(!tmpItemInfo)return;
			var tmpItemView:PersonalDynamicItemView = new PersonalDynamicItemView(_mediator,tmpItemInfo);
			_itemViewFriendList.push(tmpItemView);
			_mTileFriend.appendItem(tmpItemView);
		}
		private function updateClubDynamicInfoHandler(e:PersonalInfoUpdateEvents):void
		{
			var tmpItemInfo:PersonalDynamicItemInfo = e.data as PersonalDynamicItemInfo;
			if(!tmpItemInfo)return;
			var tmpItemView:PersonalDynamicItemView = new PersonalDynamicItemView(_mediator,tmpItemInfo);
			_itemViewClubList.push(tmpItemView);
			_mTileClub.appendItem(tmpItemView);
		}
		
		private function otherBtnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _dayRewardsBtn:
					_mediator.sendRewards();
					_dayRewardsBtn.enabled = false;
					break;
				case _changeSettingBtn:
					changeBtnHandler();
					break;
			}
		}
		
		private function changeBtnHandler():void
		{
			if((_starComboBox.selectedIndex == myInfo.starId) && (_provinceComboBox.selectedIndex == myInfo.provinceId) && (_cityComboBox.selectedIndex == myInfo.cityId) &&
				(_moodField.text == myInfo.mood) && (_introduceField.text == myInfo.introduce) && (myInfo.oldIndex == myInfo.headIndex))
			{
//				QuickTips.show("没有进行任何修改。");
				QuickTips.show(LanguageManager.getWord("ssztl.personal.noAnyChange"));
				return;
			}
			_mediator.sendChangeInfo(_starComboBox.selectedIndex,_provinceComboBox.selectedIndex,_cityComboBox.selectedIndex,_moodField.text,_introduceField.text,myInfo.headIndex);
		}
		
		private function clearFriendList():void
		{
			_itemViewFriendList.length = 0;
			_mTileFriend.disposeItems();
		}
		
		private function clearClubList():void
		{
			_itemViewClubList.length = 0;
			_mTileClub.disposeItems();
		}
		
		
		private function get myInfo():PersonalMyInfo
		{
			return personalPartInfo.personaOtherMainInfo;
		}
		
		private function get personalPartInfo():PersonalPartInfo
		{
			return _mediator.personalModule.personalInfoList[_playerId];
		}
		
		private function isMySelfHandler():void
		{
			if(GlobalData.selfPlayer.userId == _playerId)
			{
				_isMySelf = true;
			}
			else
			{
				_isMySelf = false;
			}
		}
			
		
		override public function dispose():void
		{
			removeEvents();
			personalPartInfo.clearOtherMainInfo();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_changeHeadSprite.parent)_changeHeadSprite.parent.removeChild(_changeHeadSprite);
			_changeHeadSprite = null;
			if(_dayRewardsBtn)
			{
				_dayRewardsBtn.dispose();
				_dayRewardsBtn = null;
			}
			if(_changeSettingBtn)
			{
				_changeSettingBtn.dispose();
				_changeSettingBtn = null;
			}
			
			_nameLabel = null;
			_starComboBox = null;
			_provinceComboBox = null;
			_cityComboBox = null;
			_moodField = null;
			_introduceField = null;
			_experienceLabel = null;
			_lifeExpLabel = null;
			_bindCopperLabel = null;
			for(var i:int = 0;i < _btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
				_btns[i].dispose();
				_btns[i] = null;
			}
			_btns = null;
			_handlers = null;
			if(_headCell)
			{
				_headCell.dispose();
				_headCell = null;
			}
			if(_mTileFriend)
			{
				_mTileFriend.dispose();
				_mTileFriend = null;
			}
			for(var j:int = 0;j < _itemViewFriendList.length;j++)
			{
				_itemViewFriendList[j].dispose();
				_itemViewFriendList[j] = null;
			}
			_itemViewFriendList = null;
			if(_mTileClub)
			{
				_mTileClub.dispose();
				_mTileClub = null;
			}
			for(var m:int = 0;m < _itemViewClubList.length;m++)
			{
				_itemViewClubList[m].dispose();
				_itemViewClubList[m] = null;
			}
			_itemViewClubList = null;
			super.dispose();
			if(parent)parent.removeChild(this);
		}

		public function get playerId():Number
		{
			return _playerId;
		}

	}
}