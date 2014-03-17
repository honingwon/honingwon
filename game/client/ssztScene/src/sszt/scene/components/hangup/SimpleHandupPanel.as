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
	
	public class SimpleHandupPanel extends MPanel
	{
		private var _mediator:HangupMediator;
		private var _bg:IMovieWrapper;
		private var _fightBtn:MCacheAssetBtn1;
//		private var _defaultBtn:MCacheAssetBtn1;
		private var _stopBtn:MCacheAssetBtn1;
//		private var _saveBtn:MCacheAssetBtn1;
//		private var _simpleSetBtn:MCacheAssetBtn1;
		
		private var _advancedSetBtn:MCacheAssetBtn1;
		private var _autoAddSkillBtn:MCacheAssetBtn1;
		
//		private var _allSelectBtn:MCacheAssetBtn1;
//		private var _allNoSelectBtn:MCacheAssetBtn1;
//		private var _taskSelectBtn:MCacheAssetBtn1;
		
		private var _checkList:Array;
//		private var _monsterChecks:Array;
//		private var _monsterList:Array;
		
//		private var _acceptGroup:RadioButton;
//		private var _refuseGroup:RadioButton;
//		private var _useHpDrugAdd:RadioButton;
//		private var _useHpDrupDes:RadioButton;
//		private var _useMpDrupAdd:RadioButton;
//		private var _useMpDrupDes:RadioButton;
		
//		private var _hpField:TextField;
//		private var _mpField:TextField;
		
		private var _titleLabel:MAssetLabel;
//		private var _descriptLabel:MAssetLabel;
		
		private var _skillTile:MTile;
		private var _cells:Array;
		
		public function SimpleHandupPanel(mediator:HangupMediator)
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
			
			setContentSize(276,272);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,4,260,260)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,8,252,133)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,143,252,81)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,223,252,25),new Bitmap(new SplitCompartLine2()))
			]);
			addContent(_bg as DisplayObject);
			
			_titleLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.handUpCheck14"),MAssetLabel.LABEL_TYPE8);
			_titleLabel.move(25,156);
			addContent(_titleLabel);
					
			
			_fightBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.openHungUp"));
			_fightBtn.move(99,231);
			addContent(_fightBtn);
			_stopBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.stopHungUp"));
			_stopBtn.move(99,231);
			addContent(_stopBtn);
						
			_advancedSetBtn = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.scene.advancedSet"));
			_advancedSetBtn.move(191,17);
			addContent(_advancedSetBtn);
			
			_autoAddSkillBtn = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.scene.autoAdd"));
			_autoAddSkillBtn.move(191,150);
			addContent(_autoAddSkillBtn);
			
			_checkList = [];
			var labels:Array = [LanguageManager.getWord("ssztl.scene.hangUpCheck17"),
				LanguageManager.getWord("ssztl.scene.hangUpCheck18"),
				LanguageManager.getWord("ssztl.scene.handUpCheck7"),
				LanguageManager.getWord("ssztl.scene.handUpCheck21"),
				LanguageManager.getWord("ssztl.scene.handUpCheck22")
			];
			
			var poses:Array = [new Point(22,17),new Point(22,41),new Point(22,65),new Point(22,89),new Point(22,113)];
			var i:int = 0;
			for(i = 0; i < labels.length; i++)
			{
				var check:CheckBox = new CheckBox();
				check.label = labels[i];
				check.move(poses[i].x,poses[i].y);
				addContent(check);
				check.setSize(230,22);
				_checkList.push(check);
			}
			
			for(var n:int = 0; n < 6; n++)
			{
				var cellbg:Bitmap = new Bitmap(CellCaches.getCellBg());
				cellbg.x = n * 39 + 22;
				cellbg.y = 178;
				addContent(cellbg);
			}			
			_cells = [];
			_skillTile = new MTile(37,37,5);
			_skillTile.itemGapW = 2;
			_skillTile.itemGapH = 7;
			_skillTile.setSize(240,40);
			_skillTile.verticalScrollPolicy = _skillTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_skillTile.move(22,178);
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
			_fightBtn.addEventListener(MouseEvent.CLICK,fightClickHandler);
			_stopBtn.addEventListener(MouseEvent.CLICK,stopClickHandler);
			_advancedSetBtn.addEventListener(MouseEvent.CLICK,advancedClickHandler);
			_autoAddSkillBtn.addEventListener(MouseEvent.CLICK,autoAddSkillClickHandler);
			_mediator.sceneInfo.hangupData.addEventListener(HanpupDataUpdateEvent.ADD_SKILL,dataAddSkillHandler);
			_mediator.sceneInfo.hangupData.addEventListener(HanpupDataUpdateEvent.REMOVE_SKILL,dataRemoveSkillHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function removeEvent():void
		{
			_fightBtn.removeEventListener(MouseEvent.CLICK,fightClickHandler);
			_stopBtn.removeEventListener(MouseEvent.CLICK,stopClickHandler);
			_advancedSetBtn.removeEventListener(MouseEvent.CLICK,advancedClickHandler);
			_autoAddSkillBtn.removeEventListener(MouseEvent.CLICK,autoAddSkillClickHandler);
			_mediator.sceneInfo.hangupData.removeEventListener(HanpupDataUpdateEvent.ADD_SKILL,dataAddSkillHandler);
			_mediator.sceneInfo.hangupData.removeEventListener(HanpupDataUpdateEvent.REMOVE_SKILL,dataRemoveSkillHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		private function initData():void
		{
			var hangupData:HangupData = _mediator.sceneInfo.hangupData;
			_checkList[0].selected = hangupData.autoFight;
			if(hangupData.autoPickEquip || hangupData.autoPickOther)			
				_checkList[1].selected = true;
			else
				_checkList[1].selected = false;
			
			_checkList[2].selected = hangupData.isAccept;
			
			_checkList[3].selected = hangupData.autoAddHp;
			_checkList[4].selected = hangupData.autoAddMp;
			
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
						
		}
		
		private function fightClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(!MapTemplateList.getCanHangup())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotHandUp"));
				return;
			}
			
			_mediator.sceneInfo.hangupData.autoFight = _checkList[0].selected;
			if(_checkList[1].selected)
			{
				if(_mediator.sceneInfo.hangupData.autoPickEquip == _mediator.sceneInfo.hangupData.autoPickOther)
				{
					_mediator.sceneInfo.hangupData.autoPickEquip = true;
					_mediator.sceneInfo.hangupData.autoPickOther = true;
				}
			}
			else
			{
				_mediator.sceneInfo.hangupData.autoPickEquip = false;
				_mediator.sceneInfo.hangupData.autoPickOther = false;
			}
			_mediator.sceneInfo.hangupData.isAccept = _checkList[2].selected;
			
			_mediator.sceneInfo.hangupData.autoAddHp = _checkList[3].selected;
			
			_mediator.sceneInfo.hangupData.autoAddMp = _checkList[4].selected;
			
//			_mediator.sceneInfo.hangupData.monsterList.length = 0;
			if(_mediator.sceneInfo.hangupData.monsterList.length == 0)
			{
				var monsterList:Array = [];
				monsterList = _mediator.sceneInfo.mapInfo.getSceneMonsterIds();
				for each(var monster:MonsterTemplateInfo in monsterList)
				{
					_mediator.sceneInfo.hangupData.monsterList.push(monster.monsterId);
				
				}
			}			
			_mediator.sceneInfo.hangupData.attackPath = MapTemplateList.getMapTemplate(_mediator.sceneInfo.mapInfo.mapId).attackPath.slice();
			if(_mediator.sceneInfo.hangupData.attackIndex == _mediator.sceneInfo.hangupData.attackPath.length)_mediator.sceneInfo.hangupData.attackIndex = 0;
			
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
				
				for(var n:int = 0; n < 10; n++)
				{
					_mediator.sceneInfo.hangupData.skillList[n] = _cells[n].skillInfo;
				}
				PlayerHangupDataSocketHandler.sendConfig(_mediator.sceneInfo.hangupData.getConfigStr());
			dispose();
		}
				
		
		private function stopClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.sceneInfo.playerList.self.setKillOne();
			_fightBtn.visible = true;
			_stopBtn.visible = false;
		}
		
		private function advancedClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWHANGUP);
			dispose();
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
			if(_stopBtn)
			{
				_stopBtn.dispose();
				_stopBtn = null;
			}
			if(_advancedSetBtn)
			{
				_advancedSetBtn.dispose();
				_advancedSetBtn = null;
			}
			if(_autoAddSkillBtn)
			{
				_autoAddSkillBtn.dispose();
				_autoAddSkillBtn = null;
			}
			_checkList = null;
//			_monsterChecks = null;
//			_monsterList = null;
//			_acceptGroup = null;
//			_refuseGroup = null;
//			_useHpDrugAdd = null;
//			_useHpDrupDes = null;
//			_useMpDrupAdd = null;
//			_useMpDrupDes = null;
//			_hpField = null;
//			_mpField = null;
			_mediator = null;
			_titleLabel = null;
//			_descriptLabel = null;
			if(_skillTile)
			{
				_skillTile.dispose();
				_skillTile = null;
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