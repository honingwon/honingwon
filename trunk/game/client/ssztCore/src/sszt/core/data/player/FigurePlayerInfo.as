package sszt.core.data.player
{
	import flash.utils.Dictionary;
	
	import sszt.constData.ActionType;
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.core.data.characterActionInfos.SceneMountsActionInfo;
	import sszt.core.data.characterActionInfos.SceneSitActions;
	import sszt.core.data.characterActionInfos.SceneSpaActions;
	import sszt.core.data.characterActionInfos.SceneSwimActions;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.titles.TitleNameEvents;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.PackageUtil;
	import sszt.events.CharacterEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.module.ModuleEventDispatcher;
	
	public class FigurePlayerInfo extends TipPlayerInfo implements ICharacterInfo
	{
		/**
		 *vip类型 
		 */		
		public var vipType:int;
		/**
		 * 称号
		 */		
		public var title:int;
		/**
		 * 是否隐藏称号(false是公开，true是隐藏)
		 * */
		public var isTitleHide:Boolean;
		/**
		 * 阵营(帮会)
		 */		
		public var camp:int;
		/**
		 * 帮会ID
		 */		
		public var clubId:Number;
		/**
		 * 帮会名
		 */		
		public var clubName:String = "";
		/**
		 *帮会等级 
		 */		
		public var clubLevel:int = -1;
		/**
		 * 帮会神炉等级
		 */
		public var clubFurnaceLevel:int;
		/**
		 *神炉需求贡献 
		 */		
		public var furnaceNeedExploit:int;
		/**
		 *帮会财富 
		 */		
		public var clubRich:int;
		/**
		 *个人功勋 
		 */		
		public var selfExploit:int;
		/**
		 *历史总贡献 
		 */
		public var totalExploit:int;
		/**
		 * 帮会职务
		 */		
		public var clubDuty:int;
		/**
		 * 职业
		 */		
		public var career:int;
		
		
		/**
		 * null是正常状态,"不为空"是摆摊状态 
		 */		
		public var stallName:String = "";
		/**
		 * 衣服，武器，骑宠，翅膀
		 */		
		private var _style:Array;
		/**
		 * 是否骑宠
		 */		
		private var _getMounts:Boolean;
		/**
		 * 宠物是否激活
		 */		
		private var _mountAvoid:Boolean;
		/**
		 * 是否打坐
		 */		
		private var _isSit:Boolean;
		/**
		 * 是否历练专修状态
		 */
		public var isLifexpSitState:Boolean;
		/**
		 * PK模式
		 */		
		public var PKMode:int;
		/**
		 * PK值
		 */		
		private var _PKValue:int;
		/**
		 *帮会敌对列表 
		 */		
		public var clubEnemyList:Array = [];
		/**
		 * 强化等级(全套)
		 */		
		public var strengthLevel:int;
		
		public var mountsStrengthLevel:int;
		/**
		 * 隐藏时装
		 */		
		public var hideSuit:Boolean;
		public var hideWeapon:Boolean;
		public var picWidth:int = 50 ;
		public var picHeight:int = 150;
		
		
		/**
		 * buff称号 
		 */		
		private var _buffTitleId:int = 0;
		
		public var frameRates:Dictionary = new Dictionary;
		
		
		public function get PKValue():int
		{
			return _PKValue;
		}
		public function set PKValue(value:int):void
		{
			if(_PKValue == value)return;
			_PKValue = value;
			dispatchEvent(new PlayerInfoUpdateEvent(PlayerInfoUpdateEvent.PKVALUE_CHANGE));
		}
		
		public function FigurePlayerInfo()
		{
			super();
			_style = new Array(4);
		}
		
		public function get characterId():uint
		{
			return userId;
		}
		public function get style():Array
		{
			return _style;
		}
		public function updateStyle(cloth:int,weapon:int,mounts:int,wing:int,strengthLevel:int,mountsStrengthLevel:int,hideWeapon:Boolean = false,hideSuit:Boolean = false,mountAvoid:Boolean = false,isSit:Boolean = false):void
		{
			if(_style[0] == cloth && _style[1] == weapon && _style[2] == mounts && _style[3] == wing && _mountAvoid == mountAvoid && _isSit == isSit && this.strengthLevel == strengthLevel && this.mountsStrengthLevel == mountsStrengthLevel && this.hideWeapon == hideWeapon && this.hideSuit == hideSuit)return;
			_style = [cloth,weapon,mounts,wing];
			this.strengthLevel = strengthLevel;
			this.mountsStrengthLevel = mountsStrengthLevel;
			this.hideWeapon = hideWeapon;
			this.hideSuit = hideSuit;
			_getMounts = _style[2] > 0;
			_mountAvoid = mountAvoid;
			_isSit = isSit;
			dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_UPDATE));
		}
		public function setActivityCloth(cloth:int):void
		{
			if(_style[0] == cloth)return;
			_style = [cloth,_style[1],_style[2],_style[3]];
			dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_UPDATE));
		}
		
		public function updateClubEnemyList(argClubEnemyList:Array):void
		{
			clubEnemyList = argClubEnemyList;
			dispatchEvent(new TitleNameEvents(TitleNameEvents.TITLE_NAME_UPDATE));
		}
		
		public function clearClubEnemyList():void
		{
			clubEnemyList.length = 0;
			dispatchEvent(new TitleNameEvents(TitleNameEvents.TITLE_NAME_UPDATE));
		}
		
		public function isClubEnemy(argClubId:Number):Boolean
		{
			return clubEnemyList.indexOf(argClubId) != -1;
		}
		
		public function updateVipType(argVipType:int):void
		{
			vipType = argVipType;
			dispatchEvent(new TitleNameEvents(TitleNameEvents.TITLE_NAME_UPDATE));
		}
		public function getVipType():int
		{
			var type:int = 0;
			if((vipType & 4) > 0)type = 1;
			else if((vipType & 8) > 0)type = 2;
			else if((vipType & 16) > 0)type = 3;
			else if((vipType & 32) > 0)type = 4;
			else if((vipType & 64) > 0)type = 5;
			return type;
		}
		public function getIsNewlyGuild():Boolean
		{
			return (vipType & 1) > 0
		}
		public function getIsGM():Boolean
		{
			return (vipType & 2) > 0;
		}
		
		public function getIsPowerFirst():Boolean
		{
			return (vipType & 32) > 0;
		}
		
		public function getIsPowerSecond():Boolean
		{
			return (vipType & 64) > 0;
		}
		
		public function getIsPowerThird():Boolean
		{
			return (vipType & 128) > 0;
		}
		
		public function getIsMoneyFirst():Boolean
		{
			return (vipType & 256) > 0;
		}
		
		public function getIsMoneySecond():Boolean
		{
			return (vipType & 512) > 0;
		}
		
		public function getIsMoneyThird():Boolean
		{
			return (vipType & 1024) > 0;
		}
		
		public function getIsLevelFirst():Boolean
		{
			return (vipType & 2048) > 0;
		}
		
		public function getIsLevelSecond():Boolean
		{
			return (vipType & 4096) > 0;
		}
		
		public function getIsLevelThird():Boolean
		{
			return (vipType & 8192) > 0;
		}
		
		public function updateRoleTitle(argTitle:int,argIsHide:Boolean):void
		{
			title = argTitle;
			isTitleHide = argIsHide;
			dispatchEvent(new TitleNameEvents(TitleNameEvents.TITLE_NAME_UPDATE));
			dispatchEvent(new TitleNameEvents(TitleNameEvents.TITLE_NAME_CHANGE));
		}
		
		public function get buffTitleId():int
		{
			return _buffTitleId;
		}
		
		public function set buffTitleId(value:int):void
		{
			if (_buffTitleId == value) return;
			_buffTitleId = value;
			dispatchEvent(new TitleNameEvents(TitleNameEvents.TITLE_NAME_UPDATE));
		}
		
		public function updateSelfExploit(argExpoit:int):void
		{
			selfExploit = argExpoit;
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE));
		}
		
		public function updateExploit(total:int,current:int):void
		{
			totalExploit = total;
			updateExploit1(current);
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.SELFEXPLOIT_UPDATE));
		}
		
		private function updateExploit1(value:int):void
		{
			if(selfExploit == value)return;
			var old:int = selfExploit;
			selfExploit = value >= 0 ? value : 0;
			var temp:int  = selfExploit - old;
			if(temp <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainExploit",temp);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		public function set mountAvoid(value:Boolean):void
		{
			if(_mountAvoid == value)return;
			updateStyle(_style[0],_style[1],_style[2],_style[3],strengthLevel,mountsStrengthLevel,hideWeapon,hideSuit,value);
		}
		public function get mountAvoid():Boolean
		{
			return _mountAvoid;
		}
		
		public function get fightMounts():Boolean
		{
			return _getMounts;
		}	
		
		
		public function setSit(value:Boolean):void
		{
			if(_isSit == value)return;
			updateStyle(_style[0],_style[1],_style[2],_style[3],strengthLevel,mountsStrengthLevel,hideWeapon,hideSuit,_mountAvoid,value);
		}
		
		public function isSit():Boolean
		{
			return _isSit;
		}
		
		public function getSex():int
		{
			return sex ? 1 : 2;
		}
		
		public function getPicWidth():int { return picWidth; }
		public function getPicHeight():int { return picHeight; }
		
		
		public function getPartStyle(categoryId:int):int
		{
			return 0;
		}
		
		public function getLayerInfoById(id:int):ILayerInfo
		{
			return ItemTemplateList.getTemplate(id);
		}
		public function getDefaultLayer(category:int):ILayerInfo
		{
			switch(category)
			{
				case CategoryType.CLOTH_SHANGWU:
					return ItemTemplateList.getTemplate(214001);
					break;
				case CategoryType.CLOTH_XIAOYAO:
					return ItemTemplateList.getTemplate(216001);
					break;
				case CategoryType.CLOTH_LIUXING:
					return ItemTemplateList.getTemplate(215001);
					break;
			}
			return null;
		}
		
		public function getDefaultAction(type:String):ICharacterActionInfo
		{
			return null;
		}
		
		public function getDefaultActionType(type:String):int
		{
			switch(type)
			{
				case LayerType.SCENE_PLAYER:
					return ActionType.STAND;
//				case LayerType.SCENE_MOUNTS:
//					return SceneMountsActionInfo.STAND;
				case LayerType.SCENE_SIT:
					return ActionType.SIT;
					//				case LayerType.SPA:
					//					return SceneSpaActions.STAND;
					//				case LayerType.SWIM:
					//					return SceneSwimActions.STAND;
			}
			return ActionType.STAND;
		}
		
		
		public function getCareer():int
		{
			return career;
		}
		
		public function getMounts():Boolean
		{
			return _getMounts && _mountAvoid;
		}		
		
		public function getWindStrength():int
		{
//			if((strengthLevel & 16) > 0)return 10;
			return 0;
		}
		public function getWeaponStrength():int
		{
//			if((strengthLevel & 4 ) > 0)return 10;
//			else if((strengthLevel & 8) > 0)return 7;
			return 0;
		}
		public function getCloseStrength():int
		{
			if((strengthLevel & 1) > 0)return 9;
			else if((strengthLevel & 2) > 0)return 7;
			return 0;
		}
		
		public function getAllStrengthLevel():int
		{
			if((strengthLevel & 32) > 0)return  5;
			else if((strengthLevel & 64) > 0)return 6;
			else if((strengthLevel & 128) > 0)return 7;
			else if((strengthLevel & 256) > 0)return 8;
			else if((strengthLevel & 512) > 0)return 9;
			else if((strengthLevel & 1024) > 0)return 10;
			else if((strengthLevel & 2048) > 0)return 11;
			else if((strengthLevel & 4096) > 0)return 12;
			return 0;
		}
		
		public function getMountsStrengthLevel():int
		{
			return mountsStrengthLevel;
		}
		
		public function getHideWeapon():Boolean
		{
			return hideWeapon;
		}
		
		public function getHideSuit():Boolean
		{
			return hideSuit;
		}
		
		public function updateClubInfo(clubId:Number,clubName:String,camp:int,clubDuty:int):void
		{
			this.clubId = clubId;
			this.clubName = clubName;
//			this.clubLevel = clubLevel:
			this.camp = camp;
			this.clubDuty = clubDuty;
			dispatchEvent(new PlayerInfoUpdateEvent(PlayerInfoUpdateEvent.CLUBINFO_UPDATE));
		}
		
		public function updateCampType():void
		{
			dispatchEvent(new SelfPlayerInfoUpdateEvent(SelfPlayerInfoUpdateEvent.CAMP_TYPE_UPDATE));
		}
		
		public function getFrameRate(actionType:int):int
		{
			if(frameRates.hasOwnProperty(actionType))
			{
				return frameRates[actionType];
			}
			else if(frameRates.hasOwnProperty(0))
			{
				return frameRates[0];
			}
			return 3;
		}
		
		public function updateLifexpSitState(value:Boolean):void
		{
			isLifexpSitState = value;
			dispatchEvent(new PlayerInfoUpdateEvent(PlayerInfoUpdateEvent.LIFE_EXP_SIT_STATE_UPDATE));
		}
	}
}
