package sszt.pet.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetGrowupExpTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetQualificationExpTemplateList;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.tips.PetDiamondTip;
	import sszt.core.view.tips.PetStarLevelTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.pet.component.cells.PetEquipCell;
	import sszt.pet.component.cells.PetEquipCellEmpty;
	import sszt.pet.component.cells.PetSkillCell;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.mediator.PetMediator;
	import sszt.pet.util.PetUtil;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.pet.BaseAttrTitleAsset;
	import ssztui.pet.ExpBarAsset;
	import ssztui.pet.ExpTrackAsset;
	import ssztui.pet.IconDiamondAsset;
	import ssztui.pet.IconStarAsset;
	import ssztui.pet.InfoTitleAsset;
	import ssztui.pet.TitleAsset;
	import ssztui.ui.ProgressBarGreen;
	import ssztui.ui.SplitCompartLine2;
	
	public class PetShowPanel extends MPanel
	{
		private var _mediator:PetMediator;
		private var _petItemInfo:PetItemInfo;
		
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _showBg:Bitmap;
		private var _txtName:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _txtStairs:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtGrow:MAssetLabel;
		private var _txtFight:MAssetLabel;
		
		private var _attackTypeLabel:MAssetLabel;
		private var _attackLabel:MAssetLabel;
		private var _hitLabel:MAssetLabel;
		private var _attrAttackLabel:MAssetLabel;
		private var _powerAttackLabel:MAssetLabel;
		
		private var _energyProgressBar:ProgressBar1;
		private var _growExpProgressBar:ProgressBar;
		private var _qualityProgressBar:ProgressBar;
		
		private var _skillTile:MTile;
		private var _skillCells:Array;
		
		private var _characterCon:MSprite;
		private var _character:ICharacter;
		private var _petBaseInfoContainer:PetInfoView;
		
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _tipBgList:Array;
		
		private var _equipCellTile:MTile;
		private var _equipCellList:Array;
		private var _petEquipCellEmpty:PetEquipCellEmpty;
		
		public function PetShowPanel(mediator:PetMediator)
		{
			super(new MCacheTitle1("", new Bitmap(new TitleAsset())), true,-1);
			_mediator = mediator;
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(487,377);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 2, 471, 367)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(12, 6, 463, 349)),
			]);
			addContent(_bg as DisplayObject);
			
			_showBg = new Bitmap();
			_showBg.x = 14;
			_showBg.y = 8;
			addContent(_showBg);
			
			_characterCon = new MSprite();
			_characterCon.move(172,155);
			_characterCon.mouseEnabled = false;
			_characterCon.mouseChildren = false;
			addContent(_characterCon);
			
			_petBaseInfoContainer = new PetInfoView();
			_petBaseInfoContainer.move(12,6);
			addContent(_petBaseInfoContainer);
			
			/** 信息标签　*/
			var _labelInfo:MAssetLabel = _labelInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelInfo.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_labelInfo.move(331,38);
			_labelInfo.setValue(
				LanguageManager.getWord("ssztl.common.name")+ "：\n" +
				LanguageManager.getWord("ssztl.common.level")+ "：\n" +
				LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.qualityLabel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.growLabel")+ "："
			);
			/** 属性标签　*/
			var _labelAtt:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelAtt.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_labelAtt.move(331,186);
			_labelAtt.setValue(
				LanguageManager.getWord("ssztl.pet.attackType")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.attack")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.attrAttack")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.hit")+ "：\n" +
				LanguageManager.getWord("ssztl.pet.powerAttack")+ "："
			);
			
			var pos:Array = [new Point(20,90),new Point(20,131),new Point(20,172),new Point(261,131),new Point(261,172)];
			_bg2 = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(43,262,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(43,301,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2,248,315,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(320,153,140,15),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(358,11,66,16),new Bitmap(new InfoTitleAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(358,160,66,16),new Bitmap(new BaseAttrTitleAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(19,227,282,22),new Bitmap(new ExpTrackAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(331,38,50,100),_labelInfo),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(331,186,50,150),_labelAtt),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[0].x,pos[0].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[1].x,pos[1].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[2].x,pos[2].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[3].x,pos[3].y,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pos[4].x,pos[4].y,38,38),new Bitmap(CellCaches.getCellBg()))
			]); 
			_petBaseInfoContainer.addChild(_bg2 as DisplayObject);
			
			_txtName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtName.move(367,38);
			_petBaseInfoContainer.addChild(_txtName);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelLabel.move(367,58);
			_petBaseInfoContainer.addChild(_levelLabel);
			
			_txtStairs = new MAssetLabel("",MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_txtStairs.move(367,78);
			_petBaseInfoContainer.addChild(_txtStairs);
			
			_txtQuality = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtQuality.move(367,98);
			_petBaseInfoContainer.addChild(_txtQuality);
			
			_txtGrow = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtGrow.move(367,118);
			_petBaseInfoContainer.addChild(_txtGrow);
			
			_qualityProgressBar = new ProgressBar(new ProgressBarGreen(),0,0,77,11,true,false);
			_qualityProgressBar.move(90,213);
//			addContent(_qualityProgressBar);
			
			_growExpProgressBar = new ProgressBar(new ProgressBarGreen(),0,0,77,11,true,false);
			_growExpProgressBar.move(210,194);
//			addContent(_growExpProgressBar);
			
			_txtFight = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14);
			_txtFight.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),14,0xff9900)]);
			_txtFight.move(160,200);
			_petBaseInfoContainer.addChild(_txtFight);
			
			_attackTypeLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_attackTypeLabel.move(392,186);
			_petBaseInfoContainer.addChild(_attackTypeLabel);
			
			_attackLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_attackLabel.move(367,206);
			_petBaseInfoContainer.addChild(_attackLabel);
			
			_hitLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hitLabel.move(367,246);
			_petBaseInfoContainer.addChild(_hitLabel);
			
			_attrAttackLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_attrAttackLabel.move(367,226);
			_petBaseInfoContainer.addChild(_attrAttackLabel);
			
			_powerAttackLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_powerAttackLabel.move(367,266);
			_petBaseInfoContainer.addChild(_powerAttackLabel);
			
			_energyProgressBar = new ProgressBar1(new Bitmap(new ExpBarAsset() as BitmapData),0,0,232,13,false,false);
			_energyProgressBar.move(44,232);
			_petBaseInfoContainer.addChild(_energyProgressBar);
			
			_skillCells = [];
			_skillTile = new MTile(38,38,6);
			_skillTile.setSize(39*6,39*2);
			_skillTile.itemGapW = _skillTile.itemGapW = 0;
			_skillTile.move(43,262);
			_skillTile.horizontalScrollPolicy = _skillTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_petBaseInfoContainer.addChild(_skillTile);
			
			_skillCells = [];
			for(var i:int = 0; i< PetsInfo.PET_SKILL_CELL_NUM_MAX; i++)
			{
				var cell:PetSkillCell = new PetSkillCell(i);
				_skillTile.appendItem(cell);
				_skillCells.push(cell);
				cell.isOpen = true;
			}
			
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
			
			_equipCellList = [];
			var petEquipCell:PetEquipCell;
			for(var j:int = 0; j < 5; j++)
			{
				petEquipCell = new PetEquipCell(null,null);
				petEquipCell.move(pos[j].x,pos[j].y);
				_petBaseInfoContainer.addChild(petEquipCell);
//				_equipCellTile.appendItem(petEquipCell);
				_equipCellList.push(petEquipCell);
			}
		}
		
		private function initEvent():void
		{
			for(var j:int = 0 ;j< _tipBgList.length ; ++j)
			{
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var j:int = 0 ;j< _tipBgList.length; ++j)
			{
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
		}
		private function overHandler(evt:MouseEvent):void
		{
			if(!_petItemInfo) return;
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			var petType:int = _petItemInfo.type;
			var templateId:int = _petItemInfo.templateId;
			var starLevel:int = _petItemInfo.star;
			var diamond:int = _petItemInfo.diamond;
			var tipStr:String;
			if (index == 0 )
			{
				tipStr = PetStarLevelTip.getInstance().getDataStr(templateId,starLevel);
			}
			else if ( index == 1)
			{
				tipStr = PetDiamondTip.getInstance().getDataStr(petType, templateId, diamond);
			}
			
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function set petEquips(list:Array):void
		{
			for each(var item:PetEquipCell in _equipCellList)
			{
				item.itemInfo = null;
			}
			
			if(!list) return;
			var itemInfo:ItemInfo;
			for each(itemInfo in list)
			{
				if(itemInfo)
					_equipCellList[itemInfo.place].itemInfo = itemInfo;
			}
		}
		
		public function set petItemInfo(value:PetItemInfo):void
		{
			if(!value) return;
			_petItemInfo = value;
			
			var skills:Array = _petItemInfo.skillList;
			for(var i:int = 0; i < skills.length; i++)
			{
				PetSkillCell(_skillCells[i]).skillInfo = skills[i];
			}
			
			_txtName.setHtmlValue("<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_petItemInfo.templateId).quality) +"'>" + _petItemInfo.nick + "</font> ");
			_levelLabel.setValue(LanguageManager.getWord('ssztl.common.levelValue',_petItemInfo.level));
			_txtStairs.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",_petItemInfo.stairs));
			_txtQuality.setValue(_petItemInfo.quality + "/" + _petItemInfo.upQuality);
			_txtGrow.setValue(_petItemInfo.grow + "/" + _petItemInfo.upGrow);
			_growExpProgressBar.setValue(
				PetGrowupExpTemplateList.getGrowUpgradeExp(_petItemInfo.grow),
				PetGrowupExpTemplateList.getGrowUpgradeExpGained(_petItemInfo.grow, _petItemInfo.growExp)
			);
			_qualityProgressBar.setValue(
				PetQualificationExpTemplateList.getQualificationUpgradeExp(_petItemInfo.quality), 
				PetQualificationExpTemplateList.getQualificationUpgradeExpGained(_petItemInfo.quality, _petItemInfo.qualityExp)
			);
			_txtFight.setValue(LanguageManager.getWord('ssztl.common.fightValue') + '：' + _petItemInfo.fight.toString());
			_energyProgressBar.setValue(100,_petItemInfo.energy);
			_attackTypeLabel.htmlText = PetUtil.getPetAttrAttackTypeWord(_petItemInfo.type);
			
			_attackLabel.htmlText = _petItemInfo.attack + "<font color='#66ff00' > +" + _petItemInfo.attack2 + "</font>";
			_hitLabel.htmlText = _petItemInfo.hit + "<font color='#66ff00' > +" + _petItemInfo.hit2 + "</font>";
			_attrAttackLabel.htmlText = (_petItemInfo.farAttack + _petItemInfo.magicAttack + _petItemInfo.mumpAttack) + 
				"<font color='#66ff00' > +" + 
				(_petItemInfo.farAttack2 + _petItemInfo.magicAttack2 + _petItemInfo.mumpAttack2) + 
				"</font>";
			_powerAttackLabel.htmlText = _petItemInfo.powerHit + "<font color='#66ff00' > +" + _petItemInfo.powerHit2 + "</font>";
			
			var tmp:PetTemplateInfo;
			if(_petItemInfo)
			{
				if(_petItemInfo.styleId == 0 || _petItemInfo.styleId == -1)
				{
					tmp = _petItemInfo.template;
				}
				else
				{
					tmp = PetTemplateList.getPet(_petItemInfo.styleId);
					if(!tmp)tmp = _petItemInfo.template;
				}
				_character = GlobalAPI.characterManager.createPetCharacter( tmp);
				_character.setMouseEnabeld(false);
				_character.show(DirectType.BOTTOM);
//				_character.move(130,120);
				_characterCon.addChild(_character as DisplayObject);
			}
			
			if(_petItemInfo.star>-1) _starBg.gotoAndStop(_petItemInfo.star+1);
			if(_petItemInfo.diamond>-1) _diamondBg.gotoAndStop(_petItemInfo.diamond+1);
		}
		
		public function clear():void
		{
			_petItemInfo = null;
			
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			
			for(var i:int = 0; i < PetsInfo.PET_SKILL_CELL_NUM_MAX; i++)
			{
				PetSkillCell(_skillCells[i]).skillInfo = null;
			}
			
			_txtName.setValue('-');
			_txtStairs.setValue('-');
			_txtQuality.setValue('-');
			_txtGrow.setValue('-');
			_txtFight.setValue(LanguageManager.getWord('ssztl.common.fightValue') + '：-');
			_attackTypeLabel.htmlText = '';
			_attackLabel.htmlText = '';
			_hitLabel.htmlText = '';
			_attrAttackLabel.htmlText = '';
			_powerAttackLabel.htmlText = '';
			_growExpProgressBar.setValue(0,0);
			_qualityProgressBar.setValue(0,0);
			_energyProgressBar.setValue(0,0);
		}
		public function assetsCompleteHandler():void
		{
			_showBg.bitmapData = AssetUtil.getAsset('ssztui.pet.PetBgAsset',BitmapData) as BitmapData;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			_mediator = null;
			if(_petItemInfo)
			{
				_petItemInfo = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_skillTile)
			{
				_skillTile.dispose();
				_skillTile = null;
			}
			if(_skillCells)
			{
				for(var i:int = 0; i < _skillCells.length; i++)
				{
//					petsShowpetSkillCell(_skillCells[i]).dispose();
					_skillCells[i] = null;
				}
				_skillCells = null;
			}
			if(_showBg && _showBg.bitmapData){
				_showBg.bitmapData.dispose();
				_showBg = null;
			}
			if(_txtName)
			{
				_txtName = null;
			}
			if(_txtStairs)
			{
				_txtStairs = null;
			}
			if(_txtQuality)
			{
				_txtQuality = null;
			}
			if(_txtGrow)
			{
				_txtGrow = null;
			}
			if(_txtFight)
			{
				_txtFight = null;
			}
			if(_attackTypeLabel)
			{
				_attackTypeLabel = null;
			}
			if(_attackLabel)
			{
				_attackLabel = null;
			}
			if(_hitLabel)
			{
				_hitLabel = null;
			}
			if(_attrAttackLabel)
			{
				_attrAttackLabel = null;
			}
			if(_powerAttackLabel)
			{
				_powerAttackLabel = null;
			}
		}
	}
}