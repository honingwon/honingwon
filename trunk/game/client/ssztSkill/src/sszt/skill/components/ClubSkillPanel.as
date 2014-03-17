package sszt.skill.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
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
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.skill.events.CellEvent;
	import sszt.skill.mediators.SkillMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheCompartLine;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	public class ClubSkillPanel extends BaseTabPanel implements ISkillTabPanel
	{
		private static const SKILL_COUNT:int = 9;
		private static const PAGE_SIZE:int = 5;
		private static const FIRST_SKILL_PLACE:int = 20;//9个技能，place为20,21,...,27,28
		private static const TOTAL_TIME:int = 10;
		
		private var _totalItems:Array;
		private var _currentPage:int;
		
		private var _skillItemInfo:SkillItemInfo;
		private var _skillTemplateInfo:SkillTemplateInfo;
		
		private var _sp:Sprite;
		
		private var _bg:Bitmap;
		private var _bg2:IMovieWrapper;
		
		private var _tile:MTile;
		private var _pageView:PageView;
//		private var _studyBtn:MCacheAssetBtn1;  //学习按钮
//		private var _upgradeBtn:MCacheAssetBtn1; //升级按钮
		
		private var _showCopper:MAssetLabel;		//铜币数量
		
		private var _currentCell:GuildSkillCell;
		
		private var _todayUpTimes:MAssetLabel,_selfExploit:MAssetLabel;
		private var _skillName:MAssetLabel,_skillLevel:MAssetLabel,_skillType:MAssetLabel,_skillEffect:MAssetLabel,_upgradeEffect:MAssetLabel;
		private var _needYanwutangLevel:MAssetLabel,_needCopper:MAssetLabel,_needExploit:MAssetLabel;
		
		public function ClubSkillPanel(mediator:SkillMediator)
		{
			super(mediator);
			initView();
		}
		
		private function initView():void
		{
			_bg = new Bitmap();
			_bg.x = _bg.y = 4;
			this.addChild(_bg);
			
			_sp = new Sprite;
			addChild(_sp);
			_sp.x = 280;
			_sp.y = 0;	
			
			_bg2 =  BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(0,3,156,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,144,156,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,30,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.level")+ "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,48,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillType") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,153,30,16),new MAssetLabel(LanguageManager.getWord("ssztl.role.nextLevel"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,251,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.upgradeNeed"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,269,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needYanwutangLevel") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,287,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needCopper")+ "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,305,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needClubExploit")+ "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT))
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
			_skillEffect.move(8,66);
			_sp.addChild(_skillEffect);
			
			_upgradeEffect = new MAssetLabel("", MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_upgradeEffect.move(8,171);
			_sp.addChild(_upgradeEffect);
			
			_needYanwutangLevel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_needYanwutangLevel.move(80,269);
			_sp.addChild(_needYanwutangLevel);
			
			_needCopper = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_needCopper.move(68,287);
			_sp.addChild(_needCopper);
			
			_needExploit = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_needExploit.move(68,305);
			_sp.addChild(_needExploit);
			
			//学习按钮
//			_studyBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.learn"));
//			_studyBtn.move(47,364);
//			_sp.addChild(_studyBtn);
//			_studyBtn.visible = false;
			
			//升级按钮
//			_upgradeBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.upgrade"));
//			_upgradeBtn.move(47,364);
//			_sp.addChild(_upgradeBtn);
//			_upgradeBtn.visible = false;

//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(15,313,72,18),new MAssetLabel(LanguageManager.getWord("ssztl.skill.todayUpgradeTimes") + "：",MAssetLabel.LABEL_TYPE_TAG,"left")));
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(137,313,49,18),new MAssetLabel(LanguageManager.getWord("ssztl.task.personalExploit") + "：",MAssetLabel.LABEL_TYPE_TAG,"left")));
			
			
			_tile = new MTile(352,53,1);
			_tile.itemGapH = 3;
			_tile.move(14,32);
			_tile.setSize(352,281);
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_pageView = new PageView(PAGE_SIZE);
			_pageView.move(73,314);
			_pageView.totalRecord = SKILL_COUNT;
			addChild(_pageView);
			
			_totalItems = [];
			
			initData();
			
			initEvents();
			
			setCurrentCell(_totalItems[0]);
			
			_todayUpTimes = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_todayUpTimes.move(139,11);
			addChild(_todayUpTimes);
			_todayUpTimes.setHtmlValue(
				LanguageManager.getWord("ssztl.skill.todayUpgradeTimes") + "：" + 
				"<font color='#00ff00'><b>"+(TOTAL_TIME - GlobalData.guildSkillUpTimes).toString()+"</b></font>"
			);
			
			_showCopper = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_showCopper.move(18,350);
			addChild(_showCopper);
			_showCopper.setHtmlValue(
				"<font color='#d8992b'>"+LanguageManager.getWord("ssztl.common.copperLabel") +"</font>"+ 
				(GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper).toString()
			);
			
			_selfExploit = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_selfExploit.move(133,350);
			addChild(_selfExploit);			
			_selfExploit.setHtmlValue(
				"<font color='#d8992b'>"+LanguageManager.getWord("ssztl.task.personalExploit") +"：</font>" +
				GlobalData.selfPlayer.selfExploit // + "/" + GlobalData.selfPlayer.totalExploit
			);
			
		}
		
		private function initData():void
		{
			_currentPage = _pageView.currentPage;
			initTemplateData();
			initPlayerData();
		}
		
		override public function assetsCompleteHandler():void
		{
			_bg.bitmapData = AssetUtil.getAsset("ssztui.skill.ClubBgAsset",BitmapData) as BitmapData;
		}
		
		
		private function initEvents():void
		{
			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.REMOVE_SKILL,removeSkillHandler);
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,exploitUpdateHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GUILD_SKILL_UPGRADE_TIMERS,updateTimesHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function removeEvents():void
		{
			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.REMOVE_SKILL,removeSkillHandler);
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,exploitUpdateHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE,exploitUpdateHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GUILD_SKILL_UPGRADE_TIMERS,updateTimesHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function addSkillHandler(evt:SkillListUpdateEvent):void
		{
			var skill:SkillItemInfo = evt.data as SkillItemInfo;
			var tilePlace:int = skill.getTemplate().place - FIRST_SKILL_PLACE - PAGE_SIZE * (_currentPage - 1);
			_totalItems[tilePlace].skillInfo = skill;
			
			if(_skillTemplateInfo.templateId == skill.templateId)
			{
				setSkillItemInfo(skill);
			}
		}
		
		private function updateTimesHandler(e:CommonModuleEvent):void
		{
			_todayUpTimes.setHtmlValue(
				LanguageManager.getWord("ssztl.skill.todayUpgradeTimes") + "：" + 
				"<font color='#00ff00'><b>"+(TOTAL_TIME - GlobalData.guildSkillUpTimes).toString()+"</b></font>"
			);
		}
		
		
		private function removeSkillHandler(evt:SkillListUpdateEvent):void
		{
			var skillId:int = int(evt.data);
			for each(var i:GuildSkillCell in _totalItems)
			{
				if(i.info.templateId == skillId)
				{
					i.skillInfo = null;
					break;
				}
			}
		}
		
		private function pageChangeHandler(event:Event):void
		{
			initData();
		}
		
		//初始化所有技能模版
		private function initTemplateData():void
		{
			clearView();
			var skillTemplates:Array = SkillTemplateList.getSelfGuildSkills();
			var i:int = 0;
			var cell:GuildSkillCell;
			
			var currFirst:int = FIRST_SKILL_PLACE + (_currentPage - 1) * PAGE_SIZE;
			var currLast:int = currFirst + PAGE_SIZE - 1;
			
			for(i = currFirst; i <= currLast; i++)
			{
				if(skillTemplates[i])
				{
					cell = createCell(skillTemplates[i]);
					_totalItems.push(cell);
					_tile.appendItem(cell);
				}
			}
		}
		
		private function clearView():void
		{
			_tile.disposeItems();
			_totalItems.length = 0;
		}
		
		//初始化当前玩家已学习技能
		private function initPlayerData():void
		{
			var placeList:Array = new Array();
			var j:int;
			var placeCurrFirst:int = FIRST_SKILL_PLACE + (_currentPage - 1) * PAGE_SIZE;
			for(j = 0; j < PAGE_SIZE; j++)
			{
				placeList.push(placeCurrFirst + j);
			}
			
			var list:Array = GlobalData.skillInfo.getSkillByPlace(placeList);
			for each(var i:SkillItemInfo in list)
			{
				var tilePlace:int = i.getTemplate().place - FIRST_SKILL_PLACE - PAGE_SIZE * (_currentPage - 1);
				_totalItems[tilePlace].skillInfo = i;
			}
		}
		
		//点击技能单元格触发
		protected function cellClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			super.cellClickHandler(evt);
			if(_currentCell)
			{
				_currentCell.selected = false;
			}
			setCurrentCell(evt.currentTarget as GuildSkillCell);	
		}
		
		//设定当前选中单元格
		protected function setCurrentCell(curCell:GuildSkillCell):void
		{
			if(_currentCell)
			{
				_currentCell.selected = false;
			}
			
			var cell:GuildSkillCell = curCell;
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
			
//			_studyBtn.visible = true;
//			_upgradeBtn.visible = false;
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
//			_studyBtn.visible = false;
//			_upgradeBtn.visible = true;
		}
		
		//技能升级后触发
		private function upgradeHandler(evt:SkillItemInfoUpdateEvent):void
		{
			if(_skillItemInfo == null)
				return;
			var itemInfo:SkillItemInfo = evt.target as SkillItemInfo;
			
			var tilePlace:int = itemInfo.getTemplate().place - FIRST_SKILL_PLACE - PAGE_SIZE * (_currentPage - 1);
			_totalItems[tilePlace].skillInfo = itemInfo;
			
			
			if(_skillItemInfo.templateId == itemInfo.templateId)
				setSkillItemInfo(itemInfo);
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
		
		
		protected function createCell(info:SkillTemplateInfo):GuildSkillCell
		{
			var cell:GuildSkillCell = new GuildSkillCell();
			cell.info = info;
			if(cell.info)
			{
				cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				cell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				cell.addEventListener(CellEvent.UPGRADE_CLICK,upgradeClickHandler);
			}
			return cell;
		}
		
		
		protected function upgradeClickHandler(evt:CellEvent):void
		{
			if(TOTAL_TIME - GlobalData.guildSkillUpTimes <= 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.skill.guildSkillUpError"));
				return;
			}
			_mediator.studyOrUpgrade(int(evt.data));
			
		}
		
		
		protected function cellDownHandler(evt:MouseEvent):void
		{
			var cell:GuildSkillCell = evt.currentTarget as GuildSkillCell;
			if(cell.skillInfo == null)return;
		}
		
		private function exploitUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_showCopper.setHtmlValue(
				"<font color='#d8992b'>"+LanguageManager.getWord("ssztl.common.copperLabel") +"</font>"+ 
				(GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper).toString()
			);
			_selfExploit.setHtmlValue(
				"<font color='#d8992b'>"+LanguageManager.getWord("ssztl.task.personalExploit") +"：</font>" +
				GlobalData.selfPlayer.selfExploit// + "/" + GlobalData.selfPlayer.totalExploit
			);
		}
		
		//根据当前选中技能，显示该技能的详细信息
		private function setDetails(value:SkillTemplateInfo, level:int=0):void
		{
//			_studyBtn.enabled = true;
//			_upgradeBtn.enabled = true;
			var useble:Boolean = true;
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
			_skillType.setValue(getActiveTypeName(value.activeType));
			
			if(level >= value.totalLevel)
			{
				_upgradeEffect.setValue(LanguageManager.getWord("ssztl.store.skillAchieveMaxValue"));
				_upgradeEffect.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_upgradeEffect.length);
//				if(_upgradeBtn)
//				{
//					_upgradeBtn.visible = false;
//				}
				_needYanwutangLevel.setValue("-");
				_needCopper.setValue("-");
				_needExploit.setValue("-");
			}
			else
			{
				_upgradeEffect.setValue(value.getEffectToString(level+1,true));
				_needYanwutangLevel.setValue(value.needLevel[level]);
				_needCopper.setValue(value.needCopper[level]);
				_needExploit.setValue(value.needFeats[level]);
			}
			
			if(value.needCopper[level]==0 && value.needFeats[level]==0)
			{
//				_needCopper.setValue("");
//				_needExploit.setValue("");
			}
			else
			{
				if(GlobalData.selfPlayer.selfExploit >= value.needFeats[level])
				{
					_needExploit.setLabelType(MAssetLabel.LABEL_TYPE20);
				}
				else
				{
					_needExploit.setLabelType(MAssetLabel.LABEL_TYPE6);
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
			if(GlobalData.selfPlayer.clubFurnaceLevel>=value.needLevel[level])
			{
				_needYanwutangLevel.setLabelType(MAssetLabel.LABEL_TYPE20);
			}
			else
			{
				_needYanwutangLevel.setLabelType(MAssetLabel.LABEL_TYPE6);
				useble = false;
			}
			
//			if(!useble)
//			{
//				if(_upgradeBtn)
//					_upgradeBtn.enabled = false;
//				if(_studyBtn)
//					_studyBtn.enabled = false;
//			}
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
			_todayUpTimes = null;
			_selfExploit = null;
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_totalItems)
			{
				for each(var cell:GuildSkillCell in _totalItems)
				{
					cell.removeEventListener(MouseEvent.CLICK,cellClickHandler);
					cell.removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
					cell.dispose();
					cell = null;
				}
				_totalItems = null;
			}
			
			if(_skillItemInfo)
			{
				_skillItemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
				_skillItemInfo = null;
			}
			
			
			_currentCell = null;
			_mediator = null;
		}
	}
}