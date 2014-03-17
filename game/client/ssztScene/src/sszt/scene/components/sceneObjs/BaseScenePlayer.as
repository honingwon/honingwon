package sszt.scene.components.sceneObjs
{
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.ActionType;
	import sszt.constData.AttackTargetResultType;
	import sszt.constData.CampType;
	import sszt.constData.CategoryType;
	import sszt.constData.DirectType;
	import sszt.constData.SourceClearType;
	import sszt.constData.VipType;
	import sszt.constData.WarType;
	import sszt.core.caches.NumberCache;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.core.data.characterActionInfos.SceneMountsActionInfo;
	import sszt.core.data.characterActionInfos.SceneSpaActions;
	import sszt.core.data.characterActionInfos.SceneSwimActions;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.player.PlayerInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.data.titles.TitleNameEvents;
	import sszt.core.data.titles.TitleTemplateInfo;
	import sszt.core.data.titles.TitleTemplateList;
	import sszt.core.data.vip.VipTemplateInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.events.CharacterEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;
	
	import ssztui.scene.WarCampIcon1;
	import ssztui.scene.WarCampIcon2;
	import ssztui.scene.WarCampIcon3;

	public class BaseScenePlayer extends BaseRole
	{
		private var _getMounts:Boolean;
		protected var _isSit:Boolean;
		private var _upgradeEffect:BaseLoadEffect;
		private var _sitEffect:BaseLoadEffect;
//		private var _hitDownAsset:Sprite;
		private var _mediator:SceneMediator;
		private var _timeoutIndex:int = -1;
		private var _figureVisible:Boolean = true;
		private var _currentStrengthLevel:int = 0;
		private var _strengthAllEffect:BaseLoadEffect;
		private var _figureVisibleChange:Boolean;
		
		private var _hitDownAsset:Bitmap;
		private var _deadAsset:Bitmap;
		private var _powerTitleAsset:Bitmap;
		private var _moneyTitleAsset:Bitmap;
		private var _levelTitleAsset:Bitmap;
		private var _bottomAsset:Bitmap;
		private var _warState:int;
		private var _isPoison:Boolean,_isMouseOn:Boolean;
		
		private var _titleImg:Bitmap;
		private var _titleImgBd:BitmapData;
		
		private var _titleImg1:Bitmap;
		private var _titleImgBd1:BitmapData;
		
		private var _titleDic:Dictionary;
		private var _warCampIcon:Bitmap;
		
		private var _career:int;
		private var _roleAutoEffect:RoleAutoEffect;
		private static const POISON_EFFECT:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,-255,
																					  0,1,0,0,0,
																					  0,0,1,0,0,
																					  0,0,0,1,0]);
		
		public function BaseScenePlayer(info:BaseScenePlayerInfo,mediator:SceneMediator)
		{
			_titleDic = new Dictionary();
			_getMounts = info.isMount;
			_isSit = info.isSit;
			_warState = info.warState;
			_career = info.info.career;
			_mediator = mediator;
			super(info);
			_roleAutoEffect = new RoleAutoEffect(this);
		}
		
		override protected function init():void
		{
			super.init();
			titleNameUpdateHandler(null);
			
			mouseChildren = mouseEnabled = tabEnabled = tabChildren = false;
//			if(_warState == 6)
//			{
//				_bottomAsset = new Bitmap();
//				var t:BitmapData = AssetUtil.getAsset("mhsm.scene.ShenmoKingAsset") as BitmapData;
//				if(t)
//				{
//					_bottomAsset.bitmapData = t;
//					_bottomAsset.x = -90;
//					_bottomAsset.y = -30;
//					addChildAt(_bottomAsset,0);
//				}
//				else
//				{
//					ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.PLAYERICON_ASSET_COMPLETE,playerIconCompleteHandler);
//				}
//			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			getScenePlayerInfo().info.addEventListener(CharacterEvent.CHARACTER_UPDATE,characterUpdateHandler);
			getScenePlayerInfo().addEventListener(BaseRoleInfoUpdateEvent.UPGRADE,upgradeHandler);
			getScenePlayerInfo().info.addEventListener(PlayerInfoUpdateEvent.PKVALUE_CHANGE,pkValueChangeHandler);
			getScenePlayerInfo().info.addEventListener(TitleNameEvents.TITLE_NAME_UPDATE,titleNameUpdateHandler);
			getScenePlayerInfo().addEventListener(BaseRoleInfoUpdateEvent.TRANSPORT_UPDATE,transportUpdateHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.TITLE_ASSET_COMPLETE, titleAssetCompleteHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			getScenePlayerInfo().info.removeEventListener(CharacterEvent.CHARACTER_UPDATE,characterUpdateHandler);
			getScenePlayerInfo().removeEventListener(BaseRoleInfoUpdateEvent.UPGRADE,upgradeHandler);
			getScenePlayerInfo().info.removeEventListener(PlayerInfoUpdateEvent.PKVALUE_CHANGE,pkValueChangeHandler);
			getScenePlayerInfo().info.removeEventListener(TitleNameEvents.TITLE_NAME_UPDATE,titleNameUpdateHandler);
			getScenePlayerInfo().removeEventListener(BaseRoleInfoUpdateEvent.TRANSPORT_UPDATE,transportUpdateHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.PLAYERICON_ASSET_COMPLETE,playerIconCompleteHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.TITLE_ASSET_COMPLETE, titleAssetCompleteHandler);
		}
		
//		private function playerIconCompleteHandler(evt:CommonModuleEvent):void
//		{
//			if(_warState == 6)
//			{
//				var t:BitmapData = AssetUtil.getAsset("mhsm.scene.ShenmoKingAsset") as BitmapData;
//				_bottomAsset.bitmapData = t;
//				_bottomAsset.x = -90;
//				_bottomAsset.y = -30;
//				addChildAt(_bottomAsset,0);
//			}
//		}
		
		public function isSit():Boolean
		{
			if(!_info || !getScenePlayerInfo().info)return false;
			return getScenePlayerInfo().info.isSit();
		}
		
		private function characterUpdateHandler(evt:CharacterEvent):void
		{
//			updateShadow();
			if(_getMounts == getScenePlayerInfo().isMount 
				&& _isSit == getScenePlayerInfo().isSit 
				&& _currentStrengthLevel == getScenePlayerInfo().info.strengthLevel)return;
			_getMounts = getScenePlayerInfo().isMount;
			if(!_character)return;
			_isSit = getScenePlayerInfo().isSit;
			var dir:int = _character.dir;
			var isAdd:Boolean = _character.parent == this;
			var cx:Number = _character.x;
			var cy:Number = _character.y;
			var layerIndex:int = -1;
			if(isAdd)
			{
				layerIndex = _character.parent.getChildIndex(_character as DisplayObject);
			}
			_character.removeEventListener(Event.COMPLETE,characterCompleteHandler);
			_character.dispose();
//			(_character as IPoolObj).collect();
			newCharacter();
			_character.addEventListener(Event.COMPLETE,characterCompleteHandler);
			_character.show(dir);
			if(isAdd)
			{
				addChild(_character as DisplayObject);
			}
			if(_isSit)
			{
				_character.move(0,0);
			}
			else
			{
				if(_getMounts)
				{
					_character.move(0,-50);
				}
				else
				{
					_character.move(0,0);
				}
			}
			drawNickPosition();
			updateAllStrengthEffect();
		}
		
		private function updateAllStrengthEffect():void
		{
			invalidate(InvalidationType.STYLES);
		}
		private function showStrengthAllEffect():void
		{
			hideStrengthAllEffect();
			if(!_figureVisible)return;
			var effect:int = EffectType.ALL_STRENGTH_7 + ((_career -1 )* 3 );
			if(_currentStrengthLevel > 8)effect = EffectType.ALL_STRENGTH_12+ ((_career -1 )* 3 );
			else if(_currentStrengthLevel > 6)effect = EffectType.ALL_STRENGTH_9+ ((_career -1 )* 3 );
			_strengthAllEffect = new BaseLoadEffect(MovieTemplateList.getMovie(effect));
			if(_getMounts)
			{
				_strengthAllEffect.move(0,-50);
			}
			else
			{
				_strengthAllEffect.move(0,0);
			}
			if(_isSit)
			{
				_strengthAllEffect.move(0,30);
			}
			_strengthAllEffect.play(SourceClearType.IMMEDIAT,50000);
			addChild(_strengthAllEffect as DisplayObject);
		}
		private function hideStrengthAllEffect():void
		{
			if(_strengthAllEffect)
			{
				_strengthAllEffect.dispose();
				_strengthAllEffect = null;
			}
		}
		
		private function updateShadow():void
		{
		}
		
		public function setFigureVisible(value:Boolean):void
		{
			_figureVisible = value;
			getCharacter().setFigureVisible(value);
//			if(_figureVisible && _isSit && _currentStrengthLevel == 0)
//			{
//				createSitEffect();
//			}
//			else
//			{
//				clearSitEffect();
//			}
			_figureVisibleChange = true;
			invalidate(InvalidationType.STYLES);
		}
		
		override protected function drawNickPosition():void{
			nick.y = getNickY();
			if (_titleImg){
				_titleImg.y = int(getNickY() - _titleImg.height);
			}
			if (_titleImg1)
			{
				if(_titleImg)
				{
					_titleImg1.y = int(getNickY() - _titleImg1.height - _titleImg.height);
				}
				else
				{
					_titleImg1.y = int(getNickY() - _titleImg1.height);
				}
			}
			if(_warCampIcon)
			{
				_warCampIcon.y = getNickY() + nick.textHeight - 29;
				addChild(_warCampIcon);
			}
			addChild(nick);
			if(bloodBar)bloodBar.y = getNickY() + 35;
		}
		
		protected function pkValueChangeHandler(e:PlayerInfoUpdateEvent):void
		{
			updateTitleName();
		}
		
		private function getNickColor():String
		{
			var color:String = "68dbe0";
			if(getScenePlayerInfo().info.userId == GlobalData.selfPlayer.userId)
			{
				color = "FCFF1B";
			}
			if(getScenePlayerInfo().info.PKValue > 10)
			{
				color = "FF0000";
			}
			var isInShenMoWar:Boolean;
			var isInClubWar:Boolean;
			if(!_mediator || !_mediator.sceneInfo || !_mediator.sceneInfo.mapInfo)
			{
				return "FCFF1B";
			}
			if(_mediator.sceneInfo.mapInfo.isShenmoDouScene())isInShenMoWar = true;
			if(_mediator.sceneInfo.mapInfo.isClubPointWarScene())isInClubWar = true;
			if(!getScenePlayerInfo() || !_mediator.sceneInfo.playerList.self)
			{
				return "FCFF1B";
			}
			if(isInShenMoWar && getScenePlayerInfo().warState != _mediator.sceneInfo.playerList.self.warState)
			{
				color = "f96a49";
			}
			if(isInClubWar && getScenePlayerInfo().info.clubName != GlobalData.selfPlayer.clubName)
			{
				color = "f96a49";
			}
			return color;
		}

		override protected function getNickY():int{
			if (_isSit){
				return -130;
			}
			if (_getMounts){
				return -250;
			}
			return -170;
		}
		
		private function setTitleData():void{
			var titleTemplateInfo:TitleTemplateInfo;
			var GMinfo:TitleTemplateInfo;
			if (!(CopyTemplateList.showTitle(GlobalData.copyEnterCountList.inCopyId))){
				if (_titleImg && _titleImg.parent)
				{
					_titleImg.parent.removeChild(_titleImg);
					_titleImg = null;
				}
				if (_titleImg1 && _titleImg1.parent)
				{
					_titleImg1.parent.removeChild(_titleImg1);
					_titleImg1 = null;
				}
				return;
			}
			var titleHeight:int;
//			if (VipType.getIsGM(getScenePlayerInfo() .info.vipType)){
//				GMinfo = TitleTemplateList.getTitle(104);
//				_titleImgBd = (AssetUtil.getAsset(GMinfo.pic) as BitmapData);
//			} 
//			else {
				if (getScenePlayerInfo().info.buffTitleId == 1)
				{
					if (_titleDic[1000000] is BitmapData)
					{
						_titleImgBd1 = _titleDic[1000000];
					} 
					else 
					{
						_titleImgBd1 = AssetUtil.getAsset("ssztui.title.buffTitle") as BitmapData;
						_titleDic[1000000] = _titleImgBd1;
					}
				}
				if (getScenePlayerInfo().info.buffTitleId == 2)
				{
					if (_titleDic[1000001] is BitmapData)
					{
						_titleImgBd1 = _titleDic[1000001];
					} 
					else 
					{
						_titleImgBd1 = AssetUtil.getAsset("ssztui.title.buffTitle2") as BitmapData;
						_titleDic[1000001] = _titleImgBd1;
					}
				}
				else {
					_titleImgBd1 = null;
				}
				if (getScenePlayerInfo().info.title != 0)
				{
					titleTemplateInfo = TitleTemplateList.getTitle(getScenePlayerInfo().info.title);
					if (!titleTemplateInfo){
						return;
					}
					if (_titleDic[getScenePlayerInfo().info.title] is BitmapData)
					{
						_titleImgBd = _titleDic[getScenePlayerInfo().info.title];
					} 
					else 
					{
						_titleImgBd = AssetUtil.getAsset(titleTemplateInfo.pic) as BitmapData;
						_titleDic[getScenePlayerInfo().info.title] = _titleImgBd;
					}
				}
				else {
					_titleImgBd = null;
				}
//			}
			
			if (_titleImgBd){
				if (!_titleImg)
				{
					_titleImg = new Bitmap();
				}
				_titleImg.bitmapData = _titleImgBd;
				_titleImg.x = _titleImg.width * -0.5;
				_titleImg.y = getNickY() - _titleImg.height;
				titleHeight = _titleImg.height;
				addChild(_titleImg);
			}
			else {
				if (_titleImg && _titleImg.parent){
					_titleImg.parent.removeChild(_titleImg);
					_titleImg = null;
				}
			}
			
			if (_titleImgBd1){
				if (!_titleImg1)
				{
					_titleImg1 = new Bitmap();
				}
				_titleImg1.bitmapData = _titleImgBd1;
				_titleImg1.x = _titleImg1.width * -0.5;
				_titleImg1.y = getNickY() - _titleImg1.height;
				titleHeight = _titleImg1.height;
				addChild(_titleImg1);
			}
			else {
				if (_titleImg1 && _titleImg1.parent){
					_titleImg1.parent.removeChild(_titleImg1);
					_titleImg1 = null;
				}
			}
		}
		
		
		private function titleAssetCompleteHandler(evt:CommonModuleEvent):void{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.TITLE_ASSET_COMPLETE, titleAssetCompleteHandler);
			setTitleData();
			drawNickPosition();
		}
		
		
		//更新人物称号
		private function titleNameUpdateHandler(e:TitleNameEvents):void
		{
			updateTitleName();
			setTitleData();
			drawNickPosition();
		}
		
		public function updateTitleName():void
		{
			var isVip:Boolean;
			var isNewlyGuild:Boolean;
			var isHasClub:Boolean;
			var isClubEnemy:Boolean;
			var isInShenMoWar:Boolean;
			var hasMarryRelation:Boolean;
			
			if(MapTemplateList.isPerWarMap() && (getScenePlayerInfo().getObjType() == MapElementType.PLAYER))
			{
				nick.text = LanguageManager.getWord("ssztl.scene.hideFaceMan");
				return;
			}
//			if(getScenePlayerInfo() && getScenePlayerInfo().warState == 6)
//			{
//				nick.text = getScenePlayerInfo().info.nick;
//				return;
//			}
			if(getScenePlayerInfo().info.getVipType() != 0)isVip = true;
			if(getScenePlayerInfo().info.getIsNewlyGuild())isNewlyGuild = true;
			if(getScenePlayerInfo().info.clubId != 0)isHasClub = true;
			if(GlobalData.selfPlayer.isClubEnemy(getScenePlayerInfo().info.clubId)) isClubEnemy = true;
			if(getScenePlayerInfo().warState > 0 )isInShenMoWar = true;
			if(getScenePlayerInfo().marryRelationType > 0 )hasMarryRelation = true;
			
			var tmpVipTemplateInfo:VipTemplateInfo;
			var tmpTitleTemplateInfo:TitleTemplateInfo;
			var tmpColor:String = ""
			
			var tmpContent:String = "";
			
			if(isNewlyGuild)
			{
				tmpContent = "<font color='#f12b6f'>"+LanguageManager.getWord("ssztl.common.newPlayerDirector")+"</font>\n";
			}
			else if(isVip)
			{
//				tmpVipTemplateInfo = VipTemplateList.getVipTemplateInfo(getScenePlayerInfo().info.getVipType());
//				tmpTitleTemplateInfo = TitleTemplateList.getTitle(tmpVipTemplateInfo.titleId);
//				tmpColor = CategoryType.getQualityColorString(tmpTitleTemplateInfo.quality);
//				tmpContent = "<font color='#"+tmpColor+"'>"+tmpTitleTemplateInfo.name+"</font>\n";
			}
			else
			{
				tmpContent = "<font color='#6ef12e'>" + GlobalData.GAME_NAME + "</font>\n";
			}
			
			if(hasMarryRelation)
			{
				var type:int = getScenePlayerInfo().marryRelationType;
				var typeStr:String;
				var marryNick:String = getScenePlayerInfo().marryNick;
				switch(type)
				{
					case 1:
						typeStr = "の老公";
						break;
					case 2:
						typeStr = "の老婆";
						break;
					case 3:
						typeStr = "の小妾";
						break;
				}
				tmpContent += ("<font color='#00ccff'>"+ marryNick + typeStr+"</font>\n");
			}
			
			if(isClubEnemy)
			{
				tmpContent += "<font color='#FF0000'>"+LanguageManager.getWord("ssztl.skill.enemy")+"·</font>";
			}
			if(isHasClub)
			{
				var clubName:String = getScenePlayerInfo().info.clubName;
				if(clubName == GlobalData.cityCraftInfo.defenseGuild)
					clubName = clubName+"[王城帮会]";
				tmpContent += "<font color='#6ef12e'>["+LanguageManager.getWord("ssztl.scene.clubShortWrite")+"] "+clubName+"</font>\n";
			}
			
			if(isVip)
			{
				tmpContent += "<font color='#" + tmpColor + "'>VIP·</font>";
			}
			
			var color:String = getNickColor();
			tmpContent +="<font color='#" + color + "'>" + getScenePlayerInfo().info.nick + "</font>";
			
			nick.htmlText = tmpContent;
			
			bloodBar.move(-30,-120);
			
			if(isInShenMoWar)
			{
//				tmpContent += "<font color='#" + WarType.getStateColorString(getScenePlayerInfo().warState) +"'>" + WarType.getNameByWarState(getScenePlayerInfo().warState) + "·</font>";
				if(!_warCampIcon)
				{
					_warCampIcon = new Bitmap(getCampIcon(getScenePlayerInfo().warState));
					_warCampIcon.x = -nick.textWidth*0.5 - _warCampIcon.width + 10;
					_warCampIcon.y = getNickY() + nick.textHeight - 27;
				}
				nick.x = -60;
			}else
			{
				if(_warCampIcon && _warCampIcon.parent)
				{
					_warCampIcon.parent.removeChild(_warCampIcon);
					_warCampIcon = null;
				}
				nick.x = -75;
			}
			
//			updateSpecialTitle();
		}
		private function getCampIcon(id:int):BitmapData
		{
			var bd:BitmapData;
			switch(id)
			{
				case CampType.SHEN:
					bd =  new WarCampIcon1() as BitmapData
					break;
				case CampType.MO:
					bd =  new WarCampIcon2() as BitmapData
					break;
				case CampType.REN:
					bd =  new WarCampIcon3() as BitmapData
					break;
				case CampType.ATK_CITY:
					bd =  new WarCampIcon1() as BitmapData
					break;
				case CampType.DEF_CITY:
					bd =  new WarCampIcon2() as BitmapData
					break;
			}
			return bd;
		}
		
//		private function updateSpecialTitle():void
//		{
//			var titleCount:int = 0;
//			var levelFirst:Boolean = getScenePlayerInfo().info.getIsLevelFirst();
//			var levelSecond:Boolean = getScenePlayerInfo().info.getIsLevelSecond();
//			var levelThird:Boolean = getScenePlayerInfo().info.getIsLevelThird();
//			var moneyFirst:Boolean = getScenePlayerInfo().info.getIsMoneyFirst();
//			var moneySecond:Boolean = getScenePlayerInfo().info.getIsMoneySecond();
//			var moneyThird:Boolean = getScenePlayerInfo().info.getIsMoneyThird();
//			var powerFirst:Boolean = getScenePlayerInfo().info.getIsPowerFirst();
//			var powerSecond:Boolean = getScenePlayerInfo().info.getIsPowerSecond();
//			var powerThird:Boolean = getScenePlayerInfo().info.getIsPowerThird();
////			var levelFirst:Boolean = true;
////			var moneyFirst:Boolean = false;
////			var powerFirst:Boolean = true;			
//			if(levelFirst || levelSecond || levelThird)
//			{
//				_levelTitleAsset = new Bitmap();
//				addChild(_levelTitleAsset);
//				_levelTitleAsset.x = -55;
//				_levelTitleAsset.y = -220 - titleCount * 40;
//				titleCount++;
//				var t:BitmapData; 
//				if(levelFirst) t = AssetUtil.getAsset("mhsm.scene.LevelTitleAsset1") as BitmapData;
//				else if(levelSecond) t = AssetUtil.getAsset("mhsm.scene.LevelTitleAsset2") as BitmapData;
//				else if(levelThird) t = AssetUtil.getAsset("mhsm.scene.LevelTitleAsset3") as BitmapData;
//				if(t)
//				{
//					_levelTitleAsset.bitmapData = t;
//				}
//			}
//			if(moneyFirst || moneySecond || moneyThird)
//			{
//				_moneyTitleAsset = new Bitmap();
//				addChild(_moneyTitleAsset);
//				_moneyTitleAsset.x = -55;
//				_moneyTitleAsset.y = -220 - titleCount * 40;
//				titleCount++;
//				if(moneyFirst) t = AssetUtil.getAsset("mhsm.scene.MoneyTitleAsset1") as BitmapData;
//				else if(moneySecond) t = AssetUtil.getAsset("mhsm.scene.MoneyTitleAsset2") as BitmapData;
//				else if(moneyThird) t = AssetUtil.getAsset("mhsm.scene.MoneyTitleAsset3") as BitmapData;
//				if(t)
//				{
//					_moneyTitleAsset.bitmapData = t;
//				}
//			}
//			if(powerFirst || powerSecond || powerThird)
//			{
//				_powerTitleAsset = new Bitmap();
//				addChild(_powerTitleAsset);
//				_powerTitleAsset.x = -55;
//				_powerTitleAsset.y = -220 - titleCount * 40;
//				if(powerFirst) t = AssetUtil.getAsset("mhsm.scene.PowerTitleAsset1") as BitmapData;
//				else if(powerSecond) t = AssetUtil.getAsset("mhsm.scene.PowerTitleAsset2") as BitmapData;
//				else if(powerThird) t = AssetUtil.getAsset("mhsm.scene.PowerTitleAsset3") as BitmapData;
//				if(t)
//				{
//					_powerTitleAsset.bitmapData = t;
//				}
//			}
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
//		}
		
//		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
//		{
//			if(_levelTitleAsset && _levelTitleAsset.bitmapData == null) 
//			{
//				if(getScenePlayerInfo().info.getIsLevelFirst()) _levelTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.LevelTitleAsset1") as BitmapData;
//				else if(getScenePlayerInfo().info.getIsLevelSecond()) _levelTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.LevelTitleAsset2") as BitmapData;
//				else if(getScenePlayerInfo().info.getIsLevelThird()) _levelTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.LevelTitleAsset3") as BitmapData;
//			}
//			if(_moneyTitleAsset && _levelTitleAsset.bitmapData == null) 
//			{
//				if(getScenePlayerInfo().info.getIsMoneyFirst()) _moneyTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.MoneyTitleAsset1") as BitmapData;
//				else if(getScenePlayerInfo().info.getIsMoneySecond()) _moneyTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.MoneyTitleAsset2") as BitmapData;
//				else if(getScenePlayerInfo().info.getIsMoneyThird()) _moneyTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.MoneyTitleAsset3") as BitmapData;
//			}
//			if(_powerTitleAsset && _levelTitleAsset.bitmapData == null) 
//			{
//				if(getScenePlayerInfo().info.getIsPowerFirst()) _powerTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.PowerTitleAsset1") as BitmapData;
//				else if(getScenePlayerInfo().info.getIsPowerSecond()) _powerTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.PowerTitleAsset2") as BitmapData;
//				else if(getScenePlayerInfo().info.getIsPowerThird()) _powerTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.PowerTitleAsset3") as BitmapData;
//			}
//		}
		
		protected function transportUpdateHandler(e:BaseRoleInfoUpdateEvent):void
		{
		}
		
		override public function doWalkAction():void
		{
//			if(_isSit || NewAttackStateType.isHitDown(getScenePlayerInfo().newAttackState))return;
			if(_isSit || getScenePlayerInfo().getIsDeadOrDizzy())return;
			doWalk();
		}
		
		override public function get titleY():Number
		{
			return  -getScenePlayerInfo().info.getPicHeight();
		}
		
		private function characterCompleteHandler(evt:Event):void
		{
			_character.removeEventListener(Event.COMPLETE,characterCompleteHandler);
			if(isMoving)doWalk();
		}
		
		public function getScenePlayerInfo():BaseScenePlayerInfo
		{
			return _info as BaseScenePlayerInfo;
		}
		
		override protected function initCharacter():void
		{
			var t:BaseScenePlayer = this;
			updateShadow();
			newCharacter();
			_character.addEventListener(Event.COMPLETE,characterCompleteHandler);
//			if(getScenePlayerInfo() && getScenePlayerInfo().warState == 6)
//			{
//				_character.show(DirectType.BOTTOM);
//			}
//			else
//			{
				_character.show(DirectType.getRandomDir());
//			}
			if(_isSit)
			{
				_character.move(0,0);
			}
			else
			{
				if(_getMounts)
				{
					_character.move(0,-50);
				}
				else
				{
					_character.move(0,0);
				}
			}
			addChildAt(_character as DisplayObject,0);
			updateAllStrengthEffect();
//			if(NewAttackStateType.isHitDown(getScenePlayerInfo().newAttackState))
//			{
//				_character.doAction(SceneCharacterActions.HITDOWN);
//			}
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
				_timeoutIndex = -1;
			}
			_timeoutIndex = setTimeout(doSwap,100);
		}
		private function doSwap():void
		{
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
				_timeoutIndex = -1;
			}
			if(!_mediator || !_mediator.sceneInfo || !_mediator.sceneInfo.mapInfo || !getScenePlayerInfo())return;
			invalidate(InvalidationType.STYLES);
//			if(_mediator.sceneInfo.mapInfo.isSpaScene() && getScenePlayerInfo().warState == 5)
//			{
//				hideShadow();
//			}
//			else
//			{
//				showShadow();
//			}
		}
		private function newCharacter():void
		{
			if(_mediator.sceneInfo.mapInfo.isSpaScene())
			{
				if(getScenePlayerInfo().warState == 5)
				{
					_character = GlobalAPI.characterManager.createSwimCharacter(getScenePlayerInfo().info);
				}
				else
				{
					_character = GlobalAPI.characterManager.createSpaCharacter(getScenePlayerInfo().info);
				}
//				nick.y = titleY ;
			}
			else
			{
				if(_isSit)
				{
					_character = GlobalAPI.characterManager.createSceneSitCharacter(getScenePlayerInfo().info);
					doSit();
//					nick.y = titleY ;
				}
				else
				{
					if(_getMounts)
					{
						_character = GlobalAPI.characterManager.createMountsRunChatacter(getScenePlayerInfo().info);
//						nick.y = titleY - 50;
//						if(bloodBar)bloodBar.y = nick.y + 35;
					}
					else
					{
						_character = GlobalAPI.characterManager.createSceneCharacter(getScenePlayerInfo().info);
//						nick.y = titleY ;
//						if(bloodBar)bloodBar.y = nick.y + 35;
					}
					unDoSit();
				}
//				if(NewAttackStateType.isHitDown(getScenePlayerInfo().newAttackState))
//				{
//					_character.doAction(SceneCharacterActions.HITDOWN);
//				}
				if(getScenePlayerInfo().getIsDead())
				{
					_character.doActionType(ActionType.DEAD);
				}
				
				if(getScenePlayerInfo().getIsDizzy())
				{
					_character.doActionType(ActionType.DIZZY);
				}
			}
			invalidate(InvalidationType.STYLES);
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
				_timeoutIndex = -1;
			}
			_timeoutIndex = setTimeout(doSwap,100);
			setFigureVisible(_figureVisible);
		}
		protected function doSit():void
		{
//			if(!(_strengthAllEffect && _strengthAllEffect.parent))
//			{
//				createSitEffect();
//			}
			invalidate(InvalidationType.STYLES);
		}
		protected function unDoSit():void
		{
//			clearSitEffect();
			invalidate(InvalidationType.STYLES);
		}
		protected function createSitEffect():void
		{
			if(_figureVisible)
			{
				if(_sitEffect == null)
				{
					_sitEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.SIT_EFFECT));
				}
				_sitEffect.play(SourceClearType.NEVER);
				addChild(_sitEffect);
//				hideShadow();
			}
		}
		protected function clearSitEffect():void
		{
			if(_sitEffect)
			{
				_sitEffect.stop();
				if(_sitEffect.parent)_sitEffect.parent.removeChild(_sitEffect);
			}
//			showShadow();
		}
		
		public function updatePlayerNick():void
		{
			if(SharedObjectManager.hidePlayerName.value == true)
			{
				if(nick.parent)nick.parent.removeChild(nick);
			}
			else
			{
				if(nick.parent != this)addChild(nick);
			}
		}
		
		override protected function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			super.playerStateUpdateHandler(e);
			if(getScenePlayerInfo().state.getDead())
			{
				doDead();
//				if(_hitDownAsset == null || _hitDownAsset.parent == null)
//				{
//				}
			}
			else if(getScenePlayerInfo().state.getDizzy())
			{
				doDizzy();
			}
			else
			{
				doStand();
				if(_hitDownAsset && _hitDownAsset.parent)_hitDownAsset.parent.removeChild(_hitDownAsset);
			}
			if(_isPoison != getScenePlayerInfo().getIsPoison())
			{
				_isPoison = getScenePlayerInfo().getIsPoison();
				updateFilters();
			}
		}
		
		override public function doMouseOver():void
		{
			_isMouseOn = true;
			updateFilters();
		}
		
		override public function doMouseOut():void
		{
			_isMouseOn = false;
			updateFilters();
		}
		
		private function updateFilters():void
		{
			if(_character)
			{
				if(_isMouseOn && _isPoison)
				{
					_character.filters = [OVER_EFFECT,POISON_EFFECT];
				}
				else if(_isMouseOn && !_isPoison)
				{
					_character.filters = [OVER_EFFECT];
				}
				else if(!_isMouseOn && _isPoison)
				{
					_character.filters = [POISON_EFFECT];
				}
				else
				{
					_character.filters = null;
				}
			}
		}
		
		override protected function walkStartHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			super.walkStartHandler(evt);
			doWalk();
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLES))
			{
				var reloadStrength:Boolean = false;
				var strengthLevel:int = 0;
				if(getScenePlayerInfo() && getScenePlayerInfo().info)
				{
					strengthLevel = getScenePlayerInfo().info.getAllStrengthLevel();
					if(strengthLevel != _currentStrengthLevel)
					{
						_currentStrengthLevel = strengthLevel;
						reloadStrength = true;
					}
				}
				if(_currentStrengthLevel >= 5)
				{
					if(!_figureVisible)
					{
						hideStrengthAllEffect();
					}
					else if(reloadStrength || _figureVisibleChange)
					{
						showStrengthAllEffect();
					}
					clearSitEffect();
//					hideShadow();
					if(_strengthAllEffect && _strengthAllEffect.parent == this)
					{
						setChildIndex(_strengthAllEffect as DisplayObject,numChildren - 1);
					}
				}
				else if(_isSit)
				{
					hideStrengthAllEffect();
					hideShadow();
					if(_figureVisible)
						createSitEffect();
					else clearSitEffect();
				}
				else
				{
					hideStrengthAllEffect();
					clearSitEffect();
					if(_figureVisible)showShadow();
					else hideShadow();
				}
			}
			_figureVisibleChange = false;
			super.draw();
		}
		
		protected function doWalk():void
		{
			if(!_character.currentAction) return;
			if(_mediator.sceneInfo.mapInfo.isSpaScene())
			{
				if(getScenePlayerInfo().warState == 5)
				{
					if(_character)_character.doAction(SceneSwimActions.WALK);
				}
				else
				{
					if(_character)_character.doAction(SceneSpaActions.WALK);
				}
			}
			else
			{
				if(!_isSit)
				{
					if(_getMounts)
					{
						if(_character.currentAction.actionType != ActionType.WALK)
							_character.doActionType(ActionType.WALK);
					}
					else
					{
						if(_character.currentAction.actionType != ActionType.WALK)
							_character.doActionType(ActionType.WALK);
					}
				}
			}
		}
		protected function doStand():void
		{
			if(!_character.currentAction) return;
			if(_mediator.sceneInfo.mapInfo.isSpaScene())
			{
				if(getScenePlayerInfo().warState == 5)
				{
					if(_character)_character.doAction(SceneSwimActions.STAND);
				}
				else
				{
					if(_character)_character.doAction(SceneSpaActions.STAND);
				}
			}
			else
			{
				if(!_isSit)
				{
//					if(_getMounts)
//						_character.doActionType(ActionType.STAND);
					if( _character.currentAction.actionType != ActionType.ATTACK)
						_character.doActionType(ActionType.STAND);
				}
			}
		}
		
		protected function doDead():void
		{
			_character.doActionType(ActionType.DEAD);
		}
		
		protected function doDizzy():void
		{
			_character.doActionType(ActionType.DIZZY);
		}
		/**
		 * 回复正常
		 * 
		 */		
		protected function doCommonAction():void
		{
			var info:BaseRoleInfo = getBaseRoleInfo();
			if(info)
			{
//				if(!(NewAttackStateType.isHitDown(info.newAttackState)))
//				{
//					doStand();
//				}
				if(!info.getIsDeadOrDizzy())
				{
					doStand();
				}
				else if(info.getIsDizzy())
				{
					doDizzy();
				}
				else
				{
					doDead();
				}
			}
		}
		
		override protected function walkComplete():void
		{
			super.walkComplete();
			doCommonAction();
		}
		
		override protected function getTotalHP():int
		{
			return getScenePlayerInfo().totalHp;
		}
		
		override protected function getCurrentHP():int
		{
			return getScenePlayerInfo().currentHp;
		}
		
		protected function upgradeHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			if(_upgradeEffect)
			{
				_upgradeEffect.removeEventListener(Event.COMPLETE,upgradeEffectCompleteHandler);
				_upgradeEffect.dispose();
			}
			_upgradeEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.UPGRADE_EFFECT));
			_upgradeEffect.move(0,0);
			_upgradeEffect.play(SourceClearType.NEVER);
			addChild(_upgradeEffect as DisplayObject);
			_upgradeEffect.addEventListener(Event.COMPLETE,upgradeEffectCompleteHandler);
			
		}
		
		private function upgradeEffectCompleteHandler(evt:Event):void
		{
			_upgradeEffect.removeEventListener(Event.COMPLETE,upgradeEffectCompleteHandler);
			_upgradeEffect = null;
		}
		
		override public function dispose():void
		{
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
				_timeoutIndex = -1;
			}
			if(_upgradeEffect)
			{
				_upgradeEffect.removeEventListener(Event.COMPLETE,upgradeEffectCompleteHandler);
				_upgradeEffect.dispose();
			}
			if(_sitEffect)
			{
				_sitEffect.dispose();
				_sitEffect = null;
			}
			if(_character)
			{
				_character.removeEventListener(Event.COMPLETE,characterCompleteHandler);
			}
			if(_hitDownAsset && _hitDownAsset.parent)
			{
				_hitDownAsset.parent.removeChild(_hitDownAsset);
				_hitDownAsset = null;
			}
//			if(_strength7Effect)
//			{
//				_strength7Effect.dispose();
//				_strength7Effect = null;
//			}
//			if(_strength9Effect)
//			{
//				_strength9Effect.dispose();
//				_strength9Effect = null;
//			}
			if(_strengthAllEffect)
			{
				_strengthAllEffect.dispose();
				_strengthAllEffect = null;
			}
			if(_roleAutoEffect)
			{				
				_roleAutoEffect.dispose();
				_roleAutoEffect = null;
			}
			_powerTitleAsset = null;
			_levelTitleAsset = null;
			_moneyTitleAsset = null;
			_mediator = null;
			super.dispose();
		}
	}
}