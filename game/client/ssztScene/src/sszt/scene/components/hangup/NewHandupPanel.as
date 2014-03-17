package sszt.scene.components.hangup
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.HangupData;
	import sszt.scene.data.HanpupDataUpdateEvent;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.HangupMediator;
	import sszt.scene.socketHandlers.PlayerHangupDataSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.SplitCompartLine2;
	
	public class NewHandupPanel extends MPanel
	{
		private var _mediator:HangupMediator;
		private var _bg:IMovieWrapper;
		private var _fightBtn:MCacheAssetBtn1;
		private var _defaultBtn:MCacheAssetBtn1;
		private var _stopBtn:MCacheAssetBtn1;
		private var _saveBtn:MCacheAssetBtn1;
		private var _simpleSetBtn:MCacheAssetBtn1;
		
		private var _autoAddSkillBtn:MCacheAssetBtn1;
		
		private var _allSelectBtn:MCacheAssetBtn1;
		private var _allNoSelectBtn:MCacheAssetBtn1;
		private var _taskSelectBtn:MCacheAssetBtn1;
		
		private var _checkList:Array;
		private var _monsterChecks:Array;
		private var _monsterList:Array;
		
		private var _acceptGroup:RadioButton;
		private var _refuseGroup:RadioButton;
		private var _useHpDrugAdd:RadioButton;
		private var _useHpDrupDes:RadioButton;
		private var _useMpDrupAdd:RadioButton;
		private var _useMpDrupDes:RadioButton;
		
		private var _hpField:TextField;
		private var _mpField:TextField;
		
		private var _descriptLabel:MAssetLabel;
		
		private var _skillTile:MTile;
		private var _mTile:MTile;
		private var _cells:Array;
		
		private var _comboBox1:ComboBox;
		private var _comboBox2:ComboBox;
		private var _comboBox3:ComboBox;
		
		private var _textAutoRest:MAssetLabel;
		private var _hpPercent:MAssetLabel;
		private var _mpPercent:MAssetLabel;
				
		public function NewHandupPanel(mediator:HangupMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.HandUpTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.HandUpTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.HANGUP));
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(356,442);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,4,340,430)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,8,332,119)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,129,332,262)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,390,332,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(113,243,40,20)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(113,269,40,20)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,342,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(62,342,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(101,342,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(140,342,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(179,342,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,342,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(257,342,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(296,342,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(25,22,100,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.handUpCheck0"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(25,316,100,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.handUpCheck14"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_allSelectBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.all"));
			_allSelectBtn.move(253,18);
			addContent(_allSelectBtn);
			_allNoSelectBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.cannel"));
			_allNoSelectBtn.move(295,18);
			addContent(_allNoSelectBtn);
			_taskSelectBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.activity.task"));
			_taskSelectBtn.move(211,18);
			addContent(_taskSelectBtn);
			
			_autoAddSkillBtn = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.scene.autoAdd"));
			_autoAddSkillBtn.move(270,312);
			addContent(_autoAddSkillBtn);
			
			_checkList = [];			
			var labels:Array = [
//				LanguageManager.getWord("ssztl.scene.handUpCheck8"),
				LanguageManager.getWord("ssztl.scene.handUpCheck13"),
				LanguageManager.getWord("ssztl.scene.handUpCheck7"),
				LanguageManager.getWord("ssztl.scene.handUpCheck21"),
//				LanguageManager.getWord("ssztl.scene.hangUpCheck19"),
				LanguageManager.getWord("ssztl.scene.handUpCheck22")//,
//				LanguageManager.getWord("ssztl.scene.handUpCheck21"),
//				LanguageManager.getWord("ssztl.scene.handUpCheck22"),
			];
			
			var i:int = 0;
			for(i = 0; i < labels.length; i++)
			{
				var check:CheckBox = new CheckBox();
				check.label = labels[i];
				check.move(25, 143 + i * 23);
				addContent(check);
				check.setSize(240,22);
				_checkList.push(check);
			}
			
			_comboBox1 = new ComboBox();
			_comboBox1.setSize(87,20);
			_comboBox1.move(133,107);
			var dp:DataProvider = new DataProvider();
			dp.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality"),value:0});
			dp.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality1"),value:1});
			dp.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality2"),value:2});
			dp.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality3"),value:3});
			dp.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality4"),value:4});
			_comboBox1.dataProvider = dp;
			_comboBox1.selectedIndex = 0;
//			addContent(_comboBox1);
			
			_comboBox2 = new ComboBox();
			_comboBox2.setSize(87,20);
			_comboBox2.move(226,107);
			var dp2:DataProvider = new DataProvider();
			dp2.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpCareer"),value:0});
			dp2.addItem({label:LanguageManager.getWord("ssztl.common.shangWu"),value:1});
			dp2.addItem({label:LanguageManager.getWord("ssztl.common.xiaoYao"),value:2});
			dp2.addItem({label:LanguageManager.getWord("ssztl.common.liuXing"),value:3});
			_comboBox2.dataProvider = dp2;
			_comboBox2.selectedIndex = 0;
//			addContent(_comboBox2);
			
			_comboBox3 = new ComboBox();
			_comboBox3.setSize(87,20);
			_comboBox3.move(155,145);
			var dp3:DataProvider = new DataProvider();
			dp3.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpItem"),value:0});
			dp3.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality1"),value:1});
			dp3.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality2"),value:2});
			dp3.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality3"),value:3});
			dp3.addItem({label:LanguageManager.getWord("ssztl.scene.hangUpQuality4"),value:4});
			_comboBox3.dataProvider = dp3;
			_comboBox3.selectedIndex = 0;
			addContent(_comboBox3);
			
			_mTile = new MTile(150,24,2);
			_mTile.itemGapW = _mTile.itemGapH = 0;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalLineScrollSize = 42;
			_mTile.setSize(314,75);
			_mTile.move(25,47);
			addContent(_mTile);
			
			_monsterChecks = [];
			_monsterList = [];
			if(!(_mediator.sceneInfo.mapInfo.isClubFire() || GlobalData.copyEnterCountList.isTowerCopy() ||
				_mediator.sceneInfo.mapInfo.isResourceWar() || _mediator.sceneInfo.mapInfo.isShenmoDouScene()))   //守塔副本或者帮会地图屏蔽挂机怪物
			{	
				_monsterList = _mediator.sceneInfo.mapInfo.getSceneMonsterIds();
				i = 0;
				if(_monsterList) _monsterList.sort(compareFunction);
				if(_monsterList)
				{
					for each(var monster:MonsterTemplateInfo in _monsterList)
					{
						var monsterCheck:CheckBox = new CheckBox();
						
						var level:int = monster.level;
						if(GlobalData.copyEnterCountList.isInCopy)
						{
							var tempCopy:CopyTemplateItem = CopyTemplateList.getCopy(GlobalData.copyEnterCountList.inCopyId);
							if(tempCopy && tempCopy.isDynamic)
							{
								level = level + (_mediator.sceneInfo.teamData.getAverageLevel() - tempCopy.minLevel);	
							}
						}
						
						monsterCheck.label = monster.name + LanguageManager.getWord("ssztl.common.levelValue2",level);//LanguageManager.getWord("ssztl.common.levelValue2",level);
						monsterCheck.move(93 + (i % 2) * 120,20 + int(i / 2) * 24);
						monsterCheck.setSize(150,20);
						//addContent(monsterCheck);
						_monsterChecks.push(monsterCheck);
						_mTile.appendItem(monsterCheck);
						i++;
						
						for each(var monsterId:int in _mediator.sceneInfo.hangupData.monsterList)
						{
							if(monster.monsterId == monsterId)
							{
								monsterCheck.selected = true;
							}
						}
					}
				}
			}
						
			_hpField = new TextField();
			_mpField = new TextField();
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff);
			_hpField.defaultTextFormat = _mpField.defaultTextFormat = format;
			_hpField.setTextFormat(format);
			_mpField.setTextFormat(format);
			_hpField.x = _mpField.x = 132;
			_hpField.y = 133;
			_mpField.y = 195;
			_hpField.width = _mpField.width = 27;
			_hpField.type = _mpField.type = TextFieldType.INPUT;
			_hpField.restrict = _mpField.restrict = "0123456789";
			_hpField.maxChars = _mpField.maxChars = 2;
			_hpField.height = _mpField.height = 20;
//			addContent(_hpField);
//			addContent(_mpField);
			
			_fightBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.openHungUp"));
			_fightBtn.move(37,398);
			addContent(_fightBtn);
			_stopBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.stopHungUp"));
			_stopBtn.move(37,398);
			addContent(_stopBtn);
			
			
			_defaultBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.default"));
			_defaultBtn.move(179,398);
			addContent(_defaultBtn);
			
			_saveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.save"));
			_saveBtn.move(250,398);
			addContent(_saveBtn);
			
			_simpleSetBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scenc.simpleSet"));
			_simpleSetBtn.move(108,398);
			addContent(_simpleSetBtn);
			
			var group:RadioButtonGroup = new RadioButtonGroup("group");
			_acceptGroup = new RadioButton();
			_acceptGroup.label = LanguageManager.getWord("ssztl.common.accept");
			_acceptGroup.setSize(100,20);
			_acceptGroup.move(363,134);
			_acceptGroup.group = group;
//			addContent(_acceptGroup);
			_refuseGroup = new RadioButton();
			_refuseGroup.label = LanguageManager.getWord("ssztl.scene.refuse");
			_refuseGroup.setSize(100,20);
			_refuseGroup.move(419,134);
			_refuseGroup.group = group;
//			addContent(_refuseGroup);
			
			var group1:RadioButtonGroup = new RadioButtonGroup("hp");
			_useHpDrugAdd = new RadioButton();
			_useHpDrugAdd.label = LanguageManager.getWord("ssztl.scene.useDrugFromMax");
			_useHpDrugAdd.setSize(150,20);
			_useHpDrugAdd.move(43,155);
			_useHpDrugAdd.group = group1;
//			addContent(_useHpDrugAdd);
			_useHpDrupDes = new RadioButton();
			_useHpDrupDes.label = LanguageManager.getWord("ssztl.scene.useDrugFromleast");
			_useHpDrupDes.setSize(150,20);
			_useHpDrupDes.move(43,172);
			_useHpDrupDes.group = group1;
//			addContent(_useHpDrupDes);
			
			var group2:RadioButtonGroup = new RadioButtonGroup("mp");
			_useMpDrupAdd = new RadioButton();
			_useMpDrupAdd.label = LanguageManager.getWord("ssztl.scene.useDrugFromMax");
			_useMpDrupAdd.setSize(150,20);
			_useMpDrupAdd.move(43,217);
			_useMpDrupAdd.group = group2;
//			addContent(_useMpDrupAdd);
			_useMpDrupDes = new RadioButton();
			_useMpDrupDes.label = LanguageManager.getWord("ssztl.scene.useDrugFromleast");
			_useMpDrupDes.setSize(150,20);
			_useMpDrupDes.move(43,234);
			_useMpDrupDes.group = group2;
//			addContent(_useMpDrupDes);
			
			_textAutoRest = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_textAutoRest.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,14)]);
			_textAutoRest.move(48,245);
			addContent(_textAutoRest);
			_textAutoRest.setHtmlValue( LanguageManager.getWord("ssztl.scene.handUpCheck30"));
			
			_hpPercent = new MAssetLabel("",MAssetLabel.LABEL_TYPE9);
			_hpPercent.move(113,245);
			_hpPercent.setSize(40,18);
			_hpPercent.maxChars = 2;
			_hpPercent.restrict ="0123456789";
			
			addContent(_hpPercent);
			_hpPercent.setValue("50");
			
			_mpPercent = new MAssetLabel("",MAssetLabel.LABEL_TYPE9);
			_mpPercent.move(113,271);
			_mpPercent.setSize(40,18);
			_mpPercent.maxChars = 2;
			_mpPercent.restrict ="0123456789";
			addContent(_mpPercent);
			_mpPercent.setValue("50");
			
			_hpPercent.mouseEnabled = _mpPercent.mouseEnabled = true;
			_hpPercent.type = _mpPercent.type = TextFieldType.INPUT;
			
			_cells = [];
			_skillTile = new MTile(37,37,8);
			_skillTile.itemGapW = 2;
			_skillTile.itemGapH = 7;
			_skillTile.setSize(320,40);
			_skillTile.verticalScrollPolicy = _skillTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_skillTile.move(23,342);
			addContent(_skillTile);
			for(var j:int = 0; j < 10; j++)
			{
				var cell:HangupCell = new HangupCell(j);
				_cells.push(cell);
				_skillTile.appendItem(cell);
				cell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				cell.addEventListener(HangupCellEvent.DRAG_OUT,dragOutHandler);
				cell.addEventListener(HangupCellEvent.DRAG_IN,cellDragInHandler);
			}
			
			initData();
			
			initEvent();
			
			if(_mediator.sceneInfo.playerList.self.getIsHangup())
			{
				_fightBtn.visible = false;
				_stopBtn.visible = true;
				
			}
			else
			{
				_fightBtn.visible = true;
				_stopBtn.visible = false;
				var hasSelect:Boolean = taskClickHandler(null);
				if(!hasSelect || GlobalData.copyEnterCountList.isInCopy)
				{
					allSelectClickHandler(null);
//					for each(var checkb:CheckBox in _monsterChecks)
//					{
//						checkb.selected = true;
//					}
				}
			}
			
			setGuideTipHandler(null);
		}
		
		private function compareFunction(moster1:MonsterTemplateInfo,moster2:MonsterTemplateInfo):int
		{
			if(moster1.level > moster2.level)
				return 1;
			return -1;
		}
		
		private function initEvent():void
		{
			_simpleSetBtn.addEventListener(MouseEvent.CLICK, _simpleSetClickHandler);
			_fightBtn.addEventListener(MouseEvent.CLICK,fightClickHandler);
			_stopBtn.addEventListener(MouseEvent.CLICK,stopClickHandler);
			_defaultBtn.addEventListener(MouseEvent.CLICK,defaultClickHandler);
			_saveBtn.addEventListener(MouseEvent.CLICK,saveClickHandler);
			_allSelectBtn.addEventListener(MouseEvent.CLICK,allSelectClickHandler);
			_allNoSelectBtn.addEventListener(MouseEvent.CLICK,allNoSelectClickHandler);
			_taskSelectBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_autoAddSkillBtn.addEventListener(MouseEvent.CLICK,autoAddSkillClickHandler);
//			_checkList[0].addEventListener(Event.CHANGE,useHpChangeHandler);
//			_checkList[1].addEventListener(Event.CHANGE,useMpChangeHandler);
//			_checkList[7].addEventListener(Event.CHANGE,autoPickEquipChangeHandler);
//			_checkList[12].addEventListener(Event.CHANGE,autoPickOtherChangeHandler);
//			_checkList[6].addEventListener(Event.CHANGE,autoGroupChangeHandler);
			_mediator.sceneInfo.hangupData.addEventListener(HanpupDataUpdateEvent.ADD_SKILL,dataAddSkillHandler);
			_mediator.sceneInfo.hangupData.addEventListener(HanpupDataUpdateEvent.REMOVE_SKILL,dataRemoveSkillHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvent():void
		{
			_simpleSetBtn.removeEventListener(MouseEvent.CLICK, _simpleSetClickHandler);
			_fightBtn.removeEventListener(MouseEvent.CLICK,fightClickHandler);
			_stopBtn.removeEventListener(MouseEvent.CLICK,stopClickHandler);
			_defaultBtn.removeEventListener(MouseEvent.CLICK,defaultClickHandler);
			_saveBtn.removeEventListener(MouseEvent.CLICK,saveClickHandler);
			_allSelectBtn.removeEventListener(MouseEvent.CLICK,allSelectClickHandler);
			_allNoSelectBtn.removeEventListener(MouseEvent.CLICK,allNoSelectClickHandler);
			_taskSelectBtn.removeEventListener(MouseEvent.CLICK,taskClickHandler);
			_autoAddSkillBtn.removeEventListener(MouseEvent.CLICK,autoAddSkillClickHandler);
//			_checkList[0].removeEventListener(Event.CHANGE,useHpChangeHandler);
//			_checkList[1].removeEventListener(Event.CHANGE,useMpChangeHandler);
//			_checkList[7].removeEventListener(Event.CHANGE,autoPickEquipChangeHandler);
//			_checkList[12].removeEventListener(Event.CHANGE,autoPickOtherChangeHandler);
//			_checkList[6].removeEventListener(Event.CHANGE,autoGroupChangeHandler);
			_mediator.sceneInfo.hangupData.removeEventListener(HanpupDataUpdateEvent.ADD_SKILL,dataAddSkillHandler);
			_mediator.sceneInfo.hangupData.removeEventListener(HanpupDataUpdateEvent.REMOVE_SKILL,dataRemoveSkillHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);			
		}
		
		private function initData():void
		{
			var hangupData:HangupData = _mediator.sceneInfo.hangupData;
			_checkList[0].selected = hangupData.autoPickEquip;
			var temp1:int = 0;
			for(temp1; temp1 < 5; temp1++)
			{
				if(hangupData.pickEquips[temp1])
				{
					_comboBox1.selectedIndex = temp1;
					break;
				}
			}
			_comboBox2.selectedIndex = hangupData.pickEquipsCareer;
			temp1 = 0;
			for(temp1; temp1 < 5; temp1++)
			{
				if(hangupData.pickOthers[temp1])
				{
					_comboBox3.selectedIndex = temp1;
					break;
				}
			}			
//			_checkList[1].selected = hangupData.autoPickOther;
			
			_checkList[1].selected = hangupData.isAccept;
			_checkList[2].selected = hangupData.autoAddHp;
//			_checkList[3].selected = hangupData.autoDoubleExp;
			_checkList[3].selected = hangupData.autoAddMp;
			_hpPercent.setValue(hangupData.autoAddHpValue.toString());
			_mpPercent.setValue(hangupData.autoAddMpValue.toString());
//			_checkList[4].selected = hangupData.autoAddHp;
//			_checkList[5].selected = hangupData.autoAddMp;
			
			if(!hangupData.autoAddSkill)
			{
				for(var i:int = 0; i < hangupData.skillList.length; i++)
				{
					if(hangupData.skillList[i] && hangupData.skillList[i].getTemplate().getPrepareTime(hangupData.skillList[i].level) == 0)
					{
						_cells[i].skillInfo = hangupData.skillList[i];
					}
				}
			}
			else
			{
				var list:Array = GlobalData.skillShortCut.getItemList();
				var tt:int = 0;
				for(var m:int = 0; m < list.length; m++)
				{
					if(list[m] && list[m].length == 2)
					{
						var skillItemInfo:SkillItemInfo = GlobalData.skillInfo.getSkillById(list[m][1]);
						if(skillItemInfo && skillItemInfo.getTemplate().activeType == 0 && skillItemInfo.getTemplate().getPrepareTime(skillItemInfo.level) == 0)
						{
							_cells[tt].skillInfo = skillItemInfo;
							tt++;
						}
					}
					if(tt >= 10)break;
				}
				for(var mm:int = tt+1; mm < 10; mm++)
				{
					_cells[mm].skillInfo = null;
				}
			}
			
//			useHpChangeHandler(null);
//			useMpChangeHandler(null);
//			autoPickEquipChangeHandler(null);
//			autoPickOtherChangeHandler(null);
//			autoGroupChangeHandler(null);
			
			if(_monsterList)
			{
				for(var k:int = 0; k < _monsterList.length; k++)
				{
					if(_mediator.sceneInfo.hangupData.saveHangup.indexOf(_monsterList[k].monsterId) != -1)
					{
						_monsterChecks[k].selected = true;
					}
				}
			}
		}
		private function _simpleSetClickHandler(evt:MouseEvent):void
		{
			_mediator.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSIMPLEHANDUP);
			dispose();
		}
		
		private function fightClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(!MapTemplateList.getCanHangup())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotHandUp"));
				return;
			}
			
			_mediator.sceneInfo.hangupData.autoPickEquip = _checkList[0].selected;
			_mediator.sceneInfo.hangupData.pickEquips = [true,true,true,true,true];
			_mediator.sceneInfo.hangupData.isAccept = _checkList[1].selected;
//			_mediator.sceneInfo.hangupData.autoRelive = _checkList[2].selected;
//			_mediator.sceneInfo.hangupData.autoDoubleExp = _checkList[3].selected;
//			_mediator.sceneInfo.hangupData.autoFeedPet = _checkList[3].selected;
			_mediator.sceneInfo.hangupData.autoAddHp = _checkList[2].selected;
			_mediator.sceneInfo.hangupData.autoAddMp = _checkList[3].selected;
			_mediator.sceneInfo.hangupData.autoAddHpValue = int(_hpPercent.text);
			_mediator.sceneInfo.hangupData.autoAddMpValue = int(_mpPercent.text);
			
//			_mediator.sceneInfo.hangupData.autoAddHp = _checkList[5].selected;
//			_mediator.sceneInfo.hangupData.autoAddMp = _checkList[6].selected;
			
			
			var q1:int  = _comboBox1.selectedIndex;
			for(var temp1:int = 0; temp1 < q1; temp1++)
			{
				_mediator.sceneInfo.hangupData.pickEquips[temp1] = false;
			}
			_mediator.sceneInfo.hangupData.pickEquipsCareer = _comboBox2.selectedIndex;			
			_mediator.sceneInfo.hangupData.autoPickOther = _checkList[0].selected;
			_mediator.sceneInfo.hangupData.pickOthers = [true,true,true,true,true];
			var q2:int  = _comboBox3.selectedIndex;
			for(var temp2:int = 0; temp2 < q2; temp2++)
			{
				_mediator.sceneInfo.hangupData.pickOthers[temp2] = false;
			}
			
			_mediator.sceneInfo.hangupData.monsterList.length = 0;
			_mediator.sceneInfo.hangupData.attackPath = MapTemplateList.getMapTemplate(_mediator.sceneInfo.mapInfo.mapId).attackPath.slice();
			if(_mediator.sceneInfo.hangupData.attackIndex == _mediator.sceneInfo.hangupData.attackPath.length)_mediator.sceneInfo.hangupData.attackIndex = 0;
			
			var p:Boolean = false;												//是否有选中怪物
			var small:Number = 100000;
			_mediator.sceneInfo.hangupData.saveHangup.length = 0;
			for(var i:int = 0; i < _monsterChecks.length; i++)
			{
				if(_monsterChecks[i].selected)
				{
					p = true;
					var dis:Number = _monsterList[i].getDistance(_mediator.sceneInfo.playerList.self.sceneX,_mediator.sceneInfo.playerList.self.sceneY);
					if(dis < small)
					{
						_mediator.sceneInfo.hangupData.monsterList.unshift(_monsterList[i].monsterId);
						small = dis;
					}
					else
					{
						_mediator.sceneInfo.hangupData.monsterList.push(_monsterList[i].monsterId);
					}
					_mediator.sceneInfo.hangupData.saveHangup.push(_monsterList[i].monsterId);
				}
			}
			if(p == true)
			{
				if(_mediator.sceneInfo.hangupData.autoKillTask)
				{
					_mediator.sceneInfo.hangupData.monsterNeedCount = 1;
					_mediator.sceneInfo.hangupData.autoFindTask = true;
					_mediator.sceneInfo.hangupData.stopComplete = false;
					_mediator.sceneInfo.hangupData.updateCount();
				}
				else
				{
					_mediator.sceneInfo.hangupData.monsterNeedCount = -1;
					_mediator.sceneInfo.hangupData.autoFindTask = false;
					_mediator.sceneInfo.hangupData.stopComplete = false;
				}
				_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
				_mediator.sceneInfo.playerList.self.setHangupState();
				_fightBtn.visible = false;
				_stopBtn.visible = true;
			}
			for(var n:int = 0; n < 10; n++)
			{
				_mediator.sceneInfo.hangupData.skillList[n] = _cells[n].skillInfo;
			}
			PlayerHangupDataSocketHandler.sendConfig(_mediator.sceneInfo.hangupData.getConfigStr());
//			saveClickHandler(null);
			dispose();
		}
		
		private function useHpChangeHandler(evt:Event):void
		{
			_useHpDrugAdd.enabled = _useHpDrupDes.enabled = _hpField.mouseEnabled = _checkList[0].selected;
		}
		
		private function useMpChangeHandler(evt:Event):void
		{
			_useMpDrupAdd.enabled = _useMpDrupDes.enabled = _mpField.mouseEnabled = _checkList[1].selected;
		}
		
		private function stopClickHandler(e:MouseEvent):void
		{
			_mediator.sceneInfo.playerList.self.setKillOne();
			_fightBtn.visible = true;
			_stopBtn.visible = false;
		}
		
		private function defaultClickHandler(evt:MouseEvent):void
		{
			_mediator.sceneInfo.hangupData.setDefault();
			initData();
		}
		
		private function saveClickHandler(evt:MouseEvent):void
		{
			_mediator.sceneInfo.hangupData.autoPickEquip = _checkList[0].selected;
			_mediator.sceneInfo.hangupData.pickEquips = [true,true,true,true,true];
			_mediator.sceneInfo.hangupData.isAccept = _checkList[1].selected;
//			_mediator.sceneInfo.hangupData.autoRelive = _checkList[2].selected;
//			_mediator.sceneInfo.hangupData.autoDoubleExp = _checkList[3].selected;
//			_mediator.sceneInfo.hangupData.autoFeedPet = _checkList[3].selected;
			_mediator.sceneInfo.hangupData.autoAddHp = _checkList[2].selected;
			_mediator.sceneInfo.hangupData.autoAddMp = _checkList[3].selected;
			_mediator.sceneInfo.hangupData.autoAddHpValue = int(_hpPercent.text);
			_mediator.sceneInfo.hangupData.autoAddMpValue = int(_mpPercent.text);
			
			var q1:int  = _comboBox1.selectedIndex;
			for(var temp1:int = 0; temp1 < q1; temp1++)
			{
				_mediator.sceneInfo.hangupData.pickEquips[temp1] = false;
			}
			_mediator.sceneInfo.hangupData.pickEquipsCareer = _comboBox2.selectedIndex;			
			_mediator.sceneInfo.hangupData.autoPickOther = _checkList[0].selected;
			_mediator.sceneInfo.hangupData.pickOthers = [true,true,true,true,true];
			var q2:int  = _comboBox3.selectedIndex;
			for(var temp2:int = 0; temp2 < q2; temp2++)
			{
				_mediator.sceneInfo.hangupData.pickOthers[temp2] = false;
			}			
			var result:String = "";			
			result = _mediator.sceneInfo.hangupData.getConfigStr();
//			_mediator.sceneInfo.hangupData.setConfig(result);
			PlayerHangupDataSocketHandler.sendConfig(result);
		}
		
		private function autoPickEquipChangeHandler(evt:Event):void
		{
//			_checkList[8].enabled = _checkList[9].enabled = _checkList[10].enabled = _checkList[11].enabled = _checkList[7].selected;
		}
		private function autoPickOtherChangeHandler(evt:Event):void
		{
//			_checkList[13].enabled = _checkList[14].enabled = _checkList[15].enabled = _checkList[16].enabled = _checkList[12].selected;
		}
		private function autoGroupChangeHandler(evt:Event):void
		{
//			_acceptGroup.enabled = _refuseGroup.enabled = _checkList[6].selected;
		}
		
		private function allSelectClickHandler(evt:MouseEvent):void
		{
			for(var i:int = 0; i < _monsterChecks.length; i++)
			{
				_monsterChecks[i].selected = true;
			}
		}
		private function allNoSelectClickHandler(evt:MouseEvent):void
		{
			for(var i:int = 0; i < _monsterChecks.length; i++)
			{
				_monsterChecks[i].selected = false;
			}
		}
		private function taskClickHandler(evt:MouseEvent):Boolean
		{
			allNoSelectClickHandler(null);
			var hasselect:Boolean = false;
			var list:Dictionary = GlobalData.taskInfo.getTaskMonsters(_mediator.sceneInfo.mapInfo.mapId);
			for each(var data:Array in list)
			{
				if(data && data[1] > 0)
				{
					for(var i:int = 0; i < _monsterList.length; i++)
					{
						if(data[0] == _monsterList[i].monsterId)
						{
							_monsterChecks[i].selected = true;
							hasselect = true;
						}
					}
				}
			}
			return hasselect;
		}
		private function autoAddSkillClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var list:Array = GlobalData.skillShortCut.getItemList();
			var tt:int = 0;
			for(var m:int = 0; m < list.length; m++)
			{
				if(list[m] && list[m].length == 2)
				{
					var skillItemInfo:SkillItemInfo = GlobalData.skillInfo.getSkillById(list[m][1]);
					if(skillItemInfo && skillItemInfo.getTemplate().activeType == 0 && skillItemInfo.getTemplate().getPrepareTime(skillItemInfo.level) == 0)
					{
						_cells[tt].skillInfo = skillItemInfo;
						tt++;
					}
				}
				if(tt >= 10)break;
			}
			for(var mm:int = tt+1; mm < 10; mm++)
			{
				_cells[mm].skillInfo = null;
			}
			for(var n:int = 0; n < 10; n++)
			{
				_mediator.sceneInfo.hangupData.skillList[n] = _cells[n].skillInfo;
			}
		}
		
		private function cellDownHandler(evt:MouseEvent):void
		{
			GlobalAPI.dragManager.startDrag(evt.currentTarget as IDragable);
		}
		private function dragOutHandler(evt:HangupCellEvent):void
		{
			(evt.currentTarget as HangupCell).skillInfo = null;
			_mediator.sceneInfo.hangupData.removeSkill(evt.place);
		}
		private function cellDragInHandler(evt:HangupCellEvent):void
		{
			_mediator.sceneInfo.hangupData.addSkill(evt.place,evt.info);
		}
		
		private function dataAddSkillHandler(evt:HanpupDataUpdateEvent):void
		{
			_cells[evt.data["place"]].skillInfo = evt.data["skill"];
		}
		private function dataRemoveSkillHandler(evt:HanpupDataUpdateEvent):void
		{
			_cells[int(evt.data)].skillInfo = null;
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.HANGUP)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addContent);
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_fightBtn)
			{
				_fightBtn.dispose();
				_fightBtn = null;
			}
			if(_defaultBtn)
			{
				_defaultBtn.dispose();
				_defaultBtn = null;
			}
			if(_stopBtn)
			{
				_stopBtn.dispose();
				_stopBtn = null;
			}
			if(_saveBtn)
			{
				_saveBtn.dispose();
				_saveBtn = null;
			}
			if(_simpleSetBtn)
			{
				_simpleSetBtn.dispose();
				_simpleSetBtn = null;
			}
			if(_allSelectBtn)
			{
				_allSelectBtn.dispose();
				_allSelectBtn = null;
			}
			if(_allNoSelectBtn)
			{
				_allNoSelectBtn.dispose();
				_allNoSelectBtn = null;
			}
			if(_taskSelectBtn)
			{
				_taskSelectBtn.dispose();
				_taskSelectBtn = null;
			}
			if(_autoAddSkillBtn)
			{
				_autoAddSkillBtn.dispose();
				_autoAddSkillBtn = null;
			}
			_comboBox1 = null;
			_checkList = null;
			_monsterChecks = null;
			_monsterList = null;
			_acceptGroup = null;
			_refuseGroup = null;
			_useHpDrugAdd = null;
			_useHpDrupDes = null;
			_useMpDrupAdd = null;
			_useMpDrupDes = null;
			_hpField = null;
			_mpField = null;
			_mediator = null;
			_descriptLabel = null;
			if(_skillTile)
			{
				_skillTile.dispose();
				_skillTile = null;
			}
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for(var i:int = 0;i<_cells.length;i++)
			{
				_cells[i].removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				_cells[i].removeEventListener(HangupCellEvent.DRAG_OUT,dragOutHandler);
				_cells[i].removeEventListener(HangupCellEvent.DRAG_IN,cellDragInHandler);
				_cells[i].dispose();
			}
			_cells = null;
			super.dispose();
		}
	}
}