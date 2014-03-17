package sszt.role.components
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.constData.DirectType;
	import sszt.constData.PropertyType;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.VipIconCaches;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.equipStrength.EquipStrengthTemplate;
	import sszt.core.data.equipStrength.EquipStrengthTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.role.RoleInfo;
	import sszt.core.data.role.RoleInfoEvents;
	import sszt.core.doubleClicks.DoubleClickManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.HideFashionSocketHandler;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CellEvent;
	import sszt.interfaces.character.ICharacterWrapper;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.role.mediator.RoleMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.role.FightBtnAsset;
	import ssztui.role.FightNumberAsset0;
	import ssztui.role.FightNumberAsset1;
	import ssztui.role.FightNumberAsset2;
	import ssztui.role.FightNumberAsset3;
	import ssztui.role.FightNumberAsset4;
	import ssztui.role.FightNumberAsset5;
	import ssztui.role.FightNumberAsset6;
	import ssztui.role.FightNumberAsset7;
	import ssztui.role.FightNumberAsset8;
	import ssztui.role.FightNumberAsset9;
	import ssztui.role.IconStrengthAsset;
	import ssztui.role.TagBaseAsset;
	import ssztui.role.TagFightAsset;
	import ssztui.ui.ProgressBarHpAsset;
	import ssztui.ui.ProgressBarMpAsset;
	import ssztui.ui.ProgressTrackAsset;

	/**
	 * 角色选项卡
	 * */
	public class CharacterPanel  extends Sprite implements IRolePanelView
	{
		private var _roleMediator:RoleMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _roleBg:Bitmap;
		private var _sideBg:Bitmap;
		private var _eqSitePng:Bitmap;
		private var _pkSitePng:Bitmap;
		private var _fightFireEffect:BaseLoadEffect;
		
		private var _nickTextField:MAssetLabel;
		private var _vipTextField:MAssetLabel;
		private var _leveTextField:MAssetLabel;
		//称号
		private var _titleNameTextField:MAssetLabel;
		//门派
		private var _factionNameTextField:MAssetLabel;
		//帮会
		private var _clubNameTextField:MAssetLabel;
		private var _magicProgressBar:ProgressBar;
		private var _lifeProgressBar:ProgressBar;
		
		private var _attackTextField:MAssetLabel;
		private var _defenseTextField:MAssetLabel;
		private var _hitTargetTextField:MAssetLabel;
		private var _duckTextField:MAssetLabel;
		private var _deligencyTextField:MAssetLabel;
		private var _powerHitTextField:MAssetLabel;
		private var _addOnHurtTextField:MAssetLabel;
		
		private var _vindictiveAttackTextField:MAssetLabel;
		private var _vindictiveDefenseTextField:MAssetLabel;
		private var _magicDefenseTextField:MAssetLabel;
		private var _farDefenseTextField:MAssetLabel;
		
		private var _PKvalueTextField:MAssetLabel;
		private var _increaseFight:MAssetButton1;
//		private var _currentPhysicalTextField:MAssetLabel;
//		private var _lifeExperienceTextField:MAssetLabel;

		/**
		 * 战斗力 
		 */		
		private var _fightTextField:MAssetLabel;
		private var _fightTextBox:MSprite;
		private var _numClass:Array = [FightNumberAsset0,FightNumberAsset1,FightNumberAsset2,FightNumberAsset3,FightNumberAsset4,FightNumberAsset5,FightNumberAsset6,FightNumberAsset7,FightNumberAsset8,FightNumberAsset9];
		private var _fightUpPanelMask:Sprite;
		private var _FightUpPanel:FightUpgradeView;	//提升战斗力
		private var _assetsComplete:Boolean;
		
		private var _roleDetailInfo:DetailPlayerInfo;
		private var _roleBagCellVector:Array = [];
		private var _roleCellEmptyDrag:RoleCellEmpty;
		private var _imageLayout:MSprite;
		private var _character:ICharacterWrapper;
		
		private var _otherAttackLabel:MAssetLabel
		public var rolePlayerId:Number;
		
		private var _tipsLabel:Array;
		private var _tipBgList:Array;
		
//		private var _hideBtn:MCacheAsset1Btn;
		private var _hideCheckBox:CheckBox;
//		private var _vipBg:Bitmap;
		
		private var _strengthBgs:Array;
		private var _strengthEnableBg:BitmapData;
		private var _strengthDisableBg:BitmapData;
		private var _strengthTipsSprites:Array;
		
		private var _strengthIcon:MovieClip;
		private var _strengthText:MAssetLabel;
		private var _strengthTip:Sprite;
		
		private var _pkTip:Sprite;
		
		public function CharacterPanel(argRoleMediator:RoleMediator,argRolePlayerId:Number)
		{
			this._roleMediator = argRoleMediator;
			rolePlayerId = argRolePlayerId;
			initialView();
			initialEvents();
			if(_roleMediator.roleModule.assetsReady)
			{
				assetsCompleteHandler();
			}
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,273,374)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(278,3,160,374)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(295,327,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.pkValue") + "：",MAssetLabel.LABEL_TYPE_EN,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);
			
			//背景动画
			_roleBg = new Bitmap();
			_roleBg.x = _roleBg.y = 4;
			addChild(_roleBg);
			
			_sideBg = new Bitmap();
			_sideBg.x = 279;
			_sideBg.y = 4;
			addChild(_sideBg);
			
			_pkSitePng = new Bitmap();
			_pkSitePng.x = _pkSitePng.y = 13;
			addChild(_pkSitePng);
			
			_fightFireEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.ROLE_FIGHT_EFFECT));
			_fightFireEffect.move(118,238);
			_fightFireEffect.play(SourceClearType.TIME,300000);
			addChild(_fightFireEffect);
			
			_imageLayout = new MSprite();
			addChild(_imageLayout);
			
			_bg2 = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(280,99,156,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(280,149,156,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(280,271,156,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(280,7,156,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(310,11,76,16),new Bitmap(new TagBaseAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(50,342,67,23),new Bitmap(new TagFightAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(324,109,103,15),new ProgressTrackAsset()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(324,127,103,15),new ProgressTrackAsset()),
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,11,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.name") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,58,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,40,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,76,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.club") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,108,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.life") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,126,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.magic") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,158,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.attack") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,176,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.defense") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,212,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.mumpDefence") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,230,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.magicDefence") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,248,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.farDefence") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,280,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.shoot") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,298,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.duck") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,316,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.deligency") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,334,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.powerHit") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(289,352,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.addOnHurt") + "：",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,88,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,128,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,168,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,208,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,248,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(232,88,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(232,128,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(232,168,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(232,208,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(232,248,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(82,286,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(122,286,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(162,286,38,38),new Bitmap(CellCaches.getCellBg())),
				]);
			addChild(_bg2 as DisplayObject);
			
			_eqSitePng = new Bitmap();
			_eqSitePng.x = 16;
			_eqSitePng.y = 91;
			addChild(_eqSitePng);
			
			_lifeProgressBar = new ProgressBar(new Bitmap(new ProgressBarHpAsset()),1,1,97,9,true,false);
			_lifeProgressBar.move(327,112);
			addChild(_lifeProgressBar);
			_magicProgressBar = new ProgressBar(new Bitmap(new ProgressBarMpAsset()),1,1,97,9,true,false);
			_magicProgressBar.move(327,130);
			addChild(_magicProgressBar);
			
			_otherAttackLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.mumpAttack") + "：",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_otherAttackLabel.move(289,194);
			addChild(_otherAttackLabel);
			
//			_vipBg = new Bitmap();
//			_vipBg.x = 54;
//			_vipBg.y = 11;
//			addChild(_vipBg);			
			
//			_strengthBgs = [];
//			_strengthTipsSprites = [];
////			_strengthEnableBg = new StrengthEnableAsset();
////			_strengthDisableBg = new StrengthDisableAsset();
//			
//			for(var m:int = 0;m < 6;m++)
//			{
//				var tmp:Bitmap = new Bitmap(_strengthDisableBg);
//				tmp.x = m * 27 + 80;
//				tmp.y = 72;				
//				addChild(tmp);
//				_strengthBgs.push(tmp);
//				//加入文字
//				var tmpLabel:MAssetLabel = new MAssetLabel("+"+(7 +m).toString(),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//				tmpLabel.x = tmp.x + 1;
//				tmpLabel.y = tmp.y + 3;
//				addChild(tmpLabel);
//				var sprite1:Sprite = new Sprite();
//				sprite1.graphics.beginFill(0,0);
//				sprite1.graphics.drawRect( m * 27 + 80,72,22,22);
//				sprite1.graphics.endFill();
//				addChild(sprite1);
//				_strengthTipsSprites.push(sprite1);
//			}
			
			_strengthIcon = new IconStrengthAsset();
			_strengthIcon.x = 228;
			_strengthIcon.y = 15;
			addChild(_strengthIcon);
			_strengthIcon._number.visible = false;
			
			_strengthText = new MAssetLabel("+6",MAssetLabel.LABEL_TYPE_EN,TextFormatAlign.CENTER);
			_strengthText.move(15,50);
			_strengthText.width = 38;
			_strengthText.textColor = 0xffcc00;
//			addChild(_strengthText);
			
			_strengthTip = new Sprite();
			_strengthTip.graphics.beginFill(0,0);
			_strengthTip.graphics.drawRect(228,15,38,38);
			_strengthTip.graphics.endFill();
			addChild(_strengthTip);
						
			_tipsLabel = [
				LanguageManager.getWord("ssztl.role.tip1"),
				LanguageManager.getWord("ssztl.role.tip2"),
				LanguageManager.getWord("ssztl.role.tip3"),
				LanguageManager.getWord("ssztl.role.tip4"),
				LanguageManager.getWord("ssztl.role.tip5"),
				LanguageManager.getWord("ssztl.role.tip6"),
				LanguageManager.getWord("ssztl.role.tip7"),
				LanguageManager.getWord("ssztl.role.tip8"),
				LanguageManager.getWord("ssztl.role.tip9"),
				LanguageManager.getWord("ssztl.role.tip10"),
				LanguageManager.getWord("ssztl.role.tip11"),
				LanguageManager.getWord("ssztl.role.tip13")];
			
			_tipBgList = [];
			var _poses:Array = [
				new Point(286,157),
				new Point(286,175),
				new Point(286,193),
				new Point(286,211),
				new Point(286,229),
				new Point(286,247),
				new Point(286,279),
				new Point(286,297),
				new Point(286,315),
				new Point(286,333),
				new Point(286,351),
				new Point(61,336)];
			for(var i:int = 0;i<_poses.length;i++)
			{
				var sprite:Sprite = new Sprite();
				sprite.graphics.beginFill(0,0);
				if(i == 11)
					sprite.graphics.drawRect(_poses[i].x,_poses[i].y,70,35);
				else
					sprite.graphics.drawRect(_poses[i].x,_poses[i].y,145,18);				
				sprite.graphics.endFill();
				sprite.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
				sprite.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
				addChild(sprite);
				_tipBgList.push(sprite);
			}
			//名字
			_nickTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_nickTextField.textColor = 0xff9900;
			_nickTextField.move(139,25);
			addChild(_nickTextField);
			//称号
			_titleNameTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1); 
			_titleNameTextField.textColor = 0x00ff00;
			_titleNameTextField.move(139,43);
			addChild(_titleNameTextField);
			//填充模版
//			_titleNameTextField.setHtmlValue("[" +LanguageManager.getWord("ssztl.role.call") +"] " + "真吊丝");
			
//			_vipTextField = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_vipTextField.move();
//			addChild(_vipTextField);
			_leveTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_leveTextField.move(325,58);
			addChild(_leveTextField);
			//门派
			_factionNameTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_factionNameTextField.move(325,40);
			addChild(_factionNameTextField);
			//帮会
			_clubNameTextField = new MAssetLabel(LanguageManager.getWord("ssztl.common.none"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_clubNameTextField.move(325,76);
			addChild(_clubNameTextField);
			//pk值
			_PKvalueTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE_EN);
			_PKvalueTextField.textColor = 0xff6633;
			_PKvalueTextField.move(56,18);
			addChild(_PKvalueTextField);	
			
			_pkTip = new Sprite();
			_pkTip.graphics.beginFill(0,0);
			_pkTip.graphics.drawRect(13,13,70,30);
			_pkTip.graphics.endFill();
			addChild(_pkTip);
			
			_attackTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_attackTextField.move(325,158);
			addChild(_attackTextField);
			_defenseTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_defenseTextField.move(325,176);
			addChild(_defenseTextField);
			
			_vindictiveAttackTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_vindictiveAttackTextField.move(349,194);
			addChild(_vindictiveAttackTextField);
			_vindictiveDefenseTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_vindictiveDefenseTextField.move(349,212);
			addChild(_vindictiveDefenseTextField);
			
			_magicDefenseTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_magicDefenseTextField.move(349,230);
			addChild(_magicDefenseTextField);
			_farDefenseTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_farDefenseTextField.move(349,248);
			addChild(_farDefenseTextField);
			
			_hitTargetTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_hitTargetTextField.move(325,280);
			addChild(_hitTargetTextField);
			_duckTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_duckTextField.move(325,298);
			addChild(_duckTextField);
			_deligencyTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_deligencyTextField.move(325,316);
			addChild(_deligencyTextField);
			_powerHitTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_powerHitTextField.move(325,334);
			addChild(_powerHitTextField);
			//追伤
			_addOnHurtTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_addOnHurtTextField.move(325,352);
			addChild(_addOnHurtTextField);
			
			_fightTextField = new MAssetLabel("",[new TextFormat("Tahoma",20,0xffcc00,false),new GlowFilter(0x000000,1,2,2,10)],TextFormatAlign.CENTER);
			_fightTextField.move(138,340);
			_fightTextField.width = 140;
//			addChild(_fightTextField);
			_fightTextBox = new MSprite();
			_fightTextBox.move(120,340);
			addChild(_fightTextBox);
			
			_increaseFight = new MAssetButton1(new FightBtnAsset() as MovieClip);
			_increaseFight.move(233,335);
			addChild(_increaseFight);
			//显示战斗力动画遮罩
			_fightUpPanelMask = new Sprite();
			_fightUpPanelMask.graphics.beginFill(0,1);
			_fightUpPanelMask.graphics.drawRect(279,4,157,372);
			_fightUpPanelMask.graphics.endFill();
			addChild(_fightUpPanelMask);
			_fightUpPanelMask.visible = false;
			
			//拖动自动填充
			_roleCellEmptyDrag = new RoleCellEmpty();
			_roleCellEmptyDrag.move(5,55);
			addChild(_roleCellEmptyDrag);
			
			var backgroundPoses:Array = [
				LanguageManager.getWord("ssztl.common.armet"),
				LanguageManager.getWord("ssztl.common.neckLace"),
				LanguageManager.getWord("ssztl.common.peiShi"),
				LanguageManager.getWord("ssztl.common.ring"),
				LanguageManager.getWord("ssztl.common.marryAcces"),
				
				LanguageManager.getWord("ssztl.common.weaponList"),				
				LanguageManager.getWord("ssztl.common.cloth"),
				LanguageManager.getWord("ssztl.common.cuff"),				
				LanguageManager.getWord("ssztl.common.caestus"),
				LanguageManager.getWord("ssztl.common.shoe"),
				
				LanguageManager.getWord("ssztl.common.fly"),
				LanguageManager.getWord("ssztl.common.fashion"),
				LanguageManager.getWord("ssztl.common.weaponAcces")
				];
			
			var poses:Array = [
				new Point(11,88),new Point(11,128),new Point(11,168),new Point(11,208),new Point(12,248),
				new Point(232,88),new Point(232,128),new Point(232,168),new Point(232,208),new Point(232,248),
				new Point(82,286),new Point(122,286),new Point(162,286)
			];
			
			for(var j:int = 0; j < poses.length; j++)
			{
				if(backgroundPoses[j])
				{
					var nameLabel:MAssetLabel = new MAssetLabel(backgroundPoses[j],MAssetLabel.LABEL_TYPE_CELL);
					nameLabel.x =poses[j].x + 5;
					nameLabel.y = poses[j].y + 10;
					addChild(nameLabel);
				}
				var roleCell:RoleCell = new RoleCell(clickHandler,doubleClickHandler);
				roleCell.move(poses[j].x,poses[j].y);
				addChild(roleCell);
				
				_roleBagCellVector.push( roleCell);
				if(rolePlayerId == GlobalData.selfPlayer.userId)
				{
					roleCell.addEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
					roleCell.addEventListener(MouseEvent.CLICK,cellClickHandler);
					
					roleCell.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
					roleCell.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
				}
			}
			
//			_hideBtn = new MCacheAsset1Btn(1,"隐藏时装");
//			_hideBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.hideFashion"));
//			_hideBtn.move(178,379);
//			addChild(_hideBtn);
//			_hideBtn.enabled = false;
//			if(rolePlayerId == GlobalData.selfPlayer.userId)
//			{
//				_hideBtn.enabled = true;	
//			}
			
			_hideCheckBox = new CheckBox();
			_hideCheckBox.label = LanguageManager.getWord("ssztl.common.fashion");
			_hideCheckBox.setSize(75,20);
			_hideCheckBox.move(221,306);
			addChild(_hideCheckBox);
			_hideCheckBox.enabled = false;
			if(rolePlayerId == GlobalData.selfPlayer.userId)
			{
				_hideCheckBox.enabled = true;
				if(GlobalData.selfPlayer.hideSuit) _hideCheckBox.selected = true;
			}
		}
		
		private function itemOverHandler(evt:MouseEvent):void
		{
			var _cur:RoleCell = evt.currentTarget as RoleCell;
			_cur.over = true;
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			var _cur:RoleCell = evt.currentTarget as RoleCell;
			_cur.over = false;
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			_roleBg.bitmapData  =AssetUtil.getAsset("ssztui.role.RoleBgAsset",BitmapData) as BitmapData;
			_sideBg.bitmapData = AssetUtil.getAsset("ssztui.role.RoleSideBgAsset",BitmapData) as BitmapData;	
			_eqSitePng.bitmapData = AssetUtil.getAsset("ssztui.role.EqSiteAsset",BitmapData) as BitmapData;
			_pkSitePng.bitmapData = AssetUtil.getAsset("ssztui.role.PKboxAsset",BitmapData) as BitmapData;
			if(_FightUpPanel)
				_FightUpPanel.assetsCompleteHandler();
		}
		private function otherOverHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.role.allStrengthNotOpen"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function otherOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			var index:int = _tipBgList.indexOf(evt.currentTarget);
			if(!roleInfo.playerInfo)return;
			if(index == 2)
			{
				//
				if(roleInfo.playerInfo.career == 1) TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.role.shangWuAttackAbility"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
				if(roleInfo.playerInfo.career == 2) TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.role.xiaoYaoAttackAbility"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
				if(roleInfo.playerInfo.career == 3) TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.role.liuXingAttackAbility"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
			}
			else
			{
				TipsUtil.getInstance().show(_tipsLabel[index],null,new Rectangle(evt.stageX,evt.stageY,0,0));
			}
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function cellDownHandler(e:MouseEvent):void
		{
			var roleCell:RoleCell = e.currentTarget as RoleCell;
			if(roleCell.itemInfo)
			{
				roleCell.dragStart();
			}
		}
		private function cellClickHandler(e:MouseEvent):void
		{
			var roleCell:RoleCell = e.currentTarget as RoleCell;
			if(roleCell.itemInfo)
			{
				DoubleClickManager.addClick(roleCell);
			}
		}
		
		private function clickHandler(roleCell:RoleCell):void
		{
		}
		
		private function doubleClickHandler(roleCell:RoleCell):void
		{
			ModuleEventDispatcher.dispatchCellEvent(new CellEvent(CellEvent.CELL_DOUBLECLICK,roleCell));
		}
		
		private function addFriendsHandler(e:MouseEvent):void
		{
			FriendUpdateSocketHandler.sendAddFriend(roleInfo.playerInfo.serverId,roleInfo.playerInfo.nick,true);
		}
		
		private function equipStrengthChecker(level:int):int
		{
			var equipList:Array;
			var count:int = 0;
			if(rolePlayerId == GlobalData.selfPlayer.userId) equipList = GlobalData.bagInfo._itemList.slice(0,30);
			else equipList = roleInfo.equipList;
			for(var i:int = 0;i<equipList.length;i++)
			{
				if(equipList[i] && equipList[i].place != 4 && equipList[i].place < 10)
				{
					if(equipList[i].strengthenLevel > level || (equipList[i].strengthenLevel == level && equipList[i].strengthenPerfect == 100)) 
						count++;
				}
			}
			return count;
		}
		
		private function checkStrength():void
		{
//			for(var i:int = 0;i<_strengthBgs.length;i++)
//			{
//				var count:int = equipStrengthChecker(i+7);
//				if(count == 9) _strengthBgs[i].bitmapData = _strengthEnableBg;
//				else _strengthBgs[i].bitmapData = _strengthDisableBg;
//			}
			//6,8,9,10,11,12
			for(var i:int = 6;i<13;i++){
				if(i==7) continue;
				var count:int = equipStrengthChecker(i);
				if(count != 9) break;
			}
			if(i==6){
				_strengthIcon.gotoAndStop(1);
				_strengthIcon._number.visible = false;
				_strengthText.text = "+6";
			}else{
				var ct:int = i==8?6:i-1;
				_strengthIcon.gotoAndStop(2);
				_strengthIcon._number.visible = true;
				_strengthIcon._number.gotoAndStop(ct-5);
				_strengthText.text = "+" + ct;
			}
		}
		
		private function initialData(e:RoleInfoEvents):void
		{			
//			if(roleInfo.playerInfo.camp != CampType.WU)
//			{
//				_nickTextField.htmlText = "<font color = '#FFD200'>"+CampType.getCampName(roleInfo.playerInfo.camp)+"</font>" +"~" + roleInfo.playerInfo.nick;
//			}else
//			{
//				_nickTextField.text = roleInfo.playerInfo.nick;
//			}
//			if(roleInfo.playerInfo.attack)
//			{
//				var vipPic:Bitmap = new Bitmap(new VipPic());
//				vipPic.x = 238;
//				vipPic.y = 2;
//				addChild(vipPic);
//				_vipTextField.htmlText = "<font color = '#FFD200'>"+CampType.getCampName(roleInfo.playerInfo.camp)+"</font>";
//			}
//			_leveTextField.text = roleInfo.playerInfo.level.toString();
//			_factionNameTextField.text = CareerType.getNameByCareer(roleInfo.playerInfo.career);
//			_clubNameTextField.text = roleInfo.playerInfo.clubName;
			
//			_vipBg.bitmapData = VipIconCaches.vipCache[roleInfo.playerInfo.getVipType()];
			
			updatePropertyHandler(null);
			var tmpequipList:Array;
			var isOther:Boolean = false;
			 if(rolePlayerId == GlobalData.selfPlayer.userId)
				 tmpequipList = GlobalData.bagInfo._itemList.slice(0,30);
			 else
			 {
				 tmpequipList = roleInfo.equipList;
				 isOther = true;
			 }
			 checkStrength();
			 for each(var i:ItemInfo in tmpequipList)
			 {
				 if(i != null && (i.place >= 0 && i.place < _roleBagCellVector.length))
				 {
					 _roleBagCellVector[i.place].itemInfo = i;
					 _roleBagCellVector[i.place].isOther = isOther;
					 _roleBagCellVector[i.place].equipList = tmpequipList;
				 }
			 }
			 if(!_character)
			 {
				 _character = GlobalAPI.characterManager.createShowCharacterWrapper(roleInfo.playerInfo);
				 _character.setMouseEnabeld(false);
				 _character.show(DirectType.BOTTOM,this._imageLayout);
				 if(roleInfo.playerInfo.getMounts())
				 {
					 _character.move(136,242);
				 }
				 else
				 {
				 	_character.move(136,272);
				 }
//				 _character.setMouseEnabeld(false);
			 }
		}
		
		private function updatePropertyHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			
			_nickTextField.text = roleInfo.playerInfo.nick;
//			_vipBg.x = 52 + _nickTextField.width;
			
			_leveTextField.text = roleInfo.playerInfo.level.toString();
			_factionNameTextField.text = CareerType.getNameByCareer(roleInfo.playerInfo.career);
			if(roleInfo.playerInfo.clubName != "")
				_clubNameTextField.text = roleInfo.playerInfo.clubName;
			else
				_clubNameTextField.text = LanguageManager.getWord("ssztl.common.none");
			_PKvalueTextField.text = roleInfo.playerInfo.PKValue.toString();
			
			var attack:int = roleInfo.playerInfo.getFreeAttack();
			_attackTextField.htmlText = roleInfo.playerInfo.attack.toString();
			_attackTextField.htmlText += attack > 0 ? "<font color='#00ff00'>+" + attack + "</font>": "";
			_attackTextField.htmlText += attack < 0 ? "<font color='#ff0000'>" + attack + "</font>": "";
			var defense:int = roleInfo.playerInfo.getFreeDefense();
			_defenseTextField.htmlText = roleInfo.playerInfo.defense.toString();
			_defenseTextField.htmlText += defense > 0 ? "<font color='#00ff00'>+" + defense + "</font>": "";
			_defenseTextField.htmlText += defense < 0 ? "<font color='#ff0000'>" + defense + "</font>": "";
			var hitTarget:int = roleInfo.playerInfo.getFreeHitTarget();
			_hitTargetTextField.htmlText = roleInfo.playerInfo.hitTarget.toString()
			_hitTargetTextField.htmlText += hitTarget > 0 ? "<font color='#00ff00'>+" + hitTarget + "</font>": "";
			_hitTargetTextField.htmlText += hitTarget < 0 ? "<font color='#ff0000'>" + hitTarget + "</font>": "";
			var duck:int = roleInfo.playerInfo.getFreeDuck();
			_duckTextField.htmlText = roleInfo.playerInfo.duck.toString();
			_duckTextField.htmlText += duck > 0 ? "<font color='#00ff00'>+" + duck + "</font>": "";
			_duckTextField.htmlText += duck < 0 ? "<font color='#ff0000'>" + duck + "</font>": "";
			var deligency:int = roleInfo.playerInfo.getFreeDeligency();
			_deligencyTextField.htmlText = roleInfo.playerInfo.deligency.toString()
			_deligencyTextField.htmlText += deligency > 0 ? "<font color='#00ff00'>+" + deligency + "</font>": "";
			_deligencyTextField.htmlText += deligency < 0 ? "<font color='#ff0000'>" + deligency + "</font>": "";
			
			var powerHit:int = roleInfo.playerInfo.getPowerHit();
			_powerHitTextField.htmlText = roleInfo.playerInfo.powerHit.toString();
			_powerHitTextField.htmlText += powerHit > 0 ? "<font color='#00ff00'>+" + powerHit + "</font>": "";
			_powerHitTextField.htmlText += powerHit < 0 ? "<font color='#ff0000'>" + powerHit + "</font>": "";
			
//			var hurt:int = roleInfo.playerInfo.damage;
			_addOnHurtTextField.htmlText = roleInfo.playerInfo.damage.toString();
			var attackSpecial:int;
			//1:岳王宗  2:花间派 3:唐门
			if(roleInfo.playerInfo.career == 1)
			{
				_otherAttackLabel.setValue(LanguageManager.getWord("ssztl.common.mumpAttack") + "：" );
//				attackSpecial = roleInfo.playerInfo.getFreeMumpAttack();
				attackSpecial = roleInfo.playerInfo.getAttributeAttack();
				attackSpecial = attackSpecial + roleInfo.playerInfo.getFreeMumpAttack();
				_vindictiveAttackTextField.htmlText = roleInfo.playerInfo.mumpAttack.toString();
				_vindictiveAttackTextField.htmlText += attackSpecial > 0 ? "<font color='#00ff00'>+" + attackSpecial + "</font>": "";
				_vindictiveAttackTextField.htmlText += attackSpecial < 0 ? "<font color='#ff0000'>" + attackSpecial + "</font>": "";
			}
			else if(roleInfo.playerInfo.career == 2)
			{
				_otherAttackLabel.setValue(LanguageManager.getWord("ssztl.common.magicAttack") + "：");
//				attackSpecial = roleInfo.playerInfo.getFreeMagicAttack();
				attackSpecial = roleInfo.playerInfo.getAttributeAttack();
				attackSpecial = attackSpecial + roleInfo.playerInfo.getFreeMagicAttack();
				_vindictiveAttackTextField.htmlText = roleInfo.playerInfo.magicAttack.toString();
				_vindictiveAttackTextField.htmlText += attackSpecial > 0 ? "<font color='#00ff00'>+" + attackSpecial + "</font>": "";
				_vindictiveAttackTextField.htmlText += attackSpecial < 0 ? "<font color='#ff0000'>" + attackSpecial + "</font>": "";
			}
			else if(roleInfo.playerInfo.career == 3)
			{
				_otherAttackLabel.setValue(LanguageManager.getWord("ssztl.common.farAttack") + "：");
//				attackSpecial = roleInfo.playerInfo.getFreeFarAttack();
				attackSpecial = roleInfo.playerInfo.getAttributeAttack();
				attackSpecial = attackSpecial + roleInfo.playerInfo.getFreeFarAttack();
				_vindictiveAttackTextField.htmlText = roleInfo.playerInfo.farAttack.toString();
				_vindictiveAttackTextField.htmlText += attackSpecial > 0 ? "<font color='#00ff00'>+" + attackSpecial + "</font>": "";
				_vindictiveAttackTextField.htmlText += attackSpecial < 0 ? "<font color='#ff0000'>" + attackSpecial + "</font>": "";
			}
			
			
			var mumpDefense:int = roleInfo.playerInfo.getFreeMumpDefense();
			_vindictiveDefenseTextField.htmlText = roleInfo.playerInfo.mumpDefense.toString();
			_vindictiveDefenseTextField.htmlText += mumpDefense > 0 ? "<font color='#00ff00'>+" + mumpDefense + "</font>": "";
			_vindictiveDefenseTextField.htmlText += mumpDefense < 0 ? "<font color='#ff0000'>" + mumpDefense + "</font>": "";
			
			var magicDefense:int = roleInfo.playerInfo.getFreeMagicDefense();
			_magicDefenseTextField.htmlText = roleInfo.playerInfo.magicDefense.toString();
			_magicDefenseTextField.htmlText += magicDefense > 0 ? "<font color='#00ff00'>+" + magicDefense + "</font>": "";
			_magicDefenseTextField.htmlText += magicDefense < 0 ? "<font color='#ff0000'>" + magicDefense + "</font>": "";
			
			var farDefense:int = roleInfo.playerInfo.getFreeFarDefense();
			_farDefenseTextField.htmlText = roleInfo.playerInfo.farDefense.toString();
			_farDefenseTextField.htmlText += farDefense > 0 ? "<font color='#00ff00'>+" + farDefense + "</font>": "";
			_farDefenseTextField.htmlText += farDefense < 0 ? "<font color='#ff0000'>" + farDefense + "</font>": "";
			
			
//			_currentPhysicalTextField.text = roleInfo.playerInfo.currentPhysical.toString() + "/" + roleInfo.playerInfo.maxPhysical.toString();
//			_lifeExperienceTextField.text =roleInfo.playerInfo.lifeExperiences.toString() + "/" +roleInfo.playerInfo.totalLifeExperiences.toString();
			
				
//			_fightTextField.text = roleInfo.playerInfo.fight.toString();
			setNumbers(roleInfo.playerInfo.fight);
			updateProgressBarHandler(null);
		}
		private function setNumbers(n:int):void
		{
			while(_fightTextBox.numChildren>0){
				_fightTextBox.removeChildAt(0);
			}
			var f:String = n.toString();
			for(var i:int=0; i<f.length; i++)
			{
				var mc:Bitmap = new Bitmap(new _numClass[int(f.charAt(i))] as BitmapData);
				mc.x = i*16; //_fightTextBox.width - i*3;
				_fightTextBox.addChild(mc);
			}
		}
		
		private function updateProgressBarHandler(e:SelfPlayerInfoUpdateEvent):void
		{
			_lifeProgressBar.setValue(roleInfo.playerInfo.totalHP,roleInfo.playerInfo.currentHP);
			_magicProgressBar.setValue(roleInfo.playerInfo.totalMP,roleInfo.playerInfo.currentMP);
		}
		
		private function updateEquitments(e:SelfPlayerInfoUpdateEvent):void
		{
			var data:Object = e.data;
			for(var i:int = 0;i<data.length;i++)
			{
				_roleBagCellVector[data[i]].itemInfo = GlobalData.bagInfo.getItem(data[i]);
			}
			checkStrength();
		}
		
		private function get roleInfo():RoleInfo
		{
			return _roleMediator.roleModule.roleInfoList[rolePlayerId];
		}
		
		private function initialEvents():void
		{
			roleInfo.addEventListener(RoleInfoEvents.ROLEINFO_INITIAL,initialData);
			if(rolePlayerId == GlobalData.selfPlayer.userId)
			{
				GlobalData.bagInfo.addEventListener(SelfPlayerInfoUpdateEvent.EQUIPUPDATE,updateEquitments);
				GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.UPDATE_HPMP,updateProgressBarHandler);
				GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,updatePropertyHandler);
				GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.FREE_PROPERTY_UPDATE,updatePropertyHandler);
				_hideCheckBox.addEventListener(Event.CHANGE,hideChangeHandler);
//				_hideBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
//			for(var i:int = 0;i<_strengthTipsSprites.length;i++)
//			{
//				//_strengthTipsSprites[i].addEventListener(MouseEvent.MOUSE_OVER,strengthOverHandler);
//				//_strengthTipsSprites[i].addEventListener(MouseEvent.MOUSE_OUT,strengthOutHandler);
//			}
			_strengthTip.addEventListener(MouseEvent.MOUSE_OVER,strengthOverHandler);
			_strengthTip.addEventListener(MouseEvent.MOUSE_OUT,strengthOutHandler);
			_increaseFight.addEventListener(MouseEvent.CLICK,fightBtnClickHandler);
			
			_pkTip..addEventListener(MouseEvent.MOUSE_OVER,pkOverHandler);
			_pkTip.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function removeEvents():void
		{
			roleInfo.removeEventListener(RoleInfoEvents.ROLEINFO_INITIAL,initialData);
			if(rolePlayerId == GlobalData.selfPlayer.userId)
			{
				GlobalData.bagInfo.removeEventListener(SelfPlayerInfoUpdateEvent.EQUIPUPDATE,updateEquitments);
				GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.UPDATE_HPMP,updateProgressBarHandler);
				GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,updatePropertyHandler);
				GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.FREE_PROPERTY_UPDATE,updatePropertyHandler);
				_hideCheckBox.removeEventListener(Event.CHANGE,hideChangeHandler);
//				_hideBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
//			for(var i:int = 0;i<_strengthTipsSprites.length;i++)
//			{
////				_strengthTipsSprites[i].removeEventListener(MouseEvent.MOUSE_OVER,strengthOverHandler);
////				_strengthTipsSprites[i].removeEventListener(MouseEvent.MOUSE_OUT,strengthOutHandler);
//			}
			_strengthTip.removeEventListener(MouseEvent.MOUSE_OVER,strengthOverHandler);
			_strengthTip.removeEventListener(MouseEvent.MOUSE_OUT,strengthOutHandler);
			_increaseFight.removeEventListener(MouseEvent.CLICK,fightBtnClickHandler);
			_pkTip..removeEventListener(MouseEvent.MOUSE_OVER,pkOverHandler);
			_pkTip.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function pkOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.role.pkTip"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function strengthOverHandler(evt:MouseEvent):void
		{
			var level:int = int(_strengthText.text.toString().substring(1,_strengthText.text.toString().length));  //_strengthTipsSprites.indexOf(evt.currentTarget as Sprite) + 7;
			var count:int = equipStrengthChecker(level);
			var career:int;
			if(rolePlayerId == GlobalData.selfPlayer.userId) career = GlobalData.selfPlayer.career;
			else career = roleInfo.playerInfo.career;
			
			var tipStr:String = "";
			tipStr += addExtraTip(level,count,career);
			if(count >= 9)
			{
				if(level == 6)
					level = 8;
				else
					level = level + 1;				
				count = equipStrengthChecker(level);
				if(level <13) tipStr += addExtraTip(level,count,career,true);
			}
			tipStr += "<font color='#bb8050'>" + LanguageManager.getWord("ssztl.common.attentionDetail",level) + "</font>";
				
			TipsUtil.getInstance().show(tipStr,null,new Rectangle(evt.stageX,evt.stageY,0,0));
			
//			EquipStrengthTip.getInstance().showTip(level,count,career,new Point(evt.stageX,evt.stageY));
		}
		private function addExtraTip(level:int,upCount:int,career:int,second:Boolean = false):String
		{
			var tipStr:String = "";
			if(upCount >= 9)
			{
				tipStr += "<font color='#ff9900' size='13'><b>" + LanguageManager.getWord("ssztl.common.allEquipUp",level) + "(" + upCount + "/9)</b></font>\n";
				tipStr += "<font color='#0099ff'>" + LanguageManager.getWord("ssztl.activity.hasActivated") + "</font>\n";
				tipStr += "<font color='#cc00ff'>";
			}else
			{
				tipStr += "<font color='#777164' size='13'><b>" + LanguageManager.getWord("ssztl.common.allEquipUp",level) + "(" + upCount + "/9)</b></font>\n";
				if(!second) tipStr += "<font color='#ff3333'>" + LanguageManager.getWord("ssztl.common.unActivity") + "</font>\n";
				tipStr += "<font color='#777164'>";
			}
			var type:int;
			var type1:int;
			if(career == CareerType.SANWU) 
			{
				type = PropertyType.ATTR_MUMPHURTATT;
				type1 = PropertyType.ATTR_MUMPDEFENSE;
			}
			if(career == CareerType.XIAOYAO) 
			{
				type = PropertyType.ATTR_MAGICHURTATT;
				type1 = PropertyType.ATTR_MAGICDEFENCE;
			}
			if(career == CareerType.LIUXING) 
			{
				type = PropertyType.ATTR_FARHURTATT;
				type1 = PropertyType.ATTR_FARDEFENSE;
			}
			var strengthInfo:EquipStrengthTemplate = EquipStrengthTemplateList.getTemplate(level);
			if(strengthInfo)
			{
				if(strengthInfo.attack > 0) tipStr += PropertyType.getName(PropertyType.ATTR_ATTACK) + " +" +  strengthInfo.attack + "\n";
				if(strengthInfo.defence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_DEFENSE) + " +" +  strengthInfo.defence + "\n";
				if(strengthInfo.attrAttack > 0) tipStr += PropertyType.getName(type) + " +" +  strengthInfo.attrAttack + "\n";
				if(strengthInfo.attrDefence > 0) tipStr += PropertyType.getName(type1) + " +" +  strengthInfo.attrDefence + "\n";
				if(strengthInfo.hp > 0) tipStr += PropertyType.getName(PropertyType.ATTR_HP) + " +" +  strengthInfo.hp + "\n";
				if(strengthInfo.mp > 0) tipStr += PropertyType.getName(PropertyType.ATTR_MP) + " +" +  strengthInfo.mp + "\n";
				if(strengthInfo.defenceSuppress > 0) tipStr += PropertyType.getName(PropertyType.ATTR_SUPPRESSIVE_DEFEN) + " +" +  strengthInfo.defenceSuppress + "\n";
				if(strengthInfo.attrAttackPer > 0) tipStr += PropertyType.getName(type) + " +" + strengthInfo.attrAttackPer/100 + "%" + "\n";
				if(strengthInfo.mumpDefence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_MUMPDEFENSE) + " +" + strengthInfo.mumpDefence + "\n";
				if(strengthInfo.magicDefence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_MAGICDEFENCE)+ " +" + strengthInfo.magicDefence + "\n";
				if(strengthInfo.farDefence > 0) tipStr += PropertyType.getName(PropertyType.ATTR_FARDEFENSE)+ " +" + strengthInfo.farDefence + "\n";
			}
			tipStr += "</font>\n"
			
			return tipStr;
		}
		
		private function strengthOutHandler(evt:MouseEvent):void
		{
//			EquipStrengthTip.getInstance().hide();
			TipsUtil.getInstance().hide();
		}
		
		//显示战斗力提示
		private function fightBtnClickHandler(evt:MouseEvent):void
		{
			SetModuleUtils.addRole(GlobalData.selfPlayer.userId,100);
		}
//			if(_roleMediator.roleModule.fightUpPanel == null)
//			{
//				_roleMediator.roleModule.fightUpPanel = new FightUpgradePanel();
//				if(_roleMediator.roleModule.assetsReady)
//				{
//					_roleMediator.roleModule.fightUpPanel.assetsCompleteHandler();
//				}
//				_roleMediator.roleModule.fightUpPanel.addEventListener(Event.CLOSE,fuPanelCloseHandler);
//				GlobalAPI.layerManager.addPanel(_roleMediator.roleModule.fightUpPanel);
//			}
//			else
//			{
//				fuPanelCloseHandler(null);
//			}
//			
//			if(_FightUpPanel && _FightUpPanel.parent)
//			{
//				_FightUpPanel.hide();
//				_fightUpPanelMask.visible = false;
//			}else
//			{
//				_FightUpPanel = new FightUpgradeView();
//				_FightUpPanel.move(279,4);
//				addChild(_FightUpPanel);
//				_FightUpPanel.mask = _fightUpPanelMask;
//				_fightUpPanelMask.visible = true;
//				_FightUpPanel.show();
//				if(_assetsComplete)
//					_FightUpPanel.assetsCompleteHandler();
//			}
//		}
		
//		private function fuPanelCloseHandler(e:Event):void
//		{
//			if(_roleMediator && _roleMediator.roleModule.fightUpPanel)
//			{
//				_roleMediator.roleModule.fightUpPanel.removeEventListener(Event.CLOSE,fuPanelCloseHandler);
//				_roleMediator.roleModule.fightUpPanel.dispose();
//				_roleMediator.roleModule.fightUpPanel= null;
//			}
//		}
		
		private function hideChangeHandler(evt:Event):void
		{
			if(_hideCheckBox.selected) HideFashionSocketHandler.send(1);
			else HideFashionSocketHandler.send(0);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			if(_roleMediator.roleModule.assetsReady)
			{
				assetsCompleteHandler();
			}
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{
			hide();
			removeEvents();
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
			if(_sideBg && _sideBg.bitmapData)
			{
				_sideBg.bitmapData.dispose();
				_sideBg = null;
			}
			if(_roleBg && _roleBg.bitmapData)
			{
				_roleBg.bitmapData.dispose();
				_roleBg = null;
			}			
			if(_eqSitePng && _eqSitePng.bitmapData)
			{
				_eqSitePng.bitmapData.dispose();
				_eqSitePng = null;					
			}
			if(_pkSitePng && _pkSitePng.bitmapData)
			{
				_pkSitePng.bitmapData.dispose();
				_pkSitePng = null;					
			}
//			if(_FightUpPanel)
//			{
//				_FightUpPanel.dispose();
//				_FightUpPanel = null;
//			}
			if(_fightUpPanelMask && _fightUpPanelMask.parent)
			{
				_fightUpPanelMask.parent.removeChild(_fightUpPanelMask);
				_fightUpPanelMask = null;
			}
			while(_fightTextBox.numChildren>0){
				_fightTextBox.removeChildAt(0);
			}
			_fightTextBox = null;
			_roleMediator = null;
			_tipsLabel = null;
			_tipBgList = null;
			if(_bg){_bg.dispose();_bg = null;}
			_nickTextField = null;
			_vipTextField = null;
			_leveTextField = null;
			_factionNameTextField = null;
			_clubNameTextField = null;
			if(_magicProgressBar){_magicProgressBar.dispose();_magicProgressBar = null;}
			if(_lifeProgressBar){_lifeProgressBar.dispose();_lifeProgressBar = null;}
			_attackTextField = null;
			_defenseTextField = null;
			_hitTargetTextField = null;
			_duckTextField = null;
			_deligencyTextField = null;
			_powerHitTextField = null;
			_vindictiveAttackTextField = null;
			_vindictiveDefenseTextField = null;
			_magicDefenseTextField = null;
			_farDefenseTextField = null;
			_PKvalueTextField = null;
			_addOnHurtTextField = null;
			_increaseFight = null;
			_titleNameTextField = null;
//			_currentPhysicalTextField = null;
//			_lifeExperienceTextField = null;
			_fightTextField = null;
//			_vipBg = null;
			if(_fightFireEffect)
			{
				_fightFireEffect.dispose();
				_fightFireEffect = null;
			}
			
			_strengthIcon = null;
			_strengthText = null;
			_strengthTip = null;
			
			_strengthBgs = null;
			 _strengthEnableBg = null;
			_strengthDisableBg = null;
			_strengthTipsSprites = null;
			for each(var i:RoleCell in _roleBagCellVector)
			{
				i.removeEventListener(MouseEvent.MOUSE_DOWN,cellDownHandler);
				i.removeEventListener(MouseEvent.CLICK,cellClickHandler);
				i.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
				i.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
				i.dispose();
				i = null;
			}
			_roleBagCellVector = null;
			if(_roleCellEmptyDrag)
			{
				_roleCellEmptyDrag.dispose();
				_roleCellEmptyDrag = null;
			}
			if(_character){_character.dispose();_character = null;}
			if(_imageLayout){_imageLayout.dispose();_imageLayout = null;}
		}
	}
}