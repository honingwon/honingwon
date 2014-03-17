package sszt.mounts.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsUpgradeTemplate;
	import sszt.core.data.mounts.MountsUpgradeTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.tips.MountsDiamondTip;
	import sszt.core.view.tips.MountsStarLevelTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mounts.component.cells.MountsShowMountSkillCell;
	import sszt.mounts.mediator.MountsMediator;
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
	import ssztui.pet.MountsNameAsset0;
	import ssztui.pet.MountsNameAsset1;
	import ssztui.pet.TitleMountAsset;
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressTrack3Asset;
	import ssztui.ui.SplitCompartLine2;
	
	
	public class MountShowPanel extends MPanel
	{
		public static const SKILL_CELL_AMOUNT:int = 12;
		
		private var _mediator:MountsMediator;
		private var _mountItemInfo:MountsItemInfo;
		
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _showBg:Bitmap;
		
		private var _txtName:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _txtStairs:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtExp:MAssetLabel;
		private var _txtGrow:MAssetLabel;
		private var _txtSpeed:MAssetLabel;
		private var _txtHp:MAssetLabel;
		private var _txtAttrAttack:MAssetLabel;
		private var _txtMagic:MAssetLabel;
		private var _txtMagicDefence:MAssetLabel;
		private var _txtAttack:MAssetLabel;
		private var _txtFarDefence:MAssetLabel;
		private var _txtDefense:MAssetLabel;
		private var _txtMumpDefence:MAssetLabel;
		private var _expProgressBar:ProgressBar1;
		private var _txtFight:MAssetLabel;
		
		private var _skillTile:MTile;
		private var _skillCells:Array;
		
		private var _characterCon:MSprite;
		private var _character:ICharacter;
		
		private var _petBaseInfoContainer:MountsInfoView;
		private var _nameTxtImg:Bitmap;
		
		private var _starBg:MovieClip;
		private var _diamondBg:MovieClip;
		private var _tipBgList:Array;
		
		public function MountShowPanel(mediator:MountsMediator)
		{
			super(new MCacheTitle1("",new Bitmap(new TitleMountAsset())), true,-1);
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
			_characterCon.move(172,155-29);
			_characterCon.mouseEnabled = false;
			_characterCon.mouseChildren = false;
			addContent(_characterCon);
			
			_petBaseInfoContainer = new MountsInfoView();
			_petBaseInfoContainer.move(12,6);
			addContent(_petBaseInfoContainer);
			
			/** 信息标签　*/
			var _labelInfo:MAssetLabel = _labelInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelInfo.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
			_labelInfo.move(331,38);
//			_petBaseInfoContainer.addChild(_labelInfo);
			_labelInfo.setValue(
				LanguageManager.getWord("ssztl.common.level")+ "：\n" +
				LanguageManager.getWord("ssztl.common.speed")+ "：\n" +
				LanguageManager.getWord("ssztl.sword.qualityLevel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.qualityLabel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.growLabel")+ "：\n" +
				LanguageManager.getWord("ssztl.common.refinedLabel")+ "："
			);
			/** 属性标签　*/
			var _labelAtt:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_labelAtt.setLabelType([new TextFormat("SimSun",12,0xd9ad60,null,null,null,null,null,null,null,null,null,8)]);
//			_petBaseInfoContainer.addChild(_labelAtt);
			_labelAtt.move(331,186);
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
			
			_bg2 = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(43,262,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(43,301,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2,248,315,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(320,153,140,15),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(358,160,66,16),new Bitmap(new BaseAttrTitleAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(19,227,282,22),new Bitmap(new ExpTrackAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(331,38,50,100),_labelInfo),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(331,186,50,150),_labelAtt),
			]); 
			_petBaseInfoContainer.addChild(_bg2 as DisplayObject);
			
			_nameTxtImg = new Bitmap();
			_nameTxtImg.x = 368;
			_nameTxtImg.y = 12;
			_petBaseInfoContainer.addChild(_nameTxtImg);
			
			_txtName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtName.move(54,174);
//			addContent(_txtName);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelLabel.move(367,38);
			_petBaseInfoContainer.addChild(_levelLabel);
			
			_txtSpeed = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_txtSpeed.move(367,58);
			_petBaseInfoContainer.addChild(_txtSpeed);
			
			_txtStairs = new MAssetLabel("",MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_txtStairs.move(367,78);
			_petBaseInfoContainer.addChild(_txtStairs);
			
			_txtQuality = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtQuality.move(367,98);
			_petBaseInfoContainer.addChild(_txtQuality);
			
			_txtGrow = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtGrow.move(367,118);
			_petBaseInfoContainer.addChild(_txtGrow);
			
			_expProgressBar = new ProgressBar1(new Bitmap(new ExpBarAsset() as BitmapData),0,0,232,13,false,false);
			_expProgressBar.move(44,232);
			_petBaseInfoContainer.addChild(_expProgressBar);
			
			_txtExp = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_txtExp.move(160,230);
			_petBaseInfoContainer.addChild(_txtExp);
			_txtExp.setValue(LanguageManager.getWord("ssztl.common.experience")+ "：0/0");
			
			_txtFight = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14);
			_txtFight.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),14,0xff9900)]);
			_txtFight.move(160,200);
			_petBaseInfoContainer.addChild(_txtFight);
			
			//属性
			_txtHp = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtHp.move(367,186);
			_petBaseInfoContainer.addChild(_txtHp);
			
			_txtMagic = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtMagic.move(367,206);
			_petBaseInfoContainer.addChild(_txtMagic);
			
			_txtAttack = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtAttack.move(367,226);
			_petBaseInfoContainer.addChild(_txtAttack);
			
			_txtDefense = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtDefense.move(367,246);
			_petBaseInfoContainer.addChild(_txtDefense);
			
			_txtAttrAttack = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtAttrAttack.move(367,266);
			_petBaseInfoContainer.addChild(_txtAttrAttack);
			
			_txtMagicDefence = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtMagicDefence.move(367,286);
			_petBaseInfoContainer.addChild(_txtMagicDefence);
			
			_txtFarDefence = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtFarDefence.move(367,306);
			_petBaseInfoContainer.addChild(_txtFarDefence);
			
			_txtMumpDefence = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtMumpDefence.move(367,326);
			_petBaseInfoContainer.addChild(_txtMumpDefence);
			
			_skillCells = [];
			_skillTile = new MTile(38,38,6);
			_skillTile.setSize(39*6, 39*2);
			_skillTile.itemGapW = _skillTile.itemGapH = 0;
			_skillTile.move(43,262);
			_skillTile.horizontalScrollPolicy = _skillTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_petBaseInfoContainer.addChild(_skillTile);
			
			for(var i:int = 0; i < SKILL_CELL_AMOUNT; i++)
			{
				var skillCell:MountsShowMountSkillCell = new MountsShowMountSkillCell();
				_skillTile.appendItem(skillCell);
				_skillCells.push(skillCell);
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
			for(var j:int = 0 ;j< _tipBgList.length ; ++j)
			{
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
				_tipBgList[j].removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			}
		}
		private function overHandler(evt:MouseEvent):void
		{
			if(!_mountItemInfo) return;
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			var template_id:int = this._mountItemInfo.templateId;
			var star_level:int = this._mountItemInfo.star;
			var diamond:int = this._mountItemInfo.diamond;
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
		
		public function set mountItemInfo(value:MountsItemInfo):void
		{
			_mountItemInfo = value;
//			_txtName.setValue(_mountItemInfo.nick + ' ' + LanguageManager.getWord('ssztl.common.levelValue',_mountItemInfo.level));
//			_txtName.setHtmlValue(
//				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_mountItemInfo.templateId).quality) +"'>" + _mountItemInfo.nick + "</font> " +
//				LanguageManager.getWord('ssztl.common.levelValue',_mountItemInfo.level)
//			);
			_nameTxtImg.bitmapData = getMountsName(_mountItemInfo.nick);
			_levelLabel.setValue(_mountItemInfo.level.toString());
			_txtFight.setValue(LanguageManager.getWord('ssztl.common.fightValue') + '：' + _mountItemInfo.fight.toString());
			_txtStairs.setValue(LanguageManager.getWord("ssztl.mounts.stairsValue",_mountItemInfo.stairs));
			_txtQuality.setValue(_mountItemInfo.quality + "/" + _mountItemInfo.upQuality);
			setExp(_mountItemInfo.exp,_mountItemInfo.level)
			_txtGrow.setValue(_mountItemInfo.grow + "/" + _mountItemInfo.upGrow);
			_txtSpeed.setValue(_mountItemInfo.speed + '%');
			
			_txtHp.htmlText = _mountItemInfo.hp + (_mountItemInfo.hp1>0?"<font color='#66ff00'> +" + _mountItemInfo.hp1 + "</font>":"");
			_txtMagic.htmlText = _mountItemInfo.mp + (_mountItemInfo.mp1>0?"<font color='#66ff00'> +" + _mountItemInfo.mp1 + "</font>":"");
			_txtAttack.htmlText = _mountItemInfo.attack + (_mountItemInfo.attack1>0?"<font color='#66ff00'> +" + _mountItemInfo.attack1 + "</font>":"");
			_txtDefense.htmlText = _mountItemInfo.defence + (_mountItemInfo.defence1>0?"<font color='#66ff00'> +" + _mountItemInfo.defence1 + "</font>":"");
			
			_txtAttrAttack.htmlText = 
				(_mountItemInfo.farAttack + _mountItemInfo.magicAttack + _mountItemInfo.mumpAttack) + 
				((_mountItemInfo.farAttack1 + _mountItemInfo.magicAttack1 + _mountItemInfo.mumpAttack1)>0?"<font color='#66ff00'> +" + (_mountItemInfo.farAttack1 + _mountItemInfo.magicAttack1 + _mountItemInfo.mumpAttack1) + "</font>":"");
			_txtMagicDefence.htmlText = _mountItemInfo.magicDefence + (_mountItemInfo.magicDefence1>0?"<font color='#66ff00'> +" + _mountItemInfo.magicDefence1 + "</font>":"");
			_txtFarDefence.htmlText = _mountItemInfo.farDefence + (_mountItemInfo.farDefence1>0?"<font color='#66ff00'> +" + _mountItemInfo.farDefence1 + "</font>":"");
			_txtMumpDefence.htmlText = _mountItemInfo.mumpDefence + (_mountItemInfo.mumpDefence1>0?"<font color='#66ff00'> +" + _mountItemInfo.mumpDefence1 + "</font>":"");
			
			var skills:Array = _mountItemInfo.skillList;
			for(var i:int = 0; i < skills.length; i++)
			{
				MountsShowMountSkillCell(_skillCells[i]).skillInfo = skills[i];
			}
			
			if(_mountItemInfo.star>-1) _starBg.gotoAndStop(_mountItemInfo.star+1);
			if(_mountItemInfo.diamond>-1) _diamondBg.gotoAndStop(_mountItemInfo.diamond+1);
			updateCharacter();
		}
		
		public static function getMountsName(name:String):BitmapData
		{
			switch(name)
			{
				case "飞剑":
					return new MountsNameAsset0() as BitmapData;
				case "神雕":
					return new MountsNameAsset1() as BitmapData;
			}
			return null;
		}
		
		private function setExp(argexp:Number, arglevel:int):void
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
//			_txtExp.setValue(exp + '/' + total);
			_txtExp.setValue(LanguageManager.getWord("ssztl.common.experience")+ "：" + exp + '/' + total);
			_expProgressBar.setValue(total,exp);
		}
		
		public function clear():void
		{
			_txtName.setValue('-');
			_txtFight.setValue("");
			_txtStairs.setValue('-');
			_txtQuality.setValue('-');
			_txtExp.setValue('');
			_expProgressBar.setValue(0,0);
			_txtGrow.setValue('-');
			_txtSpeed.setValue('-');
			_txtHp.htmlText = '';
			_txtAttrAttack.htmlText = '';
			_txtMagic.htmlText = '';
			_txtMagicDefence.htmlText = '';
			_txtAttack.htmlText = '';
			_txtFarDefence.htmlText = '';
			_txtDefense.htmlText = '';
			_txtMumpDefence.htmlText = '';
			
			for(var i:int = 0; i < SKILL_CELL_AMOUNT; i++)
			{
				MountsShowMountSkillCell(_skillCells[i]).skillInfo = null;
			}
		}
		
		public function assetsCompleteHandler():void
		{
			_showBg.bitmapData = AssetUtil.getAsset('ssztui.pet.PetBgAsset',BitmapData) as BitmapData;
		}
		
		private function updateCharacter():void
		{
			if(_character){_character.dispose();_character = null;}
			
			if(_mountItemInfo)
			{
				_character = GlobalAPI.characterManager.createShowMountsOnlyCharacter(_mountItemInfo);
				_character.setMouseEnabeld(false);
				_character.show(DirectType.BOTTOM);
//				_character.move(132,80);
				_characterCon.addChild(_character as DisplayObject);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			_mediator = null;
			if(_mountItemInfo)
			{
				_mountItemInfo = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
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
					MountsShowMountSkillCell(_skillCells[i]).dispose();
					_skillCells[i] = null;
				}
				_skillCells = null;
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
			if(_txtExp)
			{
				_txtExp = null;
			}
			if(_txtGrow)
			{
				_txtGrow = null;
			}
			if(_txtSpeed)
			{
				_txtSpeed = null;
			}
			if(_txtHp)
			{
				_txtHp = null;
			}
			if(_txtAttrAttack)
			{
				_txtAttrAttack = null;
			}
			if(_txtMagic)
			{
				_txtMagic = null;
			}
			if(_txtMagicDefence)
			{
				_txtMagicDefence = null;
			}
			if(_txtAttack)
			{
				_txtAttack = null;
			}
			if(_txtFarDefence)
			{
				_txtFarDefence = null;
			}
			if(_txtDefense)
			{
				_txtDefense = null;
			}
			if(_txtMumpDefence)
			{
				_txtMumpDefence = null;
			}
			if(_expProgressBar)
			{
				_expProgressBar.dispose();
				_expProgressBar = null;
			}
			if(_characterCon && _characterCon.parent)
			{
				_characterCon.parent.removeChild(_characterCon);
				_characterCon = null;
			}
			_txtFight = null;
		}
	}
}