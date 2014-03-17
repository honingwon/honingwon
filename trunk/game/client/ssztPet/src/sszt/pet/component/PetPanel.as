package sszt.pet.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DirectType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.PetBagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.pet.PetGrowupExpTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.data.pet.PetQualificationExpTemplateList;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.pet.PetUpgradeTemplateList;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.pet.PetFeedSocketHandler;
	import sszt.core.socketHandlers.pet.PetNameUpdateSocketHandler;
	import sszt.core.socketHandlers.pet.PetReleaseSocketHandler;
	import sszt.core.socketHandlers.pet.PetStateChangeSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.PetDiamondTip;
	import sszt.core.view.tips.PetStarLevelTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ChatModuleEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.pet.component.cells.PetEquipCell;
	import sszt.pet.component.cells.PetEquipCellEmpty;
	import sszt.pet.data.PetStateType;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.pet.util.PetUtil;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.pet.BaseAttrTitleAsset;
	import ssztui.pet.BtnFeedAsset;
	import ssztui.pet.BtnNameModifyAsset;
	import ssztui.pet.BtnPreviewAsset;
	import ssztui.pet.IconDiamondAsset;
	import ssztui.pet.IconStarAsset;
	import ssztui.pet.InfoTitleAsset;
	import ssztui.pet.ItemLockAsset;
	import ssztui.pet.ItemOnAsset;
	import ssztui.pet.TitleAsset;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressTrackAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class PetPanel extends MPanel
	{
		public static const PANEL_WIDTH:int = 636;
		public static const PANEL_HEIGHT:int = 400;
		
		private var _mediator:PetMediator;
		private var _toPetData:ToPetData;
		private var _cPetInfo:PetItemInfo;
		
		private var _bgBase:IMovieWrapper;
		private var _bg:IMovieWrapper;
		private var _petBg:Bitmap;
		
		private var _petListView:PetListView;
		private var _petBaseInfoContainer:PetInfoView;
		
		private var _labelInfo:MAssetLabel;
		private var _labelAtt:MAssetLabel;
		private var _nameLabel:TextField;
		private var _stairsLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _growLabel:MAssetLabel;
		private var _qualityLabel:MAssetLabel;
		private var _attackTypeLabel:MAssetLabel;
		private var _attackLabel:MAssetLabel;
		private var _hitLabel:MAssetLabel;
		private var _attrAttackLabel:MAssetLabel;
		private var _powerAttackLabel:MAssetLabel;
		/**
		 * 提升 
		 */		
		private var _qualityBtn:MCacheAssetBtn1;
		/**
		 * 进化 
		 */		
		private var _growBtn:MCacheAssetBtn1;
		/**
		 * 进阶 
		 */		
		private var _stairsBtn:MCacheAssetBtn1;
		private var _fightBtn:MCacheAssetBtn1;
		private var _restBtn:MCacheAssetBtn1;
		private var _renameBtn1:MBitmapButton;
		private var _feedBtn1:MBitmapButton;
		private var _xisuBtn1:MCacheAssetBtn1;
		
		private var _txtLink:MAssetLabel;
//		private var _energyProgressBg:BarAsset7;
//		private var _growExpProgressBg:BarAsset7;
//		private var _qualityExpProgressBg:BarAsset7;
//		private var _expProgressBg:BarAsset7;
		private var _energyProgressBar:ProgressBar;
		private var _growExpProgressBar:ProgressBar;
		private var _qualityProgressBar:ProgressBar;
		private var _expProgressBar:ProgressBar;
		
		private var _btns:Array;
		private var _tabBtns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		
		private var _character:ICharacter;
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _tipBgList:Array;
		private var _preview:MAssetButton1;
		
		private var _equipCellTile:MTile;
		private var _equipCellList:Array;
		private var _petEquipCellEmpty:PetEquipCellEmpty;
		
		private var _assetsComplete:Boolean;
		
		private var _petEquipCellDoubleClickHandler:Function;
		private var _btnExstore:MCacheAssetBtn1;
		private var _btnFurnace:MCacheAssetBtn1;
		
		public function PetPanel(mediator:PetMediator,toPetData:ToPetData,petEquipCellDoubleClickHandler:Function)
		{
			_mediator = mediator;
			_toPetData = toPetData;
			_petEquipCellDoubleClickHandler = petEquipCellDoubleClickHandler;
			_cPetInfo = _mediator.module.petsInfo.currentPetItemInfo = PetUtil.getSelectedPetDefault();
			super(new MCacheTitle1("", new Bitmap(new TitleAsset())), true,-1,true,true);
			
			if(_cPetInfo)
			{
				setData();
			}
			initEvent();
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.PET));
			
			if(_toPetData)setIndex(_toPetData.tabIndex);
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
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(PANEL_WIDTH,PANEL_HEIGHT);
			
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
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,14,50,50),new Bitmap(new ItemOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,84,50,50),new Bitmap(new ItemOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,154,50,50),new Bitmap(new ItemOnAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,224,50,50),new Bitmap(new ItemLockAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,294,50,50),new Bitmap(new ItemLockAsset()))
			]); 
			addContent(_bgBase as DisplayObject);
			
			_petListView = new PetListView(_mediator, _cPetInfo);
			_petListView.move(12,4);
			addContent(_petListView);
			
			_petBaseInfoContainer = new PetInfoView();
			_petBaseInfoContainer.move(161,29);
			addContent(_petBaseInfoContainer);
			
			var _tabLabels:Array = [
				LanguageManager.getWord('ssztl.common.pet'),
				LanguageManager.getWord('ssztl.common.stairs'),
				LanguageManager.getWord('ssztl.common.skill'),
				LanguageManager.getWord('ssztl.pet.inherit'),
			];
			_classes = [PetInfoView,PetStairsView,PetSkillView,PetInheritView];
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
			
			_petBg = new Bitmap();
			_petBg.x = _petBg.y = 2;
			_petBaseInfoContainer.addChild(_petBg);
			
			var pos:Array = [new Point(20,90),new Point(20,131),new Point(20,172),new Point(261,131),new Point(261,172)];
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2,224,315,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(320,153,140,15),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(358,11,66,16),new Bitmap(new InfoTitleAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(358,160,66,16),new Bitmap(new BaseAttrTitleAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(97,240,153,17),new ProgressTrackAsset()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(97,264,153,17),new ProgressTrackAsset()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(47,240,30,15),new MAssetLabel(LanguageManager.getWord("ssztl.pet.fullDegree")+ "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(59,264,30,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.experience")+ "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[0].x,pos[0].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[1].x,pos[1].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[2].x,pos[2].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[3].x,pos[3].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[4].x,pos[4].y,38,38),new Bitmap(CellCaches.getCellBg())),
				
			]); 
			_petBaseInfoContainer.addChild(_bg as DisplayObject);
			
			/** 信息标签　*/
			_labelInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelInfo.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_labelInfo.move(331,38);
			_petBaseInfoContainer.addChild(_labelInfo);
			_labelInfo.setValue(
				LanguageManager.getWord("ssztl.common.name")+ "：\n" +
				LanguageManager.getWord("ssztl.common.level")+ "：\n" +
				LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.qualityLabel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.growLabel")+ "："
			);
			/** 属性标签　*/
			_labelAtt = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelAtt.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_petBaseInfoContainer.addChild(_labelAtt);
			_labelAtt.move(331,186);
			_labelAtt.setValue(
				LanguageManager.getWord("ssztl.pet.attackType")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.attack")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.attrAttack")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.hit")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.powerAttack")+ "："
			);
			
			_nameLabel = new TextField();
			_nameLabel.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_nameLabel.type = TextFieldType.INPUT;
			_nameLabel.text = "";
			_nameLabel.x = 367;
			_nameLabel.y = 38;
			_nameLabel.width = 115;
			_nameLabel.height = 20;
			_nameLabel.maxChars  = 14;
			_petBaseInfoContainer.addChild(_nameLabel);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelLabel.move(367,58);
			_petBaseInfoContainer.addChild(_levelLabel);
			
			_stairsLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_stairsLabel.move(367,78);
			_petBaseInfoContainer.addChild(_stairsLabel);
			
			_qualityLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_qualityLabel.move(367,98);
			_petBaseInfoContainer.addChild(_qualityLabel);
			
			_growLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_growLabel.move(367,118);
			_petBaseInfoContainer.addChild(_growLabel);
			
//			_expLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
//			_expLabel.move(600,117);
//			_petBaseInfoContainer.addChild(_expLabel);
			
			_attackTypeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_attackTypeLabel.move(392,186);
			_petBaseInfoContainer.addChild(_attackTypeLabel);
			
			_attackLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_attackLabel.move(367,206);
			_petBaseInfoContainer.addChild(_attackLabel);
			
			_attrAttackLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_attrAttackLabel.move(367,226);
			_petBaseInfoContainer.addChild(_attrAttackLabel);
			
			_hitLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_hitLabel.move(367,246);
			_petBaseInfoContainer.addChild(_hitLabel);
			
			_powerAttackLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_powerAttackLabel.move(367,266);
			_petBaseInfoContainer.addChild(_powerAttackLabel);
			
//			_upBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.upgrade"));
//			_upBtn.move(199,254);
//			_petBaseInfoContainer.addChild(_upBtn);
			
			_restBtn  = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.rest"));
			_restBtn.move(50,305);
			_petBaseInfoContainer.addChild(_restBtn);
			_restBtn.visible = true;
			
			_fightBtn  = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.fight"));
			_fightBtn.move(50,305);
			_petBaseInfoContainer.addChild(_fightBtn);
			_fightBtn.visible = false;
			
			_xisuBtn1  = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.pet.wash"));
			_xisuBtn1.move(358,307);
//			_petBaseInfoContainer.addChild(_xisuBtn1);
			
			_stairsBtn  = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.stairs"));
			_stairsBtn.move(573,90);
//			_petBaseInfoContainer.addChild(_stairsBtn);
			
			_qualityBtn  = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.upgrade1"));
			_qualityBtn.move(420,93);
			_petBaseInfoContainer.addChild(_qualityBtn);
			
			_growBtn  = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.upgrade1"));
			_growBtn.move(420,115);
			_petBaseInfoContainer.addChild(_growBtn);
			
			_renameBtn1  = new MBitmapButton(new BtnNameModifyAsset() as BitmapData);
			_renameBtn1.move(431,36);
			_petBaseInfoContainer.addChild(_renameBtn1);
			
			_feedBtn1  =  new MBitmapButton(new BtnFeedAsset() as BitmapData);
			_feedBtn1.move(263,237);
			_petBaseInfoContainer.addChild(_feedBtn1);

			_energyProgressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset()),0,0,147,11,true,false);
			_energyProgressBar.move(100,243);
			_petBaseInfoContainer.addChild(_energyProgressBar);
			
			_expProgressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset() as BitmapData),0,0,147,11,true,true);
			_expProgressBar.move(100,267);
			_petBaseInfoContainer.addChild(_expProgressBar);
			
			_qualityProgressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset() as BitmapData),0,0,164,9,true,false);
			_qualityProgressBar.move(429,207);
//			_petBaseInfoContainer.addChild(_qualityProgressBar);
			_growExpProgressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset() as BitmapData),0,0,147,11,true,false);
			_growExpProgressBar.move(100,267);
//			_petBaseInfoContainer.addChild(_growExpProgressBar);
			
//			_tipBgList = [];
//			var _poses:Array = [new Point(206,32),new Point(236,32)];
//			for(var i:int = 0;i<_poses.length;i++)
//			{
//				var sprite:Sprite = new Sprite();
//				sprite.graphics.beginFill(0,0);
//				sprite.graphics.drawCircle(_poses[i].x,_poses[i].y,15);
//				sprite.graphics.endFill();
//				_petBaseInfoContainer.addChild(sprite);
//				_tipBgList.push(sprite);
//			}
			
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
			
			_preview = new MAssetButton1(new BtnPreviewAsset() as MovieClip);
			_preview.move(261,55);
			_petBaseInfoContainer.addChild(_preview);
			
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
			
			_equipCellTile = new MTile(50,50,5);
			_equipCellTile.move(0,0);
			_equipCellTile.setSize(250,50);
			_equipCellTile.verticalScrollPolicy = _equipCellTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_equipCellTile.itemGapH = _equipCellTile.itemGapW = 0;
			_petBaseInfoContainer.addChild(_equipCellTile);
			
			_petEquipCellEmpty = new PetEquipCellEmpty(_mediator);
			_petEquipCellEmpty.width = 320;
			_petEquipCellEmpty.height = 225;
			_petBaseInfoContainer.addChild(_petEquipCellEmpty);
			
			_btnExstore = new MCacheAssetBtn1(0,3,'兑换');
			_btnExstore.move(124,305);
			_petBaseInfoContainer.addChild(_btnExstore);
			
			_btnFurnace = new MCacheAssetBtn1(0,3,'打造');
			_btnFurnace.move(198,305);
			_petBaseInfoContainer.addChild(_btnFurnace);
			
			_equipCellList = [];
			var petEquipCell:PetEquipCell;
			for(var j:int = 0; j < 5; j++)
			{
				petEquipCell = new PetEquipCell(null,_petEquipCellDoubleClickHandler);
				petEquipCell.move(pos[j].x,pos[j].y);
				_petBaseInfoContainer.addChild(petEquipCell);
//				_equipCellTile.appendItem(petEquipCell);
				_equipCellList.push(petEquipCell);
				petEquipCell.addEventListener(MouseEvent.CLICK,petEquipCellClickHandler);
				
				petEquipCell.addEventListener(MouseEvent.MOUSE_DOWN,petEquipCellDownHandler);
			}
		}
		
		protected function petEquipCellDownHandler(e:MouseEvent):void
		{
			var petEquipCell:PetEquipCell = e.currentTarget as PetEquipCell;
			if(petEquipCell.itemInfo)
			{
				petEquipCell.dragStart();
			}
		}
		
		private function petEquipCellClickHandler(e:MouseEvent):void
		{
			var cell:PetEquipCell = e.currentTarget as PetEquipCell;
			if(cell.itemInfo)
			{
				var fightPet:PetItemInfo = GlobalData.petList.getFightPet();
				if(!fightPet || fightPet.id != _cPetInfo.id)
				{
					QuickTips.show('对不起，您只能卸下出战宠物身上的装备。');
					return;
				}
				DoubleClickManager.addClick(cell);
			}
		}
		
		private function setData():void
		{
//			_petSkillView.petItemInfo = _cPetInfo;
			
			_nameLabel.text = _cPetInfo.nick;
			_nameLabel.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_cPetInfo.templateId).quality);
			
			updateGrowExp();
			updateQualityExp();
			upgrade();
			updateEnergy();
			updateAttr();
			updateState();
			updateExp();
			
			updateCharacter();
			
			updatePetEquip();
			
//			if(_mediator.module.toPetData && _mediator.module.toPetData.showPanel != -1)
//			{
//				showPanel(_mediator.module.toPetData.showPanel);
//			}
		}
		
		private function updatePetEquip():void
		{
			for each(var item:PetEquipCell in _equipCellList)
			{
				item.itemInfo = null;
			}
			
			var list:Array = GlobalData.petBagInfo.petDic[_cPetInfo.id];
			if(!list) return;
			var itemInfo:ItemInfo;
			for each(itemInfo in list)
			{
				if(itemInfo)
					_equipCellList[itemInfo.place].itemInfo = itemInfo;
			}
		}
		
		protected function petBagInfoUpdateHandler(e:PetBagInfoUpdateEvent):void
		{
			var data:Object = e.data;
			var petId:Number = data.petId;
			if(_cPetInfo.id != petId) return;
			var updateItemPlaceList:Array = data.updateItemPlaceList;
			var itemInfo:ItemInfo;
			for each(var place:int in updateItemPlaceList)
			{
				if(place > 4) return;
				itemInfo = GlobalData.petBagInfo.petDic[petId][place];
				_equipCellList[place].itemInfo = itemInfo;
			}
		}
		
		private function updateAttr():void
		{
			_attackTypeLabel.htmlText = PetUtil.getPetAttrAttackTypeWord(_cPetInfo.type);
			
			_stairsLabel.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",_cPetInfo.stairs));
			_growLabel.setValue(_cPetInfo.grow + "/" + _cPetInfo.upGrow);
			_qualityLabel.setValue(_cPetInfo.quality + "/" + _cPetInfo.upQuality);
			
			_attackLabel.htmlText = _cPetInfo.attack + "<font color='#66ff00' > +" + _cPetInfo.attack2 + "</font>";
			_hitLabel.htmlText = _cPetInfo.hit + "<font color='#66ff00' > +" + _cPetInfo.hit2 + "</font>";
			_attrAttackLabel.htmlText = (_cPetInfo.farAttack + _cPetInfo.magicAttack + _cPetInfo.mumpAttack) + 
				"<font color='#66ff00' > +" + 
				(_cPetInfo.farAttack2 + _cPetInfo.magicAttack2 + _cPetInfo.mumpAttack2) + 
				"</font>";
			_powerAttackLabel.htmlText = _cPetInfo.powerHit + "<font color='#66ff00' > +" + _cPetInfo.powerHit2 + "</font>";
			
			if(_cPetInfo.star>-1) _starBg.gotoAndStop(_cPetInfo.star+1);
			if(_cPetInfo.diamond>-1) _diamondBg.gotoAndStop(_cPetInfo.diamond+1);
		}
		
		private function updateEnergy():void
		{
			_energyProgressBar.setValue(100,_cPetInfo.energy);
		}
		
		private function upgrade():void
		{
			_levelLabel.setValue(_cPetInfo.level.toString());
		}
		
		private function updateGrowExp():void
		{
			if(_cPetInfo.grow == PetsInfo.PET_GROW_MAX)
			{
				_growExpProgressBar.setValue(0,0);
			}
			else
			{
				_growExpProgressBar.setValue(
					PetGrowupExpTemplateList.getGrowUpgradeExp(_cPetInfo.grow),
					PetGrowupExpTemplateList.getGrowUpgradeExpGained(_cPetInfo.grow, _cPetInfo.growExp)
				);
			}
		}
		
		private function updateQualityExp():void
		{
			if(_cPetInfo.quality == PetsInfo.PET_QUALITY_MAX)
			{
				_qualityProgressBar.setValue(0,0);
			}
			else
			{
				_qualityProgressBar.setValue(
					PetQualificationExpTemplateList.getQualificationUpgradeExp(_cPetInfo.quality), 
					PetQualificationExpTemplateList.getQualificationUpgradeExpGained(_cPetInfo.quality, _cPetInfo.qualityExp)
				);
			}
		}
		
		private function updateExp():void
		{
			//宠物顶级则显示 0/0  或  0%
			var currentExp:int = 0;
			var needExp:int = 0;
			//如果宠物等级 非顶级
			if(_cPetInfo && PetUpgradeTemplateList.list[_cPetInfo.level + 1])
			{
				needExp = PetUpgradeTemplateList.getMountsUpgradeTemplate(_cPetInfo.level + 1).exp;
				currentExp = _cPetInfo.exp - PetUpgradeTemplateList.getMountsUpgradeTemplate(_cPetInfo.level).totalExp;
			}
			_expProgressBar.setValue(needExp,currentExp);
		}
		
		private function initEvent():void
		{
			_mediator.module.petsInfo.addEventListener(PetEvent.PET_SWITCH, petSwitchHandler);
			
			addPetItemInfoUpdateEventListener();
			
			_txtLink.addEventListener(TextEvent.LINK,linkClickHandler);
			
			_btns = [
				_restBtn, _fightBtn, 
				_stairsBtn, _growBtn, _qualityBtn,
				_renameBtn1, _feedBtn1,_xisuBtn1,
				_preview
			];
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			for(i = 0; i < _tabBtns.length; i++)
			{
				_tabBtns[i].addEventListener(MouseEvent.CLICK, tabBtnClickHandler);
			}
			_feedBtn1.addEventListener(MouseEvent.MOUSE_OVER,feedOverHandler);
			_feedBtn1.addEventListener(MouseEvent.MOUSE_OUT,feedOutHandler);
			
			for(var j:int = 0 ;j< _tipBgList.length ; ++j)
			{
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
			
			_expProgressBar.addEventListener(MouseEvent.MOUSE_OVER,expBarheadOverHandler);
			_expProgressBar.addEventListener(MouseEvent.MOUSE_OUT,expBarheadOutHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
//			_showPet.addEventListener(MouseEvent.CLICK,showPet);
			
			GlobalData.petBagInfo.addEventListener(PetBagInfoUpdateEvent.ITEM_PLACE_UPDATE,petBagInfoUpdateHandler);
			
			_btnExstore.addEventListener(MouseEvent.CLICK,btnExstoreClickHandler);
			_btnFurnace.addEventListener(MouseEvent.CLICK,btnFurnaceClickHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, petSwitchHandler);
			
			removePetItemInfoUpdateEventListener();
			
			_txtLink.removeEventListener(TextEvent.LINK,linkClickHandler);
			
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			for(i = 0; i < _tabBtns.length; i++)
			{
				_tabBtns[i].removeEventListener(MouseEvent.CLICK, tabBtnClickHandler);
			}
			_feedBtn1.removeEventListener(MouseEvent.MOUSE_OVER,feedOverHandler);
			_feedBtn1.removeEventListener(MouseEvent.MOUSE_OUT,feedOutHandler);
			
			for(var j:int = 0 ;j< _tipBgList.length; ++j)
			{
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
			
			_expProgressBar.addEventListener(MouseEvent.MOUSE_OVER,expBarheadOverHandler);
			_expProgressBar.addEventListener(MouseEvent.MOUSE_OUT,expBarheadOutHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
//			_showPet.removeEventListener(MouseEvent.CLICK,showPet);
			
			GlobalData.petBagInfo.removeEventListener(PetBagInfoUpdateEvent.ITEM_PLACE_UPDATE,petBagInfoUpdateHandler);
			
			_btnExstore.removeEventListener(MouseEvent.CLICK,btnExstoreClickHandler);
			_btnFurnace.removeEventListener(MouseEvent.CLICK,btnFurnaceClickHandler);
		}
		
		protected function btnFurnaceClickHandler(event:MouseEvent):void
		{
			SetModuleUtils.addFurnace();
		}
		
		protected function btnExstoreClickHandler(event:MouseEvent):void
		{
			SetModuleUtils.addExStore(new ToStoreData(ShopID.PET_EQUIP,3)); 
		}
		
		private function showPet(e:MouseEvent):void
		{
//			GlobalAPI.moduleManager.addModule(ModuleType.PET,new ToPetData(0,2,0,0,-1,true));
			
		}
		private function expBarheadOverHandler(e:MouseEvent):void
		{
			//宠物顶级则显示 0/0
			var currentExp:int = 0;
			var needExp:int = 0;
			//如果宠物等级 非顶级
			if(_cPetInfo && PetUpgradeTemplateList.list[_cPetInfo.level + 1])
			{
				needExp = PetUpgradeTemplateList.getMountsUpgradeTemplate(_cPetInfo.level + 1).exp;
				currentExp = _cPetInfo.exp - PetUpgradeTemplateList.getMountsUpgradeTemplate(_cPetInfo.level).totalExp;
			}
			TipsUtil.getInstance().show(
				LanguageManager.getWord("ssztl.common.experience")+"："+currentExp + "/"+ needExp,
				null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function expBarheadOutHandler(event:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
		}		
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.PET)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),_petBaseInfoContainer.addChild);
			}
		}
		
		
		private function overHandler(evt:MouseEvent):void
		{
			if(!_cPetInfo) return;
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			var petType:int = _cPetInfo.type;
			var templateId:int = _cPetInfo.templateId;
			var starLevel:int = _cPetInfo.star;
			var diamond:int = _cPetInfo.diamond;
			var tipStr:String;
			if (index == 0 )
			{
//				PetStarLevelTip.getInstance().showTip(templateId,starLevel,(new Point(evt.stageX,evt.stageY)));
				tipStr = PetStarLevelTip.getInstance().getDataStr(templateId,starLevel);
			}
			else if ( index == 1)
			{
//				PetDiamondTip.getInstance().showTip(petType, templateId, diamond,(new Point(evt.stageX,evt.stageY)));
				tipStr = PetDiamondTip.getInstance().getDataStr(petType, templateId, diamond);
			}
			
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			/*
			if(!_cPetInfo) return;
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			if (index == 0 )
			{
				PetDiamondTip.getInstance().hide();
			}
			else if ( index == 1)
			{
				PetStarLevelTip.getInstance().hide();
			}
			*/
			TipsUtil.getInstance().hide();
			
		}
		
		private function feedOverHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.pet.feedLable"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function feedOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}	
		private function addPetItemInfoUpdateEventListener():void
		{
			if(_cPetInfo)
			{
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE,petUpdateHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.CHANGE_STATE, petStateChangeHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_GROW_EXP,petGrowExpUpdateHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_QUALITY_EXP,petQualityExpUpdateHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.RENAME, petRenameHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_ENERGY, petEnergyUpdateHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPGRADE, petUpgradeHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_STYLE, styleUpdateHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_EXP,updateExpHandler);
			}
		}
		
		private function removePetItemInfoUpdateEventListener():void
		{
			if(_cPetInfo)
			{
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE,petUpdateHandler);
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.CHANGE_STATE, petStateChangeHandler);
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_GROW_EXP,petGrowExpUpdateHandler);
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_QUALITY_EXP,petQualityExpUpdateHandler);
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.RENAME, petRenameHandler);
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_ENERGY, petEnergyUpdateHandler);
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPGRADE, petUpgradeHandler);
				_cPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_STYLE, styleUpdateHandler);
				_cPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_EXP,updateExpHandler);
			}
		}
		
		private function updateState():void
		{
			_fightBtn.visible = _cPetInfo.state == PetStateType.FIGHT ? false : true;
			_restBtn.visible = !_fightBtn.visible;
		}
		
		private function petSwitchHandler(event:PetEvent):void
		{
			removePetItemInfoUpdateEventListener();
			_cPetInfo = null;
			
			_cPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			
			addPetItemInfoUpdateEventListener();
			
			setData();
		}
		
		private function btnClickHandler(event:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_cPetInfo)
			{
				var currentPetId:Number = _cPetInfo.id;
				var index:int = _btns.indexOf(event.currentTarget);
				switch (index)
				{
//					case 0:
//						ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PET, _cPetInfo));
//						break;
//					case 1:
//						sureRelease(currentPetId);
//						break;
					case 0:
						PetStateChangeSocketHandler.send(currentPetId,PetStateType.REST);	
						break;
					case 1:
						PetStateChangeSocketHandler.send(currentPetId,PetStateType.FIGHT);	
						break;
					case 2:
						_mediator.initUpgradeQualityLevelPanel();
						break;
					case 3:
						_mediator.initEvolutionPanel();
						break;
					case 4:
						_mediator.initUpgradeIntelligencePanel();
						break;					
					case 5:
						reName();
						break;
					case 6:
						feed();
						break;
					case 7:
//						_mediator.initXisuPanel();
						setIndex(4);
						break;
					case 8:
						_mediator.initShowPetDevelop();
						break;
				}
			}
		}
		private function linkClickHandler(evt:TextEvent):void
		{
			var currentPetId:Number = _cPetInfo.id;
			var argument:String = evt.text;
			if(argument == "0")	//放生
			{
				sureRelease(currentPetId);
			}else if(argument == "1")	//展示
			{
				ModuleEventDispatcher.dispatchChatEvent(new ChatModuleEvent(ChatModuleEvent.ADD_PET, _cPetInfo));
//			}else if(argument == "2")	//预览
//			{
//				_mediator.initShowPetDevelop();
			}
		}
		private function sureRelease(id:int):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.pet.beCarefully"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,function(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
					PetReleaseSocketHandler.send(id);
			});
		}
		
		private function tabBtnClickHandler(event:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _tabBtns.indexOf(event.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		public function setIndex(index:int):void
		{
//			(_tabViews[_currentIndex] as Sprite).visible = false;
//			(_tabBtns[_currentIndex] as MCacheTabBtn1).selected = false;
//			(_tabViews[index] as Sprite).visible = true;
//			(_tabBtns[index] as MCacheTabBtn1).selected = true;
//			_currentIndex = index;
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
					(_panels[_currentIndex] as IPetView).assetsCompleteHandler();
				}
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
			
			updateCharacter();
		}
		
		private function petStateChangeHandler(event:Event):void
		{
			updateState();
		}
		
		private function petRenameHandler(event:Event):void
		{
//			_petInheritView.updateName();
		}
		
		private function petUpdateHandler(event:Event):void
		{
			//为了更新技能槽开启情况
//			_petSkillView.petItemInfo = _cPetInfo;
			updateAttr();
		}
		
		private function petGrowExpUpdateHandler(event:Event):void
		{
			updateGrowExp();
		}
		
		private function petQualityExpUpdateHandler(event:Event):void
		{
			updateQualityExp();
		}
		
		private function petEnergyUpdateHandler(event:Event):void
		{
			updateEnergy();
		}
		
		private function petUpgradeHandler(e:Event):void
		{
			upgrade();
		}
				
		private function reName():void
		{
			var n:int = WordFilterUtils.checkLen(_nameLabel.text);
			if(n < 4)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.pet.petNameOverMaxLength'));
				return;
			}
			else if(n > 14)
			{
				QuickTips.show(LanguageManager.getWord('ssztl.pet.petNameOverMaxLength'));
				return;
			}
			
			if(!WordFilterUtils.checkNameAllow(_nameLabel.text))
			{
				QuickTips.show(LanguageManager.getWord('ssztl.pet.petNameHasIllegalcharacters'));
				return;
			}
			
			PetNameUpdateSocketHandler.send(_mediator.module.petsInfo.currentPetItemInfo.id, _nameLabel.text);
		}
		
		private function feed():void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.bagInfo.getItemCountById(CategoryType.PET_FOOD) == 0)
			{
				//BuyPanel.getInstance().show([CategoryType.PET_FOOD], new ToStoreData(ShopID.NPC_SHOP));
				SetModuleUtils.addNPCStore(new ToNpcStoreData(ShopID.NPC_SHOP,1,6));
			}
			else
			{
				PetFeedSocketHandler.send(_cPetInfo.id);
			}
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			_petBg.bitmapData = AssetUtil.getAsset('ssztui.pet.PetBgAsset',BitmapData) as BitmapData;
			var view:IPetView;
			for each(view in _panels)
			{
				view.assetsCompleteHandler();
			}
		}
		
		private function styleUpdateHandler(evt:PetItemInfoUpdateEvent):void
		{
			updateCharacter();
		}
		
		private function updateExpHandler(event:Event):void
		{
			updateExp();
		}
		
		private function updateCharacter():void
		{
			if(_character){_character.dispose();_character = null;}
			if(_currentIndex == 2 || _currentIndex == 3) return;
			var tmp:PetTemplateInfo;
			if(_cPetInfo)
			{
				if(_cPetInfo.styleId == 0 || _cPetInfo.styleId == -1)
				{
					tmp = _cPetInfo.template;
				}
				else
				{
					tmp = PetTemplateList.getPet(_cPetInfo.styleId);
					if(!tmp)tmp = _cPetInfo.template;
				}
				_character = GlobalAPI.characterManager.createPetCharacter( tmp);
				_character.setMouseEnabeld(false);
				_character.show(DirectType.BOTTOM);
				addContent(_character as DisplayObject);
				
				switch(_currentIndex)
				{
					case 0:
						_character.move(321,185);
						break;
					case 1:
						_character.move(394,185);
						break;
					case 4:
						_character.move(394,185);
						break;
				}
			}
		}
		
		override public function dispose():void
		{
			var petEquipCell:PetEquipCell;
			for(var i:int = 0; i < 5; i++)
			{
				petEquipCell = _equipCellList[i];
				petEquipCell.removeEventListener(MouseEvent.CLICK,petEquipCellClickHandler);
				petEquipCell.removeEventListener(MouseEvent.MOUSE_DOWN,petEquipCellDownHandler);
			}
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgBase)
			{
				_bgBase.dispose();
				_bgBase = null;
			}
			_preview = null;
			_labelInfo = null;
			_labelAtt = null;
			_txtLink = null;
			_txtLink = null;
			super.dispose();
		}
	}
}