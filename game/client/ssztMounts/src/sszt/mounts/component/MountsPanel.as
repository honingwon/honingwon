/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-6 下午2:43:42 
 * 
 */ 
package sszt.mounts.component
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsItemInfoUpdateEvent;
	import sszt.core.data.mounts.MountsUpgradeTemplate;
	import sszt.core.data.mounts.MountsUpgradeTemplateList;
	import sszt.core.data.mounts.mountsSkill.MountsSkillInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.mounts.MountsStateChangeSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.petSkill.PetSkillPanel;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.MountsDiamondTip;
	import sszt.core.view.tips.MountsStarLevelTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ChatModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.mounts.component.items.MountsItemView;
	import sszt.mounts.component.popup.UpgradeQualityLevelPanel;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.mounts.socketHandler.MountsReleaseSocketHandler;
	import sszt.mounts.socketHandler.MountsRemoveSkill1SocketHandler;
	import sszt.mounts.socketHandler.MountsRemoveSkillSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.pet.BaseAttrTitleAsset;
	import ssztui.pet.BtnPreviewAsset;
	import ssztui.pet.ExpBarAsset;
	import ssztui.pet.ExpTrackAsset;
	import ssztui.pet.GrowupTitleAsset;
	import ssztui.pet.IconDiamondAsset;
	import ssztui.pet.IconStarAsset;
	import ssztui.pet.ItemLockAsset;
	import ssztui.pet.ItemMountOnAsset;
	import ssztui.pet.MountInfoTitleAsset;
	import ssztui.pet.MountSkillTitleAsset;
	import ssztui.pet.MountsNameAsset0;
	import ssztui.pet.MountsNameAsset1;
	import ssztui.pet.MountsNameAsset2;
	import ssztui.pet.QualityTitleAsset;
	import ssztui.pet.TitleMountAsset;
	import ssztui.ui.BarAsset7;
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressBarGreen;
	import ssztui.ui.ProgressTrack2Asset;
	import ssztui.ui.ProgressTrack3Asset;
	import ssztui.ui.SplitCompartLine;
	import ssztui.ui.SplitCompartLine2;
	

	public class MountsPanel extends MPanel
	{
		public static const PANEL_WIDTH:int = 636;
		public static const PANEL_HEIGHT:int = 400;
		
		private var _mediator:MountsMediator;
		private var _bgBase:IMovieWrapper;
		private var _bg:IMovieWrapper;
		public var leftPanel:MountsLeftPanel;
		public var _toData:ToMountsData;
		
		private var _nameTxtImg:Bitmap;
		private var _labelInfo:MAssetLabel;
		private var _labelAtt:MAssetLabel;
		private var _nameLabel:MAssetLabel;
		private var _stairsLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _growLabel:MAssetLabel;
		private var _speedeLabel:MAssetLabel;
		private var _qualityLabel:MAssetLabel;
		private var _refinedLabel:MAssetLabel;
		private var _fightLabel:MAssetLabel;
		private var _hpLabel:MAssetLabel;
		private var _mpLabel:MAssetLabel;
		private var _attackLabel:MAssetLabel;
		private var _defLabel:MAssetLabel;
		private var _attackLabel1:MAssetLabel;
		private var _magicDefenceLabel:MAssetLabel;
		private var _farDefenceLabel:MAssetLabel;
		private var _mumpDefenceLabel:MAssetLabel;
		private var _tipLabel:MAssetLabel;
		
		private var _txtLink:MAssetLabel;
		private var _upBtn:MCacheAssetBtn1;
		private var _restBtn:MCacheAssetBtn1;
		private var _fightBtn:MCacheAssetBtn1;
		/**
		 * 进阶 
		 */		
		private var _stairsBtn:MCacheAssetBtn1;
		/**
		 * 进化 
		 */		
		private var _growBtn:MCacheAssetBtn1;
		/**
		 * 提升 
		 */		
		private var _qualityBtn:MCacheAssetBtn1;
		/**
		 * 洗练 
		 */		
		private var _refinedBtn:MCacheAssetBtn1;
		
		private var _progressBar:ProgressBar1;
		private var _growExpProgressBar:ProgressBar;
		private var _qualityProgressBar:ProgressBar;
		private var _textExp:MAssetLabel;
		
		private var _mountsInfo:MountsItemInfo;
		
		private var _panels:Array;
		private var _btns:Array;
		
		private var _mountsBg:Bitmap;
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _imageContainer:MSprite;
		private var _character:ICharacter;
		private var _tipBgList:Array;
		private var _preview:MAssetButton1;
		
		private var _tabBtns:Array;
		private var _classes:Array;
		private var _currentIndex:int = -1;
		private var _petBaseInfoContainer:MountsInfoView;
		
		private var _assetsComplete:Boolean;
		private var _btnRefinedMask:MSprite;
		
		public function MountsPanel(mediator:MountsMediator,toData:ToMountsData)
		{
			_mediator = mediator;
			_toData = toData;
			super(new MCacheTitle1("",new Bitmap(new TitleMountAsset())), true,-1,true,true);
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.MOUNTS));
			
			
			setIndex(_toData.tabIndex);
//			if(_mediator.module.toMountsData.showPanel != -1)
//			{
//				showPanel(_mediator.module.toMountsData.showPanel);
//			}
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(636,400);
			_bgBase = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,0,149,392)),
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(157,25,471,367)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(9,1,147,389)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(161,29,463,359)),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,73,141,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,143,141,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,213,141,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,283,141,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,353,141,2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,14,50,50),new Bitmap(new ItemMountOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,84,50,50),new Bitmap(new ItemMountOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,154,50,50),new Bitmap(new ItemMountOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,224,50,50),new Bitmap(new ItemLockAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,294,50,50),new Bitmap(new ItemLockAsset()))
			]); 
			addContent(_bgBase as DisplayObject);
			
			leftPanel = new MountsLeftPanel(_mediator);
			leftPanel.move(12,4);
			addContent(leftPanel);
			
			_imageContainer = new MSprite();
			addContent(_imageContainer);
			
			_petBaseInfoContainer = new MountsInfoView();
			_petBaseInfoContainer.move(161,29);
			addContent(_petBaseInfoContainer);			
			_mountsBg = new Bitmap();
			_mountsBg.x = _mountsBg.y = 2;
			_petBaseInfoContainer.addChild(_mountsBg);
			
			var _tabLabels:Array = [
				LanguageManager.getWord('ssztl.common.munts'),
				LanguageManager.getWord('ssztl.common.stairs'),
				LanguageManager.getWord('ssztl.common.skill'),
				LanguageManager.getWord('ssztl.pet.inherit')
			];
			_classes = [_petBaseInfoContainer,MountsStairsView,MountsSkillView,MountsInheritView];
			_tabBtns = [];
			_panels = [_petBaseInfoContainer];
			for(var i:int = 0; i < _tabLabels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_tabLabels[i]);
				btn.move(163+i*69, 0);
				addContent(btn);
				_tabBtns.push(btn);
			}
			setIndex(0);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2,268,315,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(320,163,140,15),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(358,170,66,16),new Bitmap(new BaseAttrTitleAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(19,247,282,22),new Bitmap(new ExpTrackAsset())),
			]); 
			_petBaseInfoContainer.addChild(_bg as DisplayObject);
			
			_starBg = new IconStarAsset();
			_starBg.x = 234;
			_starBg.y = 13;
			_petBaseInfoContainer.addChild(_starBg);
			
			_diamondBg = new IconDiamondAsset();
			_diamondBg.x = 273;
			_diamondBg.y = 13;
			_petBaseInfoContainer.addChild(_diamondBg);
			_starBg.gotoAndStop(1);
			_diamondBg.gotoAndStop(1);
			
			_tipBgList = [_starBg,_diamondBg];
			
			_preview = new MAssetButton1(new BtnPreviewAsset() as MovieClip);
			_preview.move(270,55);
			_petBaseInfoContainer.addChild(_preview);
			
			/** 信息标签　*/
			_labelInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelInfo.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_labelInfo.move(331,38);
			_petBaseInfoContainer.addChild(_labelInfo);
			_labelInfo.setValue(
				LanguageManager.getWord("ssztl.common.level")+ "：\n" +
				LanguageManager.getWord("ssztl.common.speed")+ "：\n" +
				LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.qualityLabel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.growLabel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.refinedLabel")+ "："
			);
			
			if(!GlobalData.functionYellowEnabled)
			{
				_labelInfo.setValue(
					LanguageManager.getWord("ssztl.common.level")+ "：\n" +
					LanguageManager.getWord("ssztl.common.speed")+ "：\n" +
					LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：\n" +
					LanguageManager.getWord("ssztl.common.qualityLabel")+ "：\n" +
					LanguageManager.getWord("ssztl.common.growLabel")
				);
			}
			/** 属性标签　*/
			_labelAtt = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelAtt.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_petBaseInfoContainer.addChild(_labelAtt);
			_labelAtt.move(331,196);
			_labelAtt.setValue(
				LanguageManager.getWord("ssztl.common.life")+ "：\n" +
				LanguageManager.getWord("ssztl.common.magic")+ "：\n" +
				LanguageManager.getWord("ssztl.common.attack")+ "：\n" +
				LanguageManager.getWord("ssztl.common.defense")+ "：\n" +
				LanguageManager.getWord("ssztl.mounts.attack")+ "：\n" +
				LanguageManager.getWord("ssztl.common.magicDefence2")+ "：\n" +
				LanguageManager.getWord("ssztl.common.farDefence2")+ "：\n" +
				LanguageManager.getWord("ssztl.common.mumpDefence2")+ "："
			);
			
			_nameTxtImg = new Bitmap();
			_nameTxtImg.x = 368;
			_nameTxtImg.y = 12;
			_petBaseInfoContainer.addChild(_nameTxtImg);
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_nameLabel.move(18,18);
//			_petBaseInfoContainer.addChild(_nameLabel);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_levelLabel.move(367,38);
			_petBaseInfoContainer.addChild(_levelLabel);
			
			_speedeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_speedeLabel.move(367,58);
			_petBaseInfoContainer.addChild(_speedeLabel);
			
			_stairsLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_stairsLabel.move(367,78);
			_petBaseInfoContainer.addChild(_stairsLabel);
			
			_qualityLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_qualityLabel.move(367,98);
			_petBaseInfoContainer.addChild(_qualityLabel);
			
			_growLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_growLabel.move(367,118);
			_petBaseInfoContainer.addChild(_growLabel);
			
			_refinedLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_refinedLabel.move(367,138);
			if(GlobalData.functionYellowEnabled) _petBaseInfoContainer.addChild(_refinedLabel);
			
			_fightLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_fightLabel.move(467,117);
//			addContent(_fightLabel);
			
			//属性
			_hpLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_hpLabel.move(367,196);
			_petBaseInfoContainer.addChild(_hpLabel);
			
			_mpLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_mpLabel.move(367,216);
			_petBaseInfoContainer.addChild(_mpLabel);
			
			_attackLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_attackLabel.move(367,236);
			_petBaseInfoContainer.addChild(_attackLabel);
			
			_defLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_defLabel.move(367,256);
			_petBaseInfoContainer.addChild(_defLabel);
			
			_attackLabel1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_attackLabel1.move(367,276);
			_petBaseInfoContainer.addChild(_attackLabel1);
			
			_magicDefenceLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_magicDefenceLabel.move(367,296);
			_petBaseInfoContainer.addChild(_magicDefenceLabel);
			
			_farDefenceLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_farDefenceLabel.move(367,316);
			_petBaseInfoContainer.addChild(_farDefenceLabel);
			
			_mumpDefenceLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_mumpDefenceLabel.move(367,336);
			_petBaseInfoContainer.addChild(_mumpDefenceLabel);
			
			_tipLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2);
			_tipLabel.move(160,328);
//			_tipLabel.setHtmlValue("坐骑属性100%附加给人物");
			_petBaseInfoContainer.addChild(_tipLabel);
			
			_txtLink = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtLink.textColor = 0x7ecad0;
			_txtLink.move(17,15);
			_txtLink.mouseEnabled = true;
			_petBaseInfoContainer.addChild(_txtLink);
			_txtLink.setHtmlValue(
				"<a href=\'event:0\'><u>" + LanguageManager.getWord("ssztl.common.giveLife") + 
				"</u></a> <a href=\'event:1\'><u>" + LanguageManager.getWord("ssztl.common.show")
//				"</u></a> <a href=\'event:2\'><u>" + LanguageManager.getWord("ssztl.mounts.lookBtn") + "</u></a>"
			);
			
			_upBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.common.upgrade"));
			_upBtn.move(55,285);
			_petBaseInfoContainer.addChild(_upBtn);
			
			_restBtn  = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.common.rest"));
			_restBtn.move(165,285);
			_petBaseInfoContainer.addChild(_restBtn);
			_restBtn.visible = false;
			
			_fightBtn  = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.common.fight"));
			_fightBtn.move(165,285);
			_petBaseInfoContainer.addChild(_fightBtn);
			_fightBtn.visible = false;
			
			_stairsBtn  = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.stairs"));
			_stairsBtn.move(573,90);
//			_petBaseInfoContainer.addChild(_stairsBtn);
			
			_qualityBtn  = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.upgrade1"));
			_qualityBtn.move(420,93);
			_petBaseInfoContainer.addChild(_qualityBtn);
			
			_growBtn  = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.upgrade1"));
			_growBtn.move(420,115);
			_petBaseInfoContainer.addChild(_growBtn);
			
			_refinedBtn  = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.upgrade1"));
			_refinedBtn.move(420,137);
			if(GlobalData.functionYellowEnabled) _petBaseInfoContainer.addChild(_refinedBtn);
			_btnRefinedMask = new MSprite();		
			if(GlobalData.functionYellowEnabled && GlobalData.selfPlayer.level <35)
			{
				_refinedBtn.enabled = false;
				_btnRefinedMask.graphics.beginFill(0,0);
				_btnRefinedMask.graphics.drawRect(420,137,_refinedBtn.width,_refinedBtn.height);
				_btnRefinedMask.graphics.endFill();
				_petBaseInfoContainer.addChild(_btnRefinedMask);
				_btnRefinedMask.addEventListener(MouseEvent.MOUSE_OVER, handleBtnRefinedMouseOver);
				_btnRefinedMask.addEventListener(MouseEvent.MOUSE_OUT, handleBtnRefinedMouseOut);
			}
			
			_progressBar = new ProgressBar1(new Bitmap(new ExpBarAsset() as BitmapData),0,0,232,13,false,false);
			_progressBar.move(44,252);
			_petBaseInfoContainer.addChild(_progressBar);
			
			_textExp = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_textExp.move(160,250);
			_petBaseInfoContainer.addChild(_textExp);
			_textExp.setValue(LanguageManager.getWord("ssztl.common.experience")+ "：0/0");
			
			_qualityProgressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset() as BitmapData),0,0,164,9,true,false);
			_qualityProgressBar.move(429,191);
//			_petBaseInfoContainer.addChild(_qualityProgressBar);
			
			_growExpProgressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset() as BitmapData),0,0,164,9,true,false);
			_growExpProgressBar.move(429,260);
//			_petBaseInfoContainer.addChild(_growExpProgressBar);
			
			if(leftPanel.currentItem)
			{
				initView(leftPanel.currentItem.mountsInfo);
				_mediator.module.mountsInfo.changeMounts(leftPanel.currentItem.mountsInfo);
			}
			
			_btns = [_upBtn,_restBtn,_fightBtn,
				_stairsBtn,_growBtn,_qualityBtn,
				_preview,_refinedBtn];//
			initEvent();
			
//			if(_mediator.module.toMountsData.showPanel != -1)
//			{
//				showPanel(_mediator.module.toMountsData.showPanel);
//			}
		}
		
		private function showPanel(type:int):void
		{
			switch(type)
			{
				case 0:
					_mediator.initUpgradeQualityLevelPanel();
					break;
				case 1:
					_mediator.initEvolutionPanel();
					break;
				case 2:
					_mediator.initUpgradeIntelligencePanel();
					break;	
			}
		}
		
		private function initEvent():void
		{
			leftPanel.addEventListener(MountsLeftPanel.SELECT_CHANGE,selectChangeHandler);
			_txtLink.addEventListener(TextEvent.LINK,linkClickHandler);
			for(var j:int = 0 ;j< _tipBgList.length ; ++j)
			{
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
			
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			for(i = 0; i < _tabBtns.length; i++)
			{
				_tabBtns[i].addEventListener(MouseEvent.CLICK, tabBtnClickHandler);
			}
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
		}
		 
		private function removeEvent():void
		{
			leftPanel.removeEventListener(MountsLeftPanel.SELECT_CHANGE,selectChangeHandler);
			_txtLink.removeEventListener(TextEvent.LINK,linkClickHandler);
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			for(var j:int = 0 ;j< _tipBgList.length; ++j)
			{
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			_btnRefinedMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnRefinedMouseOver);
			_btnRefinedMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnRefinedMouseOut);
		}
		
		private function handleBtnRefinedMouseOver(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.mounts.refinedLevel'),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function handleBtnRefinedMouseOut(e:Event):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function tabBtnClickHandler(event:MouseEvent):void
		{
			var index:int = _tabBtns.indexOf(event.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		public function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			if(_currentIndex > -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_tabBtns[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_tabBtns[_currentIndex].selected = true;
			
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(161,29);
				if(_assetsComplete)
				{
					(_panels[_currentIndex] as IMountsView).assetsCompleteHandler();
				}
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
			
			updateCharacter();
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.MOUNTS)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),_petBaseInfoContainer.addChild);
			}
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			if(!leftPanel.currentItem) return;
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			var template_id:int = this._mountsInfo.templateId;
			var star_level:int = this._mountsInfo.star;
			var diamond:int = this._mountsInfo.diamond;
			var tipStr:String;
			if (index == 0 )
				tipStr = MountsStarLevelTip.getInstance().getDataStr(template_id,star_level);
			else if ( index == 1)
				tipStr = MountsDiamondTip.getInstance().getDataStr(template_id, diamond);
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function stateChangeHandler(e:MountsItemInfoUpdateEvent):void
		{
			var info:MountsItemInfo = e.target as MountsItemInfo;
			changeBtn(info.state);
		}
		
		private function selectChangeHandler(e:Event):void
		{
			var info:MountsItemInfo = (e.target as MountsLeftPanel).currentItem.mountsInfo;
			initView(info);
			_mediator.module.mountsInfo.changeMounts(info);
			updateCharacter();
		}
		
		private function initView(info:MountsItemInfo):void
		{
			if(!info) return;
			if(_mountsInfo)
			{
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.CHANGE_STATE,stateChangeHandler);
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE,onUpdateHandler);
//				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE_STAIRS,styleUpdateHandler);
			}
			_mountsInfo = info;
			_mountsInfo.addEventListener(MountsItemInfoUpdateEvent.CHANGE_STATE,stateChangeHandler);
			_mountsInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
			_mountsInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE,onUpdateHandler);
//			_mountsInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE_STAIRS,styleUpdateHandler);
			
//			_nameLabel.setValue(info.nick);
//			_nameLabel.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(info.templateId).quality);
			_nameLabel.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(info.templateId).quality) +"'>" + info.nick + "</font> "
			);
			_nameTxtImg.bitmapData = getMountsName(info.nick);
			_levelLabel.setValue(info.level.toString());
			_tipLabel.setHtmlValue(getTransform(ItemTemplateList.getTemplate(_mountsInfo.templateId).quality));
			
			_stairsLabel.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",info.stairs));			
			_growLabel.setValue(info.grow + "/" + info.upGrow);
			_refinedLabel.setValue(info.refined + "/" + info.level);
			_growExpProgressBar.setValue(info.upGrow,info.grow);
			_speedeLabel.setValue(info.speed.toString() + "%");
			_qualityLabel.setValue(info.quality + "/" + info.upQuality);
			_qualityProgressBar.setValue(info.upQuality,info.quality);
			
			updateAttr();
			
			onExpUpdate(info.exp,info.level);
			
			changeBtn(info.state);
			
			updateCharacter();
		}
		
		private function onUpdateHandler(evt:MountsItemInfoUpdateEvent):void
		{
			_nameLabel.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_mountsInfo.templateId).quality) +"'>" + _mountsInfo.nick + "</font> "
			);
			_nameTxtImg.bitmapData = getMountsName(_mountsInfo.nick);
			_tipLabel.setHtmlValue(getTransform(ItemTemplateList.getTemplate(_mountsInfo.templateId).quality));
			
			_stairsLabel.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",_mountsInfo.stairs));
			_levelLabel.setValue(_mountsInfo.level.toString());
			_growLabel.setValue(_mountsInfo.grow + "/" + _mountsInfo.upGrow);
			_refinedLabel.setValue(_mountsInfo.refined + "/" + _mountsInfo.level);
			_growExpProgressBar.setValue(_mountsInfo.upGrow,_mountsInfo.grow);
			_speedeLabel.setValue(_mountsInfo.speed.toString() + "%");
			_qualityLabel.setValue(_mountsInfo.quality + "/" + _mountsInfo.upQuality);
			_qualityProgressBar.setValue(_mountsInfo.upQuality,_mountsInfo.quality);
			
			updateAttr();
		}
		private function updateAttr():void
		{
			_fightLabel.setValue(_mountsInfo.fight.toString());
			
			_hpLabel.htmlText = _mountsInfo.hp + (_mountsInfo.hp1>0?"<font color='#66ff00'> +" + _mountsInfo.hp1 + "</font>":"");
			_mpLabel.htmlText = _mountsInfo.mp + (_mountsInfo.mp1>0?"<font color='#66ff00'> +" + _mountsInfo.mp1 + "</font>":"");
			_attackLabel.htmlText = _mountsInfo.attack + (_mountsInfo.attack1>0?"<font color='#66ff00'> +" + _mountsInfo.attack1 + "</font>":"");
			_defLabel.htmlText = _mountsInfo.defence + (_mountsInfo.defence1>0?"<font color='#66ff00'> +" + _mountsInfo.defence1 + "</font>":"");
			
			_attackLabel1.htmlText = (_mountsInfo.farAttack + _mountsInfo.magicAttack + _mountsInfo.mumpAttack) + ((_mountsInfo.farAttack1 + _mountsInfo.magicAttack1 + _mountsInfo.mumpAttack1)>0?"<font color='#66ff00'> +" + (_mountsInfo.farAttack1 + _mountsInfo.magicAttack1 + _mountsInfo.mumpAttack1) + "</font>":"");
			
			_magicDefenceLabel.htmlText = _mountsInfo.magicDefence + (_mountsInfo.magicDefence1>0?"<font color='#66ff00'> +" + _mountsInfo.magicDefence1 + "</font>":"");
			_farDefenceLabel.htmlText = _mountsInfo.farDefence + (_mountsInfo.farDefence1>0?"<font color='#66ff00'> +" + _mountsInfo.farDefence1 + "</font>":"");
			_mumpDefenceLabel.htmlText = _mountsInfo.mumpDefence + (_mountsInfo.mumpDefence1>0?"<font color='#66ff00'> +" + _mountsInfo.mumpDefence1 + "</font>":"");
			
			if(_mountsInfo.star>-1) _starBg.gotoAndStop(_mountsInfo.star+1);
			if(_mountsInfo.diamond>-1) _diamondBg.gotoAndStop(_mountsInfo.diamond+1);
		}
		public static function getMountsName(name:String):BitmapData
		{
			switch(name)
			{
				case "飞剑":
					return new MountsNameAsset0() as BitmapData;
				case "神雕":
					return new MountsNameAsset1() as BitmapData;
				case "凤凰":
					return new MountsNameAsset2() as BitmapData;
			}
			return null;
		}
		private function getTransform(index:int):String
		{
			var st:String = "";
			switch (index)
			{
				case 0:
					st = LanguageManager.getWord("ssztl.mounts.transform","<font color='#FFFCCC'>20%</font>")
					break;
				case 1:
					st = LanguageManager.getWord("ssztl.mounts.transform","<font color='#00cc00'>40%</font>")
					break;
				case 2:
					st = LanguageManager.getWord("ssztl.mounts.transform","<font color='#00ccff'>60%</font>")
					break;
				case 3:
					st = LanguageManager.getWord("ssztl.mounts.transform","<font color='#cc00ff'>80%</font>")
					break;
				case 4:
					st = LanguageManager.getWord("ssztl.mounts.transform","<font color='#ff9900'>100%</font>")
					break;
			}
			return st;
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			_mountsBg.bitmapData = AssetUtil.getAsset('ssztui.pet.PetBgAsset',BitmapData) as BitmapData;
			var view:IMountsView;
			for each(view in _panels)
			{
				view.assetsCompleteHandler();
			}
		}		
		
		private function onExpUpdateHandler(evt:MountsItemInfoUpdateEvent):void
		{
			onExpUpdate(evt.data.exp,evt.data.level);
			
		}
		
		private function onExpUpdate(argexp:Number,arglevel:int):void
		{
			var exp:Number = 0;
			var total:Number = 0;
			var tem:MountsUpgradeTemplate = MountsUpgradeTemplateList.getMountsUpgradeTemplate(arglevel+1);
			var tem1:MountsUpgradeTemplate = MountsUpgradeTemplateList.getMountsUpgradeTemplate(arglevel);
				
			if(tem && tem1)
			{
				exp = argexp - tem1.totalExp;
				total = tem.totalExp - tem1.totalExp;
			}
			else if(tem1)
			{
				exp = argexp - tem1.totalExp;
				total = tem1.exp;
			}
			_progressBar.setValue(total,exp);
			_textExp.setValue(LanguageManager.getWord("ssztl.common.experience")+ "："+exp+"/"+total);
		}
		
		private function changeBtn(state:int):void
		{
			if(state == 1)
			{
				_fightBtn.visible = false;
				_restBtn.visible = true;
			}
			else
			{
				_fightBtn.visible = true;
				_restBtn.visible = false;
			}
		}
		private function btnClickHandler(evt:MouseEvent):void
		{
			if(!leftPanel.currentItem) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var id:Number = leftPanel.currentItem.mountsInfo.id;
			var index:int = _btns.indexOf(evt.currentTarget);
			switch (index)
			{
				case 0:
					SetModuleUtils.addMounts( new ToMountsData(0,1));
					break;
				case 1:
					MountsStateChangeSocketHandler.send(id,0);	
					break;
				case 2:
					MountsStateChangeSocketHandler.send(id,1);
					break;
				case 3:
					//trace('进阶');
					_mediator.initUpgradeQualityLevelPanel();
					break;
				case 4:
					//trace('进化');
					_mediator.initEvolutionPanel();
					break;
				case 5:
					//trace('提升');
					_mediator.initUpgradeIntelligencePanel();
					break;
				case 6:
					_mediator.initShowMountDevelop();
					break;
				case 7:
					//trace('洗练');			
					if(GlobalData.selfPlayer.level < 35)
						QuickTips.show(LanguageManager.getWord("ssztl.mounts.refinedLevel"));
					else
						_mediator.initRefinedPanel();
					break;
			}
		}
		private function linkClickHandler(evt:TextEvent):void
		{
			var currentPetId:Number = leftPanel.currentItem.mountsInfo.id;
			var argument:String = evt.text;
			if(argument == "0")	//放生
			{
				sureRelease(currentPetId);
			}else if(argument == "1")	//展示
			{
				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_MOUNT,leftPanel.currentItem.mountsInfo));
			}else if(argument == "2")	//预览
			{
				_mediator.initShowMountDevelop();
			}
		}
		
		private function sureRelease(id:int):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.mounts.beCarefully"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,function(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
					MountsReleaseSocketHandler.send(id);
			});
		}
		
//		private function styleUpdateHandler(evt:MountsItemInfoUpdateEvent):void
//		{
//			updateCharacter();
//		}
		
		private function updateCharacter():void
		{
			if(_character){_character.dispose();_character = null;}
			if(_currentIndex == 2 || _currentIndex == 3) return;
			if(_mountsInfo)
			{
				_character = GlobalAPI.characterManager.createShowMountsOnlyCharacter( _mountsInfo);
				_character.setMouseEnabeld(false);
				_character.show(DirectType.BOTTOM);
				addContent(_character as DisplayObject);
				
				switch(_currentIndex)
				{
					case 0:
						_character.move(321,155);
						break;
					case 1:
						_character.move(394,155);
						break;
				}
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_mediator.module.mountsFeedPanel)
			{
				_mediator.module.mountsFeedPanel.dispose();
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_imageContainer = null;
			_nameLabel = null;
			_stairsLabel = null;
			_levelLabel = null;
			_growLabel = null;
			_refinedLabel = null;
			_speedeLabel = null;
			_qualityLabel = null;
			_fightLabel = null;
			_hpLabel = null;
			_mpLabel = null;
			_attackLabel = null;
			_defLabel = null;
			_attackLabel1 = null;
			_magicDefenceLabel = null;
			_farDefenceLabel = null;
			_mumpDefenceLabel = null;
			_tipLabel = null;
			if(_progressBar)
			{
				_progressBar.dispose();
				_progressBar = null;
			}
			
			if(_mountsBg && _mountsBg.bitmapData)
			{
				_mountsBg.bitmapData.dispose();
				_mountsBg = null;
			}
			if(_diamondBg && _diamondBg.bitmapData)
			{
				_diamondBg.bitmapData.dispose();
				_diamondBg = null;
			}
			if(_starBg && _starBg.bitmapData)
			{
				_starBg.bitmapData.dispose();
				_starBg = null;
			}
			
			for(var i:int= 0 ;i < _btns.length ; ++i)
			{
				if(_btns[i])
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
			}
			_tipBgList = null; 
			_btns = null;
			
			_mediator = null;
			if(leftPanel)
			{
				leftPanel.dispose();
				leftPanel = null;
			}
			if(_mountsInfo)
			{
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.CHANGE_STATE,stateChangeHandler);
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
				_mountsInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE,onUpdateHandler);
				_mountsInfo = null;
			}
			if(_nameTxtImg && _nameTxtImg.bitmapData)
			{
				_nameTxtImg.bitmapData.dispose();
				_nameTxtImg = null;
			}
			_btnRefinedMask = null;
			_preview = null;
			_textExp = null;
			_labelInfo = null;
			_labelAtt = null;
			_txtLink = null;
			if(_character){_character.dispose();_character = null;}
			super.dispose();
		}
	}
	
	
}