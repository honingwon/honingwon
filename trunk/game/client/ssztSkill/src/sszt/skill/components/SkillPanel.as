package sszt.skill.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.data.skill.SkillItemInfoUpdateEvent;
	import sszt.core.data.skill.SkillListUpdateEvent;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.skill.mediators.SkillMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.skill.SkillTitleAsset;
	
	public class SkillPanel extends MPanel
	{
		private var _mediator:SkillMediator;
		private var _bg:IMovieWrapper;
		
//		private var _labels:Vector.<String>;
//		private var _poses:Vector.<Point>;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _classes:Vector.<Class>;
//		private var _panels:Vector.<ISkillTabPanel>;
		private var _labels:Array;
		private var _poses:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
//		private var _spriteBg:Sprite;
		
//		private var _skillName:MAssetLabel;  //技能名称
//		private var _skillTarget:MAssetLabel; //技能目标
//		private var _skillEffect:MAssetLabel;  //技能效果
//		private var _upgradeEffect:MAssetLabel;  //升级效果
//		private var _needLevelValue:MAssetLabel;  //需要等级
//		private var _needCopperValue:MAssetLabel;  //需要铜币值
//		private var _needLifeExpValue:MAssetLabel;  //需要历练值
//		
//		private var _curCopperLabel:MAssetLabel; //当前铜币值
//		private var _curLifeExpesLabel:MAssetLabel; //当前历练值
//		
//		private var _studyBtn:MCacheAssetBtn1;  //学习按钮
//		private var _upgradeBtn:MCacheAssetBtn1; //升级按钮
		
		private var _curIndex:int = -1;
		
		
		private var _assetsComplete:Boolean;
		
		
		public function SkillPanel(mediator:SkillMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new SkillTitleAsset())),true,-1);
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.SKILL));
		}
		
		//初始化组件
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(459,415);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,443,382)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,29,273,374)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(287,29,160,374)),
			]);
			addContent(_bg as DisplayObject);
			
//			setSize(472,325);
//			
//			_bg =  BackgroundUtils.setBackground([
//				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,458,252)),
//				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,30,448,5),new MCacheSplit1Line()),
//				
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(5,35,265,211)),
//				
//				//第一行单元格
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,77,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(54,77,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(96,77,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(138,77,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(180,77,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(222,77,40,40),new Bitmap(CellCaches.getCellBg())),
//				
//				//第二行单元格
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,164,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(54,164,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(96,164,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(138,164,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(180,164,40,40),new Bitmap(CellCaches.getCellBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(222,164,40,40),new Bitmap(CellCaches.getCellBg())),
//				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(272,36,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillName"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(332,34,121,19)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(272,58,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.skillTarget"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(332,56,121,19)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(273,78,180,50)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(272,133,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.updateEffect"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(332,131,121,49)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(272,185,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.needLevel") + "：",MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(332,183,121,19)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(272,207,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needCopper"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(332,205,121,19)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(272,229,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.skill.needLiftExp"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(332,227,121,19)),
//				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,262,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.currentCopper"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(68,260,109,19)),
//				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(193,262,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.currentLiftExp"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(253,260,109,19))
//			]);
//			
//			addContent(_bg as DisplayObject);
			
//			_spriteBg = new Sprite();
//			_spriteBg.graphics.beginFill(0,0);
//			_spriteBg.graphics.drawRect(193,262,167,16);
//			_spriteBg.graphics.endFill();
//			addContent(_spriteBg);
//			_spriteBg.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
//			_spriteBg.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			//选项卡按钮
//			_labels = Vector.<String>(["主动技能","被动技能","通用心法","法宝技能","其他技能"]);
//			_poses = Vector.<Point>([new Point(12,9),new Point(82,9),new Point(152,9),new Point(222,9),new Point(292,9)]);
//			_btns = new Vector.<MCacheTab1Btn>();
			
			_labels = [LanguageManager.getWord("ssztl.skill.careerSkill"),
				LanguageManager.getWord("ssztl.club.clubSkill")
//				LanguageManager.getWord("ssztl.skill.normalSkill"),
//				LanguageManager.getWord("ssztl.skill.faBaoSkill"),
//				LanguageManager.getWord("ssztl.skill.otherSkill")
			];
			
			var posX:int = 13;
			_btns = [];
			for(var i:int=0; i<_labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(posX,0);
				_btns.push(btn);
				addContent(btn);
				posX += 69;
			}
			
//			//此处先屏蔽部分按钮
//			for(i = 2;i<_btns.length;i++)
//			{
//				_btns[i].visible = false;
//				_btns[i].enabled = false;
//			}
			
//			_classes = Vector.<Class>([NewActiveSkillPanel, NewPassiveSkillPanel]);
//			_panels = new Vector.<ISkillTabPanel>(_labels.length);
			_classes = [CareerSkillPanel, ClubSkillPanel];
			_panels = new Array(_labels.length);
			
//			_skillName = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_skillName.move(340,36);
//			addContent(_skillName);
//			
//			_skillTarget = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_skillTarget.move(340,58);
//			addContent(_skillTarget);
//			
//			_skillEffect = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_skillEffect.move(278,84);
//			addContent(_skillEffect);
//			
//			_upgradeEffect = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_upgradeEffect.move(335,135);
//			addContent(_upgradeEffect);
//			
//			_needLevelValue = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_needLevelValue.move(340,185);
//			addContent(_needLevelValue);
//			
//			_needCopperValue = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_needCopperValue.move(340,207);
//			addContent(_needCopperValue);
//			
//			_needLifeExpValue = new MAssetLabel("", MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_needLifeExpValue.move(340,229);
//			addContent(_needLifeExpValue);
//			
//			//当前铜币值
//			_curCopperLabel = new MAssetLabel((GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper).toString(), MAssetLabel.LABELTYPE1);
//			_curCopperLabel.move(72,261);
//			addContent(_curCopperLabel);
//			
//			//当前历练值
//			_curLifeExpesLabel =  new MAssetLabel(GlobalData.selfPlayer.lifeExperiences.toString() + "/" + GlobalData.selfPlayer.totalLifeExperiences, MAssetLabel.LABELTYPE1);
//			_curLifeExpesLabel.move(257,261);
//			addContent(_curLifeExpesLabel);
//			
//			//学习按钮
//			_studyBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.learn"));
//			_studyBtn.move(384,256);
//			addContent(_studyBtn);
//			_studyBtn.visible = false;
//			
//			//升级按钮
//			_upgradeBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.upgrade"));
//			_upgradeBtn.move(384,256);
//			addContent(_upgradeBtn);
//			_upgradeBtn.visible = false;
			
			initEvents();
			
			setIndex(0);
			
			setGuideTipHandler(null);
		}
	
		//初始化所有事件监听
		private function initEvents():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
//			_studyBtn.addEventListener(MouseEvent.CLICK,studyClickHandler);
//			_upgradeBtn.addEventListener(MouseEvent.CLICK,upgradeBtnHandler);
//			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
//			GlobalData.skillInfo.addEventListener(SkillListUpdateEvent.UPDATE_SKILL,addSkillHandler);
			
//			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
//			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.LIFEEXP_UPDATE,moneyUpdataHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		//移除所有事件监听
		private  function removeEvents():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK, btnClickHandler);
			}
//			_studyBtn.removeEventListener(MouseEvent.CLICK,studyClickHandler);
//			_upgradeBtn.removeEventListener(MouseEvent.CLICK,upgradeBtnHandler);
//			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.ADD_SKILL,addSkillHandler);
//			GlobalData.skillInfo.removeEventListener(SkillListUpdateEvent.UPDATE_SKILL,addSkillHandler);
			
//			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdataHandler);
//			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.LIFEEXP_UPDATE,moneyUpdataHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			
			for(var i:int = 0; i < _panels.length; i++)
			{
				if(_panels[i] != null)
					(_panels[i] as ISkillTabPanel).assetsCompleteHandler();
			}
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.SKILL)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addContent);
			}
		}
		
//		private function moneyUpdataHandler(evt:SelfPlayerInfoUpdateEvent):void
//		{
//			_curCopperLabel.setValue((GlobalData.selfPlayer.userMoney.copper + GlobalData.selfPlayer.userMoney.bindCopper).toString());
//			_curLifeExpesLabel.setValue(GlobalData.selfPlayer.lifeExperiences.toString()+ "/" + GlobalData.selfPlayer.totalLifeExperiences);
//			
//			_curCopperLabel.move(72,261);
//			_curLifeExpesLabel.move(257,261);
//			
//			if(_skillItemInfo)
//			{
//				setDetails(_skillItemInfo.getTemplate(),_skillItemInfo.level);
//			}
//			else if(_skillTemplateInfo)
//			{
//				setDetails(_skillTemplateInfo);
//			}
//		}
		
//		//点击学习技能
//		private function studyClickHandler(evt:MouseEvent):void
//		{
//			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			if(_skillTemplateInfo)
//				_mediator.studyOrUpgrade(_skillTemplateInfo.templateId);
//		}
//		
//		//点击升级技能
//		private function upgradeBtnHandler(evt:MouseEvent):void
//		{
//			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
//			if(_skillItemInfo)
//				_mediator.studyOrUpgrade(_skillItemInfo.getTemplate().templateId);
//		}
//		
//		//学习新技能后触发
//		public function addSkillHandler(evt:SkillListUpdateEvent):void
//		{
//			if(_skillTemplateInfo == null)
//				return;
//			var info:SkillItemInfo = evt.data as SkillItemInfo;
//			if(_skillTemplateInfo.templateId == info.templateId)
//			{
//				setSkillItemInfo(info);
//			}
//		}
//		
//		
//		//技能升级后触发
//		private function upgradeHandler(evt:SkillItemInfoUpdateEvent):void
//		{
////			setDetails(_skillItemInfo.getTemplate(),_skillItemInfo.level);
//			if(_skillItemInfo == null)
//				return;
//			var itemInfo:SkillItemInfo = evt.target as SkillItemInfo;
//			if(_skillItemInfo.templateId == itemInfo.templateId)
//				setSkillItemInfo(itemInfo);
//		}
		
		//点击选项卡按钮触发
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btns.indexOf(e.target as MCacheTabBtn1);
			setIndex(index);
		}
		
		//更改选项卡，导航选项卡更改时被调用
		public function setIndex(index:int):void
		{
			if(_curIndex == index) return;
			if(_curIndex != -1)
			{
				if(_panels[_curIndex])
				{
					_panels[_curIndex].hide();
					_btns[_curIndex].selected = false;
				}
			}
				
			_curIndex = index;
			_btns[_curIndex].selected = true;
			if(_panels[_curIndex] == null)
			{
				_panels[_curIndex] = new _classes[_curIndex](_mediator);
				
				if(_assetsComplete)
				{
					(_panels[_curIndex] as ISkillTabPanel).assetsCompleteHandler();
				}
			}
			_panels[_curIndex].move(9,26);
			addContent(_panels[_curIndex] as DisplayObject);
			_panels[_curIndex].show();
		}
		
//		//设置技能模板，选中未学习技能时被调用
//		public function set skillTemplateInfo(skillTemplateInfo:SkillTemplateInfo):void
//		{
//			_skillTemplateInfo = skillTemplateInfo;
//			if(_skillItemInfo)
//			{
//				_skillItemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
//				_skillItemInfo = null;
//			}
//			setDetails(_skillTemplateInfo);
//			
//			_studyBtn.visible = true;
//			_upgradeBtn.visible = false;
//		}
//		
//		//设置技能，选中已学习技能时被调用
//		public function setSkillItemInfo(skillItemInfo:SkillItemInfo):void
//		{
//			_skillTemplateInfo = null;
//			if(_skillItemInfo)
//			{
//				_skillItemInfo.removeEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
//			}
//			_skillItemInfo = skillItemInfo;
//			_skillItemInfo.addEventListener(SkillItemInfoUpdateEvent.SKILL_UPGRADE,upgradeHandler);
//			setDetails(_skillItemInfo.getTemplate(), _skillItemInfo.level);
//			_studyBtn.visible = false;
//			_upgradeBtn.visible = true;
//		}
//		
//		//根据当前选中技能，显示该技能的详细信息
//		private function setDetails(value:SkillTemplateInfo, level:int=0):void
//		{
//			_studyBtn.enabled = true;
//			_upgradeBtn.enabled = true;
//			var useble:Boolean = true;
//			if(level > 0)
//			{
//				_skillName.setValue(value.name + "Lv." + level);
//				_skillEffect.setValue(value.getEffectToString(level,false));
//				_skillTarget.setValue(value.getTargetToString(level));
//			}
//			else
//			{
//				_skillName.setValue(value.name);
//				_skillEffect.setValue(value.getEffectToString(1,false));
//				_skillTarget.setValue(value.getTargetToString(1));
//			}
//			if(level >= value.totalLevel)
//			{
//				_upgradeEffect.setValue(LanguageManager.getWord("ssztl.store.skillAchieveMaxValue"));
//				_upgradeEffect.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_upgradeEffect.length);
//				if(_upgradeBtn)
//				{
//					_upgradeBtn.visible = false;
//				}
//			
//				_needLevelValue.setValue("-");
//				_needCopperValue.setValue("-");
//				_needLifeExpValue.setValue("-");
//			}
//			else
//			{
//				_upgradeEffect.setValue(value.getEffectToString(level+1,false));
////				_upgradeEffect.setValue(value.getUpgradeEffectToString(level));
//				
//				_needLevelValue.setValue(value.needLevel[level]);
//				_needCopperValue.setValue(value.needCopper[level]);
//				_needLifeExpValue.setValue(value.needLifeExp[level]);
//			}
//			
////			_needLevelValue.setValue(value.needLevel[level]);
////			_needCopperValue.setValue(value.needCopper[level]);
////			_needLifeExpValue.setValue(value.needLifeExp[level]);
//			
////			if(level>= value.totalLevel)
////			{
////				_needLevelValue.setValue("");
////				_needCopperValue.setValue("");
////				_needLifeExpValue.setValue("");
////				return ;
////			}else
////			{
////				_needLevelValue.setValue(value.needLevel[level]);
////				_needCopperValue.setValue(value.needCopper[level]);
////				_needLifeExpValue.setValue(value.needLifeExp[level]);
////			}
//				
////			_skillName.move(340,36);
////			_skillTarget.move(340,58);
////			_skillEffect.move(278,84);
////			_upgradeEffect.move(337,133);
////			_needLevelValue.move(340,185);
////			_needCopperValue.move(340,207);
////			_needLifeExpValue.move(340,229);
//			
//			if(value.needCopper[level]==0 && value.needLifeExp[level]==0)
//			{
//				_needCopperValue.setValue("");
//				_needLifeExpValue.setValue("");
//			}
//			else
//			{
//				if(GlobalData.selfPlayer.lifeExperiences >= value.needLifeExp[level])
//				{
//					_needLifeExpValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff77),0,_needLifeExpValue.length);
//				}else
//				{
//					_needLifeExpValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needLifeExpValue.length);
//					useble = false;
//				}
//				if((GlobalData.selfPlayer.userMoney.copper+GlobalData.selfPlayer.userMoney.bindCopper)>=value.needCopper[level])
//				{
//					_needCopperValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff77),0,_needCopperValue.length);
//				}else
//				{
//					_needCopperValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needCopperValue.length);
//					useble = false;
//				}
//			}
//			if(GlobalData.selfPlayer.level>=value.needLevel[level])
//			{
//				_needLevelValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x00ff77),0,_needLevelValue.length);
//			}else
//			{
//				_needLevelValue.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needLevelValue.length);
//				useble = false;
//			}
//			
//			if(!useble)
//			{
//				if(_upgradeBtn)
//					_upgradeBtn.enabled = false;
//				if(_studyBtn)
//					_studyBtn.enabled = false;
//			}
//		}
		
//		private function overHandler(evt:MouseEvent):void
//		{
//			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.skill.lifeExpTipsLabel"),null,new Rectangle(0,0,evt.stageX,evt.stageY));
//		}
//		
//		private function outHandler(evt:MouseEvent):void
//		{
//			TipsUtil.getInstance().hide();	
//		}
		
		//清空内存
		override public function dispose():void
		{
			removeEvents();
//			if(_spriteBg)
//			{
//				_spriteBg.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
//				_spriteBg.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
//				_spriteBg = null;
//			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btns)
			{
				for each(var btn:MCacheTabBtn1 in _btns)
				{
					btn.dispose();
					btn = null;
				}
				_btns = null;
			}
			if(_panels)
			{
				for each(var panel:ISkillTabPanel in _panels)
				{
					if(panel)
					{
						panel.dispose();
						panel = null;
					}			
				}
				_panels = null;
			}
		
			
			_labels = null;
			_poses = null;
			_classes = null;
			
//			_skillItemInfo = null;
			
			_mediator = null;
			
			super.dispose();
			
		}
	}
}










