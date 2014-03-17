package sszt.skill.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.data.skill.SkillListUpdateEvent;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.skill.mediators.SkillMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	
	public class CareerSkillPanel extends BaseTabPanel implements ISkillTabPanel
	{
		private static const CAREER_POS:Array = [
			new Point(70,29),new Point(70,79),new Point(70,129),new Point(22,179),new Point(118,179),new Point(70,229),new Point(70,279)
		];
		private static const PASSIVE_POS:Array = [
			new Point(177,79),new Point(177,129),new Point(177,179),new Point(225,179),new Point(225,229),new Point(177,279)
		]; 
		
		private var _leftItems:Array;
		private var _rightItems:Array;
		private var _totalItems:Array;
		private var _canUpgradeLeftItems:Array;
		private var _canUpgradeRightItems:Array;
		private var _currentSkillinfo:Array;
		private var _upgradeAllFlag:Boolean;
		
		private var _skillTemplateInfo:SkillTemplateInfo;
		private var _skillItemInfo:SkillItemInfo;
		
		private var _bg:Bitmap;
		private var _skillTree:Bitmap;
		private var _bg2:IMovieWrapper;
		
		private var _sp:Sprite;//包含技能详情以及升级、一键升级按钮
		private var _sp1:Sprite;//包含技能格子
		
		private var _studyBtn:MCacheAssetBtn1;  //学习按钮
		private var _upgradeBtn:MCacheAssetBtn1; //升级按钮
		private var _upgradeAllBtn:MCacheAssetBtn1; //一键升级按钮
		
		private var _showCopper:MAssetLabel;		//铜币数量
		private var _showLifeExp:MAssetLabel;		//历练
		
		private var _skillName:MAssetLabel,_skillLevel:MAssetLabel,_skillType:MAssetLabel,_skillEffect:MAssetLabel,_upgradeEffect:MAssetLabel;
		private var _needLevel:MAssetLabel,_needSkillLevel:MAssetLabel,_needCopper:MAssetLabel,_needLifeExp:MAssetLabel;
		
		private var _currentCell:SkillCell;
		private var _currentCellUpgradeAll:SkillCell;
		
		/*
		private static const CAREER_POS:Array = [
			[new Point(81,27),new Point(33,77),new Point(129,77),new Point(81,127),new Point(33,177),new Point(129,177),new Point(33,227),new Point(129,227),new Point(81,277)], 
			[new Point(81,27),new Point(33,77),new Point(129,77),new Point(33,127),new Point(129,127),new Point(81,177),new Point(33,227),new Point(129,227),new Point(81,277)],
			[new Point(81,27),new Point(33,77),new Point(129,77),new Point(129,177),new Point(81,177),new Point(33,227),new Point(129,227),new Point(81,227),new Point(81,277)] ];
		*/
		
		public function CareerSkillPanel(mediator:SkillMediator)
		{
			super(mediator);
			initView();
		}
		
		private function initView():void
		{
			_bg = new Bitmap;
			_bg.x = _bg.y = 4;
			addChild(_bg);
			
			_skillTree = new Bitmap();
			_skillTree.x = 17;
			_skillTree.y = 24;
			addChild(_skillTree);
			
			_sp = new Sprite;
			addChild(_sp);
			_sp.x = 280;
			_sp.y = 0;			
			
			_sp1 = new Sprite;
			addChild(_sp1);
			
			_showCopper = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_showCopper.move(18,350);
			addChild(_showCopper);
			
			_showLifeExp = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_showLifeExp.move(133,350);
			addChild(_showLifeExp);
			
			_showCopper.setHtmlValue("<font color='#d8992b'>"+LanguageManager.getWord("ssztl.common.copperLabel") +"</font>"+ (GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper).toString());
			_showLifeExp.setHtmlValue("<font color='#d8992b'>"+LanguageManager.getWord("ssztl.common.expPoint") +"</font>"+ GlobalData.selfPlayer.lifeExperiences.toString() + "/" + GlobalData.selfPlayer.totalLifeExperiences.toString());
			
			
			_bg2 =  BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(0,3,156,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,144,156,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,30,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.level")+ "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,48,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillType") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,70,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.effectlabel")+ "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
					
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,153,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.role.nextLevel"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)),
					
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,182,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.effectlabel") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,251,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.upgradeNeed"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,269,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needLevel") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,287,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needSkillLevel") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,305,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needCopper")+ "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,323,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needLiftExp")+ "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT))
					
			]);
			_sp.addChild(_bg2 as DisplayObject);		
			
			_skillName = new MAssetLabel("",[new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),13,0xff9900,true)]);
			_skillName.move(78,8);
			_sp.addChild(_skillName);
			
			_skillLevel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_skillLevel.move(44,30);
			_sp.addChild(_skillLevel);
			
			_skillType = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_skillType.move(68,48);
			_sp.addChild(_skillType);
			
			_skillEffect = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_skillEffect.wordWrap = true;
			_skillEffect.move(8,66);
			_skillEffect.setSize(145,80);
			_sp.addChild(_skillEffect);
			
			_upgradeEffect = new MAssetLabel("", MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_upgradeEffect.wordWrap = true;
			_upgradeEffect.move(8,171);
			_upgradeEffect.setSize(145,80);
			_sp.addChild(_upgradeEffect);
			
			
			_needLevel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_needLevel.move(68,269);
			_sp.addChild(_needLevel);
			
			_needSkillLevel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_needSkillLevel.move(68,287);
			_sp.addChild(_needSkillLevel);
			
			_needCopper = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_needCopper.move(68,305);
			_sp.addChild(_needCopper);
			
			_needLifeExp = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_needLifeExp.move(68,323);
			_sp.addChild(_needLifeExp);
			
			//学习按钮
			_studyBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.learn"));
			_studyBtn.move(8,346);
			_sp.addChild(_studyBtn);
			_studyBtn.visible = false;
			
			//升级按钮
			_upgradeBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.upgrade"));
			_upgradeBtn.move(8,346);
			_sp.addChild(_upgradeBtn);
			_upgradeBtn.visible = false;
			
			_upgradeAllBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.skill.autoUpgrade"));
			_upgradeAllBtn.move(79,346);
			_sp.addChild(_upgradeAllBtn);
			_upgradeAllBtn.enabled = false;
			
			_leftItems = [];
			_rightItems = [];
			_totalItems = [];
			
			initTemplateData();
			initPlayerData();
			
			getCanUpgradeSkillList();
			
			if(_canUpgradeLeftItems.length > 0 || _canUpgradeRightItems.length > 0)
			{
				_upgradeAllBtn.enabled = true;
			}
			
			if(_canUpgradeLeftItems.length > 0)
			{
				setCurrentCell(_canUpgradeLeftItems[0]);
			}
			else if(_canUpgradeRightItems.length > 0)
			{
				setCurrentCell(_canUpgradeRightItems[0]);
			}
			else
			{
				setCurrentCell(_leftItems[0]);
			}
			
			initEvents();
		}
		
		override public function assetsCompleteHandler():void
		{
			if(GlobalData.selfPlayer.career == CareerType.SANWU)
			{
				_bg.bitmapData = AssetUtil.getAsset("ssztui.skill.CareerBgAsset1",BitmapData) as BitmapData;
			}
			else if(GlobalData.selfPlayer.career == CareerType.XIAOYAO)
			{
				_bg.bitmapData = AssetUtil.getAsset("ssztui.skill.CareerBgAsset3",BitmapData) as BitmapData;
			}
			else if(GlobalData.selfPlayer.career == CareerType.LIUXING)
			{
				_bg.bitmapData = AssetUtil.getAsset("ssztui.skill.CareerBgAsset2",BitmapData) as BitmapData;
			}
			_skillTree.bitmapData = AssetUtil.getAsset("ssztui.skill.CareerSkillBgAsset",BitmapData) as BitmapData;
		}
		
		private function initEvents():void
		{
			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.UPDATE_SKILL,addSkillHandler);
			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.REMOVE_SKILL,removeSkillHandler);
			
			_studyBtn.addEventListener(MouseEvent.CLICK,studyClickHandler);
			_upgradeBtn.addEventListener(MouseEvent.CLICK,upgradeBtnHandler);
			_upgradeAllBtn.addEventListener(MouseEvent.CLICK,upgradeAllBtnHandler);
			
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.LIFEEXP_UPDATE,moneyUpdataHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,lvUpHandler);
		}
		
		private function removeEvents():void
		{
			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.UPDATE_SKILL,addSkillHandler);
			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.REMOVE_SKILL,removeSkillHandler);
			
			_studyBtn.removeEventListener(MouseEvent.CLICK,studyClickHandler);
			_upgradeBtn.removeEventListener(MouseEvent.CLICK,upgradeBtnHandler);
			_upgradeAllBtn.removeEventListener(MouseEvent.CLICK,upgradeAllBtnHandler);
			
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.LIFEEXP_UPDATE,moneyUpdataHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,lvUpHandler);
		}
		private function moneyUpdataHandler(e:SelfPlayerInfoUpdateEvent):void	
		{
			_showCopper.setHtmlValue("<font color='#d8992b'>"+LanguageManager.getWord("ssztl.common.copperLabel") +"</font>"+ (GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper).toString());
			_showLifeExp.setHtmlValue("<font color='#d8992b'>"+LanguageManager.getWord("ssztl.common.expPoint") +"</font>"+ GlobalData.selfPlayer.lifeExperiences.toString() + "/" + GlobalData.selfPlayer.totalLifeExperiences.toString());
			getCanUpgradeSkillList();
			updateUpgradeAsset();
			setDetails(_currentSkillinfo[0],_currentSkillinfo[1]);
		}
		private function lvUpHandler(e:CommonModuleEvent):void
		{
			getCanUpgradeSkillList();
			updateUpgradeAsset();
			setDetails(_currentSkillinfo[0],_currentSkillinfo[1]);
		}
		
		//一键升级
		private function upgradeAllBtnHandler(e:MouseEvent):void
		{
			_upgradeAllFlag = true;
			var cell:SkillCell;
			var templateId:int;
			if(_canUpgradeLeftItems.length > 0)
			{
				cell  = SkillCell(_canUpgradeLeftItems[0]);
			}
			else if(_canUpgradeRightItems.length > 0)
			{
				cell = SkillCell(_canUpgradeRightItems[0]);
			}
			else
			{
				return;
			}
			_currentCellUpgradeAll = cell;
			if(cell.skillInfo)
			{
				_skillTemplateInfo = null;
				if(_skillItemInfo)
				{
					_skillItemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
				}
				_skillItemInfo = cell.skillInfo;
				_skillItemInfo.addEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
				templateId = _skillItemInfo.getTemplate().templateId;
			}
			else
			{
				_skillTemplateInfo = cell.info as SkillTemplateInfo;
				templateId = _skillTemplateInfo.templateId;
			}
			templateId = cell.skillInfo ? cell.skillInfo.getTemplate().templateId : (cell.info as SkillTemplateInfo).templateId
			_mediator.studyOrUpgrade(templateId);
		}
		
		private function addSkillHandler(evt:SkillListUpdateEvent):void
		{
			var skill:SkillItemInfo = evt.data as SkillItemInfo;
			
			if(skill.getTemplate().activeType == 0 || skill.getTemplate().activeType == 2)
			{
				_leftItems[skill.getTemplate().place].skillInfo = skill;
			}
			else
			{
				_rightItems[skill.getTemplate().place-7].skillInfo = skill;
			}
			
			if(_skillTemplateInfo.templateId == skill.templateId)
			{
				setSkillItemInfo(skill);
				
				getCanUpgradeSkillList();
				setCurrentCell(_currentCell);
			}
			
			if(_upgradeAllFlag)
			{
				getCanUpgradeSkillList();
				if(_canUpgradeLeftItems.length > 0 || _canUpgradeRightItems.length > 0)
				{
					upgradeAllBtnHandler(null);
				}
				else
				{
					_upgradeAllBtn.enabled = false;
					_upgradeAllFlag = false;
				}
			}
			updateUpgradeAsset();
		}
		
		private function removeSkillHandler(evt:SkillListUpdateEvent):void
		{
			var skillId:int = int(evt.data);
			for each(var i:SkillCell in _leftItems)
			{
				if(i.info.templateId == skillId)
				{
					i.skillInfo = null;
					break;
				}
			}
		}
		
		//初始化技能模版
		private function initTemplateData():void
		{
			var skillTemplates:Array = SkillTemplateList.getSelfActiveSkills();
			var i:int = 0;
			var cell:SkillCell;
			
			for(i = 0; i < 7; ++i)
			{
				cell = createCell(skillTemplates[i]);
				_leftItems.push(cell);
				_totalItems.push(cell);
				//cell.move(CAREER_POS[GlobalData.selfPlayer.career-1][i].x,CAREER_POS[GlobalData.selfPlayer.career-1][i].y);
				cell.move(CAREER_POS[i].x,CAREER_POS[i].y);
				_sp1.addChild(cell);
				
			}
			var skillTemplates1:Array = SkillTemplateList.getSelfPassiveSkills();
			for(i = 0; i < 6; ++i)
			{
				cell = createCell(skillTemplates1[i+7]);
				_rightItems.push(cell);
				_totalItems.push(cell);
				cell.move(PASSIVE_POS[i].x,PASSIVE_POS[i].y);
				_sp1.addChild(cell);
			}
		}
		
		//初始化任务已学技能
		private function initPlayerData():void
		{
			var list:Array = GlobalData.skillInfo.getSkillByPlace([0,1,2,3,4,5,6,7,8,9,10,11,12]);
			for each(var i:SkillItemInfo in list)
			{
				if(i.getTemplate().place >= 7)
				{
					_rightItems[i.getTemplate().place - 7].skillInfo = i;
				}
				else
				{
					_leftItems[i.getTemplate().place].skillInfo = i;
				}
			}
		}
		
		private function getCanUpgradeSkillList():void
		{
			var i:int;
			_canUpgradeLeftItems = []; 
			_canUpgradeRightItems = [];
			for(i = 0; i < _leftItems.length; i++)
			{
				if(SkillCell(_leftItems[i]).checkUpgrade())
				{
					_canUpgradeLeftItems.push(_leftItems[i]);
				}
			}
			
			for(i = 0; i < _rightItems.length; i++)
			{
				if(SkillCell(_rightItems[i]).checkUpgrade())
				{
					_canUpgradeRightItems.push(_rightItems[i]);
				}
			}
		}
		
		protected function cellClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			super.cellClickHandler(evt);
			if(_currentCell)
			{
				_currentCell.selected = false;
			}
			setCurrentCell(evt.currentTarget as SkillCell);		
		}
		
		protected function upgradeClickHandler(evt:Event):void
		{
			if(_skillItemInfo)
			{
				_mediator.studyOrUpgrade(_skillItemInfo.getTemplate().templateId);
			}
			else if(_skillTemplateInfo)
			{
				_mediator.studyOrUpgrade(_skillTemplateInfo.templateId);
			}
		}
		
		private function setCurrentCell(curCell:SkillCell):void
		{
			if(_currentCell)
			{
				_currentCell.selected = false;
			}
			
			var cell:SkillCell = curCell;
			if(cell == null || cell.info == null)
				return;
			if(cell.skillInfo)
			{
				setSkillItemInfo(cell.skillInfo);
			}
			else
			{
				skillTemplateInfo = cell.info as SkillTemplateInfo;
			}

			if(_currentCell)_currentCell.selected = false;
			_currentCell = cell;
			_currentCell.selected = true;
		}
		
		//设置技能模板，选中未学习技能时被调用
		public function set skillTemplateInfo(skillTemplateInfo:SkillTemplateInfo):void
		{
			_skillTemplateInfo = skillTemplateInfo;
			if(_skillItemInfo)
			{
				_skillItemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
				_skillItemInfo = null;
			}
			setDetails(_skillTemplateInfo);
			
			_studyBtn.visible = true;
			_upgradeBtn.visible = false;
		}
		
		
		//点击学习技能
		private function studyClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_skillTemplateInfo)
				_mediator.studyOrUpgrade(_skillTemplateInfo.templateId);
		}
		
		//点击升级技能
		private function upgradeBtnHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_skillItemInfo)
				_mediator.studyOrUpgrade(_skillItemInfo.getTemplate().templateId);
		}
		
		//设置技能，选中已学习技能时被调用
		public function setSkillItemInfo(skillItemInfo:SkillItemInfo):void
		{
			_skillTemplateInfo = null;
			if(_skillItemInfo)
			{
				_skillItemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
			}
			_skillItemInfo = skillItemInfo;
			_skillItemInfo.addEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
			setDetails(_skillItemInfo.getTemplate(), _skillItemInfo.level);
			_studyBtn.visible = false;
			_upgradeBtn.visible = true;
		}
		
		//技能升级后触发
		private function upgradeHandler(evt:SkillItemInfoUpdateEvent):void
		{
			if(_skillItemInfo == null)
				return;
			var itemInfo:SkillItemInfo = evt.target as SkillItemInfo;
			
			
			if(itemInfo.getTemplate().activeType == 0 || itemInfo.getTemplate().activeType == 2)
			{
				_leftItems[itemInfo.getTemplate().place].skillInfo = itemInfo;
			}
			else
			{
				_rightItems[itemInfo.getTemplate().place-7].skillInfo = itemInfo;
			}
			
			if(_skillItemInfo.templateId == itemInfo.templateId)
			{
				setSkillItemInfo(itemInfo);
				
				getCanUpgradeSkillList();
				setCurrentCell(_currentCell);
			}
			
			if(_upgradeAllFlag)
			{
				getCanUpgradeSkillList();
				if(_canUpgradeLeftItems.length > 0 || _canUpgradeRightItems.length > 0)
				{
					upgradeAllBtnHandler(null);
				}
				else
				{
					_upgradeAllBtn.enabled = false;
					_upgradeAllFlag = false;
				}
			}
			updateUpgradeAsset();
		}
		
		//更新每个技能格子的加号按钮
		private function updateUpgradeAsset():void
		{
			var skillCell:SkillCell;
			for each(skillCell in _canUpgradeLeftItems)
			{
				skillCell.canUpgrade = skillCell.checkUpgrade();
			}
			for each(skillCell in _canUpgradeRightItems)
			{
				skillCell.canUpgrade = skillCell.checkUpgrade();
			}
		}
		
		//根据当前选中技能，显示该技能的详细信息
		private function setDetails(value:SkillTemplateInfo, level:int=0):void
		{
			_studyBtn.enabled = true;
			_upgradeBtn.enabled = true;
			_upgradeAllBtn.enabled = true;
			var useble:Boolean = true;
			_currentSkillinfo = new Array();
			_currentSkillinfo.push(value);
			_currentSkillinfo.push(level);
			_skillName.setValue(value.name);
			_skillLevel.setValue(level + "/" + value.totalLevel.toString());
			if(level > 0)
			{
				_skillEffect.setValue(value.getEffectToString(level,true));
			}
			else
			{
//				_skillEffect.setValue(value.getEffectToString(1,true));
				_skillEffect.setValue(LanguageManager.getWord('ssztl.common.none'));
			}
			
			if(value.activeType == 0)
			{
				if(value.isSingleAttack)
				{
					_skillType.setValue(LanguageManager.getWord("ssztl.skill.singleAttack"));
				}
				else
				{
					_skillType.setValue(LanguageManager.getWord("ssztl.skill.allAttack"));
				}
			}
			else
			{
				_skillType.setValue(getActiveTypeName(value.activeType));
			}
			
			if(level >= value.totalLevel)
			{
				_upgradeEffect.setValue(LanguageManager.getWord("ssztl.store.skillAchieveMaxValue"));
				_upgradeEffect.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_upgradeEffect.length);
				if(_upgradeBtn)
				{
					_upgradeBtn.visible = false;
				}
				_needSkillLevel.setValue("-");
				_needLevel.setValue("-");
				_needCopper.setValue("-");
				_needLifeExp.setValue("-");
			}
			else
			{
				if(value.needSkillId[level] == 0)
				{
					_needSkillLevel.setValue(LanguageManager.getWord("ssztl.common.none"));
				}
				else
				{
					_needSkillLevel.setValue(LanguageManager.getWord("ssztl.skill.needSkillId", SkillTemplateList.getSkill(value.needSkillId[level]).name,value.needSkillLevel[level]));
				}	
				_upgradeEffect.setValue(value.getEffectToString(level+1,true));
				_needLevel.setValue(value.needLevel[level]);
				_needCopper.setValue(value.needCopper[level]);
				_needLifeExp.setValue(value.needLifeExp[level]);
			}
			
			
			
			if(value.needCopper[level]==0 && value.needLifeExp[level]==0)
			{
				_needCopper.setValue("");
				_needLifeExp.setValue("");
			}
			else
			{
				if(GlobalData.selfPlayer.lifeExperiences >= value.needLifeExp[level])
				{
					_needLifeExp.setLabelType(MAssetLabel.LABEL_TYPE20);
				}
				else
				{
					_needLifeExp.setLabelType(MAssetLabel.LABEL_TYPE6);
					useble = false;
				}
				if((GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper)>=value.needCopper[level])
				{
					_needCopper.setLabelType(MAssetLabel.LABEL_TYPE20);
				}
				else
				{
					_needCopper.setLabelType(MAssetLabel.LABEL_TYPE6);
					useble = false;
				}
			}
			if(GlobalData.selfPlayer.level>=value.needLevel[level])
			{
				_needLevel.setLabelType(MAssetLabel.LABEL_TYPE20);
			}
			else
			{
				_needLevel.setLabelType(MAssetLabel.LABEL_TYPE6);
				useble = false;
			}
			
			if(value.needSkillId[level] == 0 ||  GlobalData.skillInfo.getSkillByLevel(value.needSkillId[level],value.needSkillLevel[level]) != null)
			{
				_needSkillLevel.setLabelType(MAssetLabel.LABEL_TYPE20);
			}
			else
			{
				_needSkillLevel.setLabelType(MAssetLabel.LABEL_TYPE6);
				useble = false;
			}
			
			if(!useble)
			{
				if(_upgradeBtn)
					_upgradeBtn.enabled = false;
				if(_studyBtn)
					_studyBtn.enabled = false;
				if(_upgradeAllBtn)
					_upgradeAllBtn.enabled = false;
			}
		}
		
		
		public override function show():void
		{
			initEvents();
			setCurrentCell(_currentCell);
		}
		
		public override function hide():void
		{
			removeEvents();
			super.hide();
		}
		
		protected function createCell(info:SkillTemplateInfo):SkillCell
		{
			var cell:SkillCell = new SkillCell();
			cell.info = info;
			if(cell.info)
			{
				cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				cell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				cell.addEventListener(SkillCell.UPGRADE_CLICK,upgradeClickHandler);
				cell.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				cell.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			}
			return cell;
		}
		private function itemOverHandler(evt:MouseEvent):void
		{
			var _cur:SkillCell = evt.currentTarget as SkillCell;
			_cur.over = true;
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			var _cur:SkillCell = evt.currentTarget as SkillCell;
			_cur.over = false;
		}
		
		protected function cellDownHandler(evt:MouseEvent):void
		{
			var cell:SkillCell = evt.currentTarget as SkillCell;
			if(cell.skillInfo == null)return;
			GlobalAPI.dragManager.startDrag(cell);
		}
		
		private function getActiveTypeName(activeType:int):String
		{
			switch(activeType)
			{
				//				case 0:return "[主动技能]";
				//				case 1:return "[被动技能]";
				//				case 2:return "[辅助技能]";
				case 0:return LanguageManager.getWord("ssztl.common.activeSkill");
				case 1:return LanguageManager.getWord("ssztl.common.passiveSkill");
				case 2:return LanguageManager.getWord("ssztl.common.assistSkill");
			}
			return "";
		}
		
		public override function dispose():void
		{
			removeEvents();
			_sp = null;
			_sp1 = null;
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
//			if(_topTile)
//			{
//				_topTile.dispose();
//				_topTile = null;
//			}
//			if(_footTile)
//			{
//				_footTile.dispose();
//				_footTile = null;
//			}
			
			if(_totalItems)
			{
				for each(var cell:SkillCell in _totalItems)
				{
					cell.removeEventListener(MouseEvent.CLICK,cellClickHandler);
					cell.removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
					cell.removeEventListener(SkillCell.UPGRADE_CLICK,upgradeClickHandler);
					cell.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
					cell.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
					cell.dispose();
					cell = null;
				}
				_totalItems = null;
			}
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			_skillName = null;
			_skillLevel = null;
			_skillType = null;
			_skillEffect = null;
			_upgradeEffect = null;
			_needLevel = null;
			_needSkillLevel = null;
			_needCopper = null; 
			_needLifeExp = null;
			_leftItems = null;
			_rightItems = null;
			_currentCell = null;
			_currentSkillinfo = null;
			if(_studyBtn)
			{
				_studyBtn.dispose();
				_studyBtn = null;
			}
			if(_upgradeBtn)
			{
				_upgradeBtn.dispose();
				_upgradeBtn = null;
			}
			
			if(_skillItemInfo)
			{
				_skillItemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
				_skillItemInfo = null;
			}
			
			
			super.dispose();
		}
	}
}

















