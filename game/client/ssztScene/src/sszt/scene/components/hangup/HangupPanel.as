package sszt.scene.components.hangup
{
	import fl.controls.CheckBox;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.HangupData;
	import sszt.scene.data.HanpupDataUpdateEvent;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.mediators.HangupMediator;
	import sszt.scene.socketHandlers.PlayerHangupDataSocketHandler;
	
	public class HangupPanel extends MPanel
	{
		private var _mediator:HangupMediator;
		private var _bg:IMovieWrapper;
		private var _fightBtn:MCacheAsset1Btn;
		private var _defaultBtn:MCacheAsset1Btn;
		private var _stopBtn:MCacheAsset1Btn;
		private var _saveBtn:MCacheAsset1Btn;
		
		private var _allSelectBtn:MCacheAsset3Btn;
		private var _allNoSelectBtn:MCacheAsset3Btn;
		private var _taskSelectBtn:MCacheAsset3Btn;
		
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
		
		private var _titleLabel:MAssetLabel;
		private var _descriptLabel:MAssetLabel;
		
		private var _skillTile:MTile;
		private var _cells:Array;
		
		public function HangupPanel(mediator:HangupMediator)
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
			
			setContentSize(351,398);
			
			_bg = BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,512,340)),
//				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,6,501,102)),
//				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,112,219,222)),
//				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(230,112,277,222)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,38,477,2),new MCacheSplit2Line()),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(235,194,265,2),new MCacheSplit2Line()),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(252,227,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(300,227,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(348,227,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(396,227,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(444,227,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(252,277,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(300,277,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(348,277,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(396,277,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(444,277,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(150,119,33,19)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(150,178,33,19))
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,7,340,382)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(14,13,327,87)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(14,102,327,166)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(14,274,327,75)),
				
			]);
			addContent(_bg as DisplayObject);
			
			
			
			
			_titleLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.mapMonsterList"),MAssetLabel.LABELTYPE3);
			_titleLabel.move(22,18);
			addContent(_titleLabel);
			
			_descriptLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.needOpneVip"),MAssetLabel.LABELTYPE2);
			_descriptLabel.move(18,308);
			addContent(_descriptLabel);
			
			_allSelectBtn = new MCacheAsset3Btn(1,LanguageManager.getWord("ssztl.scene.selectAll"));
			_allSelectBtn.move(346,11);
			addContent(_allSelectBtn);
			_allNoSelectBtn = new MCacheAsset3Btn(1,LanguageManager.getWord("ssztl.scene.cannelAll"));
			_allNoSelectBtn.move(425,11);
			addContent(_allNoSelectBtn);
			_taskSelectBtn = new MCacheAsset3Btn(1,LanguageManager.getWord("ssztl.scene.taskMonster"));
			_taskSelectBtn.move(267,11);
			addContent(_taskSelectBtn);
			
			_checkList = [];
			var labels:Array = [LanguageManager.getWord("ssztl.scene.handUpCheck1"),
				LanguageManager.getWord("ssztl.scene.handUpCheck2"),
				LanguageManager.getWord("ssztl.scene.handUpCheck3"),
				LanguageManager.getWord("ssztl.scene.handUpCheck4"),
				LanguageManager.getWord("ssztl.scene.handUpCheck5"),
				LanguageManager.getWord("ssztl.scene.handUpCheck6"),
				LanguageManager.getWord("ssztl.scene.handUpCheck7"),
				LanguageManager.getWord("ssztl.scene.handUpCheck8"),
				LanguageManager.getWord("ssztl.common.whiteQulity"),
				LanguageManager.getWord("ssztl.common.greenQulity"),
				LanguageManager.getWord("ssztl.common.blueQulity"),
				LanguageManager.getWord("ssztl.common.purpleQulity"),
				LanguageManager.getWord("ssztl.scene.handUpCheck13"),
				LanguageManager.getWord("ssztl.common.whiteQulity"),
				LanguageManager.getWord("ssztl.common.greenQulity"),
				LanguageManager.getWord("ssztl.common.blueQulity"),
				LanguageManager.getWord("ssztl.common.purpleQulity"),
				LanguageManager.getWord("ssztl.scene.handUpCheck14"),
				LanguageManager.getWord("ssztl.scene.handUpCheck15"),
				LanguageManager.getWord("ssztl.scene.handUpCheck16")
			];
			var poses:Array = [new Point(36,119),new Point(36,178),new Point(36,235),new Point(36,256),new Point(36,277),
				new Point(237,120),new Point(318,119),
				new Point(237,145),new Point(318,145),new Point(356,145),new Point(396,145),new Point(434,145),
				new Point(237,168),new Point(318,168),new Point(356,168),new Point(396,168),new Point(434,168),
				new Point(237,203),new Point(356,203),
				new Point(116,235)
			];
			var i:int = 0;
			for(i = 0; i < labels.length; i++)
			{
				var check:CheckBox = new CheckBox();
				check.label = labels[i];
				check.move(poses[i].x,poses[i].y);
				addContent(check);
				check.setSize(240,22);
				_checkList.push(check);
			}
			
			_monsterChecks = [];
			_monsterList = _mediator.sceneInfo.mapInfo.getSceneMonsterIds();
			i = 0;
			var hasSelected:Boolean = false;
			if(_monsterList)
			{
				for each(var monster:MonsterTemplateInfo in _monsterList)
				{
					var monsterCheck:CheckBox = new CheckBox();
					monsterCheck.label = monster.name;
					monsterCheck.move(13 + (i % 5) * 100,43 + int(i / 5) * 20);
					monsterCheck.setSize(100,20);
					addContent(monsterCheck);
					_monsterChecks.push(monsterCheck);
					i++;
					
					for each(var monsterId:int in _mediator.sceneInfo.hangupData.monsterList)
					{
						if(monster.monsterId == monsterId)
						{
							monsterCheck.selected = true;
							hasSelected = true;
						}
					}
				}
			}
			if(!hasSelected)
			{
				for each(var checkb:CheckBox in _monsterChecks)
				{
					checkb.selected = true;
				}
			}
			
			_hpField = new TextField();
			_mpField = new TextField();
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff);
			_hpField.defaultTextFormat = _mpField.defaultTextFormat = format;
			_hpField.setTextFormat(format);
			_mpField.setTextFormat(format);
			_hpField.x = _mpField.x = 158;
			_hpField.y = 120;
			_mpField.y = 179;
			_hpField.width = _mpField.width = 27;
			_hpField.type = _mpField.type = TextFieldType.INPUT;
			_hpField.restrict = _mpField.restrict = "0123456789";
			_hpField.maxChars = _mpField.maxChars = 2;
			_hpField.height = _mpField.height = 20;
			addContent(_hpField);
			addContent(_mpField);
			
			_fightBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.scene.startFight"));
			_fightBtn.move(446,343);
			addContent(_fightBtn);
			_stopBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.scene.stopFight"));
			_stopBtn.move(446,343);
			addContent(_stopBtn);
			
			
			_defaultBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.backDefault"));
			_defaultBtn.move(6,343);
			addContent(_defaultBtn);
			
			_saveBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.scene.saveConfigure"));
			_saveBtn.move(82,343);
			addContent(_saveBtn);
			
			var group:RadioButtonGroup = new RadioButtonGroup("group");
			_acceptGroup = new RadioButton();
			_acceptGroup.label = LanguageManager.getWord("ssztl.common.accept");
			_acceptGroup.setSize(100,20);
			_acceptGroup.move(413,121);
			_acceptGroup.group = group;
			addContent(_acceptGroup);
			_refuseGroup = new RadioButton();
			_refuseGroup.label = LanguageManager.getWord("ssztl.scene.refuse");
			_refuseGroup.setSize(100,20);
			_refuseGroup.move(459,121);
			_refuseGroup.group = group;
			addContent(_refuseGroup);
			
			var group1:RadioButtonGroup = new RadioButtonGroup("hp");
			_useHpDrugAdd = new RadioButton();
			_useHpDrugAdd.label = LanguageManager.getWord("ssztl.scene.useDrugFromMax");
			_useHpDrugAdd.setSize(150,20);
			_useHpDrugAdd.move(55,141);
			_useHpDrugAdd.group = group1;
			addContent(_useHpDrugAdd);
			_useHpDrupDes = new RadioButton();
			_useHpDrupDes.label = LanguageManager.getWord("ssztl.scene.useDrugFromleast");
			_useHpDrupDes.setSize(150,20);
			_useHpDrupDes.move(55,158);
			_useHpDrupDes.group = group1;
			addContent(_useHpDrupDes);
			
			var group2:RadioButtonGroup = new RadioButtonGroup("mp");
			_useMpDrupAdd = new RadioButton();
			_useMpDrupAdd.label = LanguageManager.getWord("ssztl.scene.useDrugFromMax");
			_useMpDrupAdd.setSize(150,20);
			_useMpDrupAdd.move(55,200);
			_useMpDrupAdd.group = group2;
			addContent(_useMpDrupAdd);
			_useMpDrupDes = new RadioButton();
			_useMpDrupDes.label = LanguageManager.getWord("ssztl.scene.useDrugFromleast");
			_useMpDrupDes.setSize(150,20);
			_useMpDrupDes.move(55,217);
			_useMpDrupDes.group = group2;
			addContent(_useMpDrupDes);
			
//			_cells = new Vector.<HangupCell>();
			_cells = [];
			_skillTile = new MTile(40,40,5);
			_skillTile.itemGapW = 8;
			_skillTile.itemGapH = 10;
			_skillTile.setSize(240,100);
			_skillTile.verticalScrollPolicy = _skillTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_skillTile.move(254,229);
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
				if(GlobalData.copyEnterCountList.isInCopy)allSelectClickHandler(null);
				else taskClickHandler(null);
			}
		
			setGuideTipHandler(null);
		}
		
		private function initEvent():void
		{
			_fightBtn.addEventListener(MouseEvent.CLICK,fightClickHandler);
			_stopBtn.addEventListener(MouseEvent.CLICK,stopClickHandler);
			_defaultBtn.addEventListener(MouseEvent.CLICK,defaultClickHandler);
			_saveBtn.addEventListener(MouseEvent.CLICK,saveClickHandler);
			_allSelectBtn.addEventListener(MouseEvent.CLICK,allSelectClickHandler);
			_allNoSelectBtn.addEventListener(MouseEvent.CLICK,allNoSelectClickHandler);
			_taskSelectBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_checkList[0].addEventListener(Event.CHANGE,useHpChangeHandler);
			_checkList[1].addEventListener(Event.CHANGE,useMpChangeHandler);
			_checkList[7].addEventListener(Event.CHANGE,autoPickEquipChangeHandler);
			_checkList[12].addEventListener(Event.CHANGE,autoPickOtherChangeHandler);
			_checkList[6].addEventListener(Event.CHANGE,autoGroupChangeHandler);
			_mediator.sceneInfo.hangupData.addEventListener(HanpupDataUpdateEvent.ADD_SKILL,dataAddSkillHandler);
			_mediator.sceneInfo.hangupData.addEventListener(HanpupDataUpdateEvent.REMOVE_SKILL,dataRemoveSkillHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvent():void
		{
			_fightBtn.removeEventListener(MouseEvent.CLICK,fightClickHandler);
			_stopBtn.removeEventListener(MouseEvent.CLICK,stopClickHandler);
			_defaultBtn.removeEventListener(MouseEvent.CLICK,defaultClickHandler);
			_saveBtn.removeEventListener(MouseEvent.CLICK,saveClickHandler);
			_allSelectBtn.removeEventListener(MouseEvent.CLICK,allSelectClickHandler);
			_allNoSelectBtn.removeEventListener(MouseEvent.CLICK,allNoSelectClickHandler);
			_taskSelectBtn.removeEventListener(MouseEvent.CLICK,taskClickHandler);
			_checkList[0].removeEventListener(Event.CHANGE,useHpChangeHandler);
			_checkList[1].removeEventListener(Event.CHANGE,useMpChangeHandler);
			_checkList[7].removeEventListener(Event.CHANGE,autoPickEquipChangeHandler);
			_checkList[12].removeEventListener(Event.CHANGE,autoPickOtherChangeHandler);
			_checkList[6].removeEventListener(Event.CHANGE,autoGroupChangeHandler);
			_mediator.sceneInfo.hangupData.removeEventListener(HanpupDataUpdateEvent.ADD_SKILL,dataAddSkillHandler);
			_mediator.sceneInfo.hangupData.removeEventListener(HanpupDataUpdateEvent.REMOVE_SKILL,dataRemoveSkillHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function initData():void
		{
			var hangupData:HangupData = _mediator.sceneInfo.hangupData;
			_checkList[0].selected = hangupData.autoAddHp;
			_useHpDrugAdd.selected = hangupData.addHpAdd;
			_useHpDrupDes.selected = !hangupData.addHpAdd;
			_checkList[1].selected = hangupData.autoAddMp;
			_useMpDrupAdd.selected = hangupData.addMpAdd;
			_useMpDrupDes.selected = !hangupData.addMpAdd;
			_hpField.text = String(hangupData.autoAddHpValue);
			_mpField.text = String(hangupData.autoAddMpValue);
			
			_checkList[2].selected = hangupData.autoRepair;
			_checkList[3].selected = hangupData.autoKillTask;
			_checkList[4].selected = hangupData.autoRelive;
			_checkList[5].selected = hangupData.localHangup;
			_checkList[6].selected = hangupData.autoGroup;
			_checkList[7].selected = hangupData.autoPickEquip;
			_checkList[8].enabled = _checkList[9].enabled = _checkList[10].enabled = _checkList[11].enabled = _checkList[7].selected;
			_checkList[8].selected = hangupData.pickEquips[0];
			_checkList[9].selected = hangupData.pickEquips[1];
			_checkList[10].selected = hangupData.pickEquips[2];
			_checkList[11].selected = hangupData.pickEquips[3];
			_checkList[12].selected = hangupData.autoPickOther;
			_checkList[13].enabled = _checkList[14].enabled = _checkList[15].enabled = _checkList[16].enabled = _checkList[12].selected;
			_checkList[13].selected = hangupData.pickOthers[0];
			_checkList[14].selected = hangupData.pickOthers[1];
			_checkList[15].selected = hangupData.pickOthers[2];
			_checkList[16].selected = hangupData.pickOthers[3];
			_checkList[17].selected = hangupData.autoSkill;
			_checkList[18].selected = hangupData.autoAddSkill;
			_checkList[19].selected = hangupData.autoFeedPet;
			
			_acceptGroup.selected = hangupData.isAccept;
			_refuseGroup.selected = !hangupData.isAccept;
			_acceptGroup.enabled = _refuseGroup.enabled = _checkList[16].selected;
			
			for(var i:int = 0; i < hangupData.skillList.length; i++)
			{
				if(hangupData.skillList[i])
				{
					_cells[i].skillInfo = hangupData.skillList[i];
				}
			}
			
			useHpChangeHandler(null);
			useMpChangeHandler(null);
			autoPickEquipChangeHandler(null);
			autoPickOtherChangeHandler(null);
			autoGroupChangeHandler(null);
			
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
		
		private function fightClickHandler(evt:MouseEvent):void
		{
			_mediator.sceneInfo.hangupData.autoAddHp = _checkList[0].selected;
			_mediator.sceneInfo.hangupData.addHpAdd = _useHpDrugAdd.selected;
			_mediator.sceneInfo.hangupData.autoAddMp = _checkList[1].selected;
			_mediator.sceneInfo.hangupData.addMpAdd = _useMpDrupAdd.selected;
			_mediator.sceneInfo.hangupData.autoRepair = _checkList[2].selected;
			_mediator.sceneInfo.hangupData.autoKillTask = _checkList[3].selected;
			_mediator.sceneInfo.hangupData.autoRelive = _checkList[4].selected;
			_mediator.sceneInfo.hangupData.localHangup = _checkList[5].selected;
			_mediator.sceneInfo.hangupData.autoGroup = _checkList[6].selected;
			_mediator.sceneInfo.hangupData.autoPickEquip = _checkList[7].selected;
			_mediator.sceneInfo.hangupData.pickEquips = [_checkList[8].selected,_checkList[9].selected,_checkList[10].selected,_checkList[11].selected];
			_mediator.sceneInfo.hangupData.autoPickOther = _checkList[12].selected;
			_mediator.sceneInfo.hangupData.pickOthers = [_checkList[13].selected,_checkList[14].selected,_checkList[15].selected,_checkList[16].selected,true];
			_mediator.sceneInfo.hangupData.autoSkill = _checkList[17].selected;
			_mediator.sceneInfo.hangupData.autoAddSkill = _checkList[18].selected;
			_mediator.sceneInfo.hangupData.autoFeedPet = _checkList[19].selected;
			
			
			_mediator.sceneInfo.hangupData.isAccept = _acceptGroup.selected;			
			_mediator.sceneInfo.hangupData.autoAddHpValue = int(_hpField.text);
			_mediator.sceneInfo.hangupData.autoAddMpValue = int(_mpField.text);
			_mediator.sceneInfo.hangupData.monsterList.length = 0;
			
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
					_mediator.sceneInfo.hangupData.updateCount();					
					_mediator.sceneInfo.hangupData.stopComplete = false;
				}
				else
				{
					_mediator.sceneInfo.hangupData.monsterNeedCount = -1;
					_mediator.sceneInfo.hangupData.autoFindTask = false;
					_mediator.sceneInfo.hangupData.stopComplete = false;
				}
				_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
//				_mediator.sceneInfo.playerList.self.attackState = 2;
				_mediator.sceneInfo.playerList.self.setHangupState();
				_fightBtn.visible = false;
				_stopBtn.visible = true;
			}
			saveClickHandler(null);
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
//			_mediator.sceneInfo.playerList.self.attackState = 1;
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
			var result:String = "";
			for(var i:int = 0; i < _checkList.length; i++)
			{
				if(_checkList[i].selected)result += "1";
				else result += "0";
			}
			result += ",";
			result += _useHpDrugAdd.selected ? "1" : 0;
			result += _useMpDrupAdd.selected ? "1" : 0;
			result += _acceptGroup.selected ? "1" : 0;
			result += ",";
			result += _hpField.text + "|" + _mpField.text;
			result += ",";
			var skills:String = "";
			for(var j:int = 0; j < _cells.length; j++)
			{
				if(_cells[j].skillInfo)skills += _cells[j].skillInfo.templateId;
				skills += "|";
			}
			result += skills;
			_mediator.sceneInfo.hangupData.setConfig(result);
			PlayerHangupDataSocketHandler.sendConfig(result);
		}
		
		private function autoPickEquipChangeHandler(evt:Event):void
		{
			_checkList[8].enabled = _checkList[9].enabled = _checkList[10].enabled = _checkList[11].enabled = _checkList[7].selected;
		}
		private function autoPickOtherChangeHandler(evt:Event):void
		{
			_checkList[13].enabled = _checkList[14].enabled = _checkList[15].enabled = _checkList[16].enabled = _checkList[12].selected;
		}
		private function autoGroupChangeHandler(evt:Event):void
		{
			_acceptGroup.enabled = _refuseGroup.enabled = _checkList[6].selected;
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
		private function taskClickHandler(evt:MouseEvent):void
		{
			allNoSelectClickHandler(null);
			var list:Dictionary = GlobalData.taskInfo.getTaskMonsters(_mediator.sceneInfo.mapInfo.mapId);
			for each(var data:Array in list)
			{
				if(data && data[1] > 0)
				{
					for(var i:int = 0; i < _monsterList.length; i++)
					{
						if(data[0] == _monsterList[i].monsterId)_monsterChecks[i].selected = true;
					}
				}
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
			super.dispose();
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
			_checkList = null;
			_monsterChecks = null;
			_monsterList = null;
			_acceptGroup = null;
			_refuseGroup = null;
			_hpField = null;
			_mpField = null;
			_mediator = null;
		}
	}
}