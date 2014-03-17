package sszt.scene.components.elementInfoView
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseBuffCell;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.ui.SmallBtnCloseAsset;
	
	public class BaseElementInfoView extends Sprite
	{
		protected var _mediator:ElementInfoMediator;
		protected var _bg:Bitmap;
		protected var _headAsset:Bitmap;
		protected var _mask:Sprite;           //鼠标点击区域
		protected var _nameField:MAssetLabel;
		protected var _levelField:MAssetLabel;
		protected var _hpBar:ProgressBar1;
		protected var _info:BaseRoleInfo;
		protected var _buffTile:MTile;
		protected var _buffItems:Array;
		protected var _closeBtn:MBitmapButton;
		
		
		private static var _bgAsset1:BitmapData;
		private static var _bgAsset2:BitmapData;
		private static var _bgAsset3:BitmapData;
		private static var _hpBgAsset1:BitmapData;
		private static var _mpBgAsset1:BitmapData;
		private static var _hpBgAsset2:BitmapData;
		private static var _hpBgAsset3:BitmapData;
		private static var _hpBgAsset4:BitmapData;
		private static var _hpBarAsset:MovieClip;
		private static var _closeBtnAsset:BitmapData;
		private static var _SpBgAsset1:BitmapData;
		private static var _mpBarAsset:MovieClip;
		
		private static var _petHpAsset:BitmapData;
		private static var _petExpAsset:BitmapData;
		
//		public static function getSceneOtherInfoBgAsset():BitmapData
//		{
//			if(!_sceneOtherInfoBgAsset)
//			{
//				_sceneOtherInfoBgAsset = AssetUtil.getAsset("ssztui.scene.SceneOtherInfoBgAsset") as BitmapData;
//			}
//			return _sceneOtherInfoBgAsset;
//		}
		
//		public static function getSceneOtherInfoBgAsset():BitmapData
//		{
//			if(!_sceneOtherInfoBgAsset)
//			{
//				_sceneOtherInfoBgAsset = AssetUtil.getAsset("ssztui.scene.SceneOtherInfoBgAsset") as BitmapData;
//			}
//			return _sceneOtherInfoBgAsset;
//		}
		
		/**主角头像背景**/
		public static function getBgAsset1():BitmapData
		{
			if(!_bgAsset1)
			{
				_bgAsset1 = AssetUtil.getAsset("ssztui.scene.SceneSelfInfoBgAsset") as BitmapData;
			}
			return _bgAsset1;
		}
		
		/**玩家头像背景**/
		public static function getBgAsset2():BitmapData
		{
			if(!_bgAsset2)
			{
				_bgAsset2 = AssetUtil.getAsset("ssztui.scene.SceneOtherInfoBgAsset") as BitmapData;
			}
			return _bgAsset2;
		}
		
		/**怪物信息背景**/
		public static function getBgAsset3():BitmapData
		{
			if(!_bgAsset3)
			{
				_bgAsset3 = AssetUtil.getAsset("ssztui.scene.SceneMonsterBgAsset") as BitmapData;
			}
			return _bgAsset3;
		}
		/**主角血条**/
		public static function getHpBgAsset1():BitmapData
		{
			if(!_hpBgAsset1)
			{
				_hpBgAsset1 = AssetUtil.getAsset("ssztui.scene.SelfSceneHpBgAsset") as BitmapData;
			}
			return _hpBgAsset1;
		}
		/**查看角色血条**/
		public static function getHpBgAsset2():BitmapData
		{
			if(!_hpBgAsset2)
			{
				_hpBgAsset2 = AssetUtil.getAsset("ssztui.scene.ScenePlayerHPAsset") as BitmapData;
			}
			return _hpBgAsset2;
		}
		
		/**怪物血条**/
		public static function getHpBgAsset3():BitmapData
		{
			if(!_hpBgAsset3)
			{
				_hpBgAsset3 = AssetUtil.getAsset("ssztui.scene.SceneMonsterHPAsset") as BitmapData;
			}
			return _hpBgAsset3;
		}
		/**组队血条**/
		public static function getHpBgAsset4():BitmapData
		{
			if(!_hpBgAsset4)
			{
				_hpBgAsset4 = AssetUtil.getAsset("ssztui.scene.SceneTeamHPAsset") as BitmapData;
			}
			return _hpBgAsset4;
		}
		
		public static function getMpBgAsset1():BitmapData
		{
			if(!_mpBgAsset1)
			{
				_mpBgAsset1 = AssetUtil.getAsset("ssztui.scene.SelfSceneMpBgAsset") as BitmapData;
			}
			return _mpBgAsset1;
		}
		
		/*角色蓝条
		public static function getMpBarAsset():DisplayObject
		{
			if(!_mpBarAsset)
			{
				_mpBarAsset = AssetUtil.getAsset("ssztui.scene.SelfSceneMpBgAsset") as MovieClip;
				_mpBarAsset.width = 141;
			}
			return _mpBarAsset as DisplayObject;
		}*/		
		
		/**气条**/
		public static function getSpBgAsset1():BitmapData
		{			
			if(!_SpBgAsset1)
			{
				_SpBgAsset1 = AssetUtil.getAsset("ssztui.scene.SelfSceneSpBgAsset") as BitmapData;
			}
			return _SpBgAsset1;
		}
		/**宠物血条**/
		public static function getPetHptAsset():BitmapData
		{			
			if(!_petHpAsset)
			{
				_petHpAsset = AssetUtil.getAsset("ssztui.scene.PetHpBgAsset") as BitmapData;
			}
			return _petHpAsset;
		}
		/**宠物经验条**/
		public static function getPetExptAsset():BitmapData
		{			
			if(!_petExpAsset)
			{
				_petExpAsset = AssetUtil.getAsset("ssztui.scene.PetExpBgAsset") as BitmapData;
			}
			return _petExpAsset;
		}
		/**血条**/
		public static function getHpBarAsset(_w:Number=100):MovieClip
		{
			_hpBarAsset = new MovieClip();
			_hpBarAsset = AssetUtil.getAsset("ssztui.scene.SceneHpBarAsset") as MovieClip;
			_hpBarAsset.width = _w;
			
			return _hpBarAsset;
		}
		
		
		/*
		public static function getCloseBtnAsset():BitmapData
		{
			if(!_closeBtnAsset)
			{
				_closeBtnAsset = AssetUtil.getAsset("ssztui.scene.SceneCloseBtnAsset") as BitmapData;
			}
			return _closeBtnAsset;
		}
		*/
		//value取值范围-1~1,对应Flash内容制作工具里的-100%-100%
		public static function setBrightness(obj:DisplayObject,value:Number):void {
			var colorTransformer:ColorTransform = obj.transform.colorTransform;
			var backup_filters:* = obj.filters;
			if (value >= 0) {
				colorTransformer.blueMultiplier = 1-value;
				colorTransformer.redMultiplier = 1-value;
				colorTransformer.greenMultiplier = 1-value;
				colorTransformer.redOffset = 255*value;
				colorTransformer.greenOffset = 255*value;
				colorTransformer.blueOffset = 255*value;
			}
			else {
				value=Math.abs(value)
				colorTransformer.blueMultiplier = 1-value;
				colorTransformer.redMultiplier = 1-value;
				colorTransformer.greenMultiplier = 1-value;
				colorTransformer.redOffset = 0;
				colorTransformer.greenOffset = 0;
				colorTransformer.blueOffset = 0;
			}
			obj.transform.colorTransform = colorTransformer;
			obj.filters = backup_filters;
		}
		
		private static var _petHead:BitmapData;
		
		protected static var headAssets:Array = [];
		protected static var headAssets1:Array = [];
		protected static var petHeadAssets:Array = [];
		
		public function BaseElementInfoView(mediator:ElementInfoMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		protected function init():void
		{
			_buffItems = [];
			initBg();
			initNameField();
			initLevelField();
			initProgressBar();
			initBuff();
			layout();
			initOthers();
		}
		
		public function setInfo(info:BaseRoleInfo):void
		{
			if(_info == info)return;
			var changeHead:Boolean = false;
			if(_info)
			{
				if(info)
				{
					if(_info.getObjType() != info.getObjType())changeHead = true;
					else
					{
						if(_info.getObjType() == MapElementType.PLAYER)
						{
							if(_info.getCareer() != info.getCareer() || _info.getSex() != info.getSex())changeHead = true;
						}
					}
				}
				removeEvent();
			}
			_info = info;
			clearView();
			initHead(changeHead);
			setValue();
			initBuffData();
			initEvent();
		}
		
		protected function initOthers():void
		{
		}
		
		public function getInfo():BaseRoleInfo
		{
			return  _info;
		}
		
		public function getHeadIcon():Sprite
		{
			return _mask;
		}
		
		protected function clearView():void
		{
			if(_nameField)_nameField.setValue("");
			if(_levelField)_levelField.setValue("");
			if(_buffTile)
			{
				_buffTile.disposeItems();
			}
//			for each(var i:BaseBuffCell in _buffItems)
//			{
//				i.dispose();
//			}
			_buffItems = [];
		}
		
		protected function setValue():void
		{
			if(_nameField)
			{
				if(MapTemplateList.isPerWarMap() && _info.getObjType() == MapElementType.PLAYER)
				{
						_nameField.setValue(LanguageManager.getWord("ssztl.scene.hideFaceMan"));
				}
				else if(_info.getServerId() == 0)_nameField.setValue(_info.getName());
				else _nameField.setValue("[" + _info.getServerId() + "]" + _info.getName());
			}
			if(_levelField)
			{
				var level:int = _info.getLevel();
				if(GlobalData.copyEnterCountList.isInCopy && !(_info is BaseScenePlayerInfo))
				{
					var tempCopy:CopyTemplateItem = CopyTemplateList.getCopy(GlobalData.copyEnterCountList.inCopyId);
					if(tempCopy && tempCopy.isDynamic)
					{
						level = level + (_mediator.sceneInfo.teamData.getAverageLevel() - tempCopy.minLevel);	
					}
				}
				_levelField.setValue(String(level.toString()));
			}
			if(_hpBar)_hpBar.setValue(_info.totalHp,_info.currentHp);
		}
		
		protected function initBg():void
		{
//			if(!_sceneOtherInfoBgAsset)
//			{
//				_sceneOtherInfoBgAsset = AssetUtil.getAsset("mhsm.scene.SceneOtherInfoBgAsset") as BitmapData;
//				_sceneHpBgAsset = AssetUtil.getAsset("mhsm.scene.SceneHpBgAsset") as BitmapData;
//				_sceneMpBgAsset = AssetUtil.getAsset("mhsm.scene.SceneMpBgAsset") as BitmapData;
//				_closeBtnAsset = AssetUtil.getAsset("mhsm.scene.SceneCloseBtnAsset") as BitmapData;
//			}
			_bg = new Bitmap();
			addChild(_bg);
			_mask = new Sprite();
			addChild(_mask);
			
			
//			_closeBtn = new MBitmapButton(getCloseBtnAsset());
			_closeBtn = new MBitmapButton(new SmallBtnCloseAsset() as BitmapData);
			_closeBtn.move(150,8);
			addChild(_closeBtn);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			
			
//			initBitmapdatas();
			
		}
		
		
		protected function initBitmapdatas():void
		{
			if(headAssets.length == 0)
			{
				headAssets.push(AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset1") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset2") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset3") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset4") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset5") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset6") as BitmapData);
			}
			
			
//			if(_info && _headAsset)
//			{
//				if(_info.getObjType() == MapElementType.PLAYER)
//					_headAsset.bitmapData = headAssets[CareerType.getHeadByCareerSex(_info.getCareer(),_info.getSex())];
//				else if(_info.getObjType() == MapElementType.PET)
//					_headAsset.bitmapData = _petHead;
//				else if(_info.getObjType() == MapElementType.MONSTER)
//					_headAsset.bitmapData = _monsterHead;
//			}
		}
		
		private function closeBtnClickHandler(e:MouseEvent):void
		{
			_mediator.sceneInfo.setCurrentSelect(null);
		}
		
//		protected function playerIconAssetComplete(evt:CommonModuleEvent):void
//		{
//			initBitmapdatas();
//		}
		
		protected function initHead(change:Boolean = true):void
		{
			if(!change && _headAsset)
			{
				if(!_headAsset.parent)addChildAt(_headAsset,0);
				return;
			}
			if(_headAsset && _headAsset.parent)_headAsset.parent.removeChild(_headAsset);
			_headAsset = new Bitmap();
			addChildAt(_headAsset,0);
			
//			if(_info.getObjType() == MapElementType.PLAYER)
//			{
//				if(headAssets.length > 0)
//				{
//					_headAsset.bitmapData = headAssets[CareerType.getHeadByCareerSex(_info.getCareer(),_info.getSex())];
//				}
//				_headAsset.width = _headAsset.height = 43;
//				_headAsset.x = 4;
//				_headAsset.y = 6;
//				_headAsset.filters = [new BlurFilter(1.3,1.3)];
//				addChildAt(_headAsset,0);
//			}
//			else if(_info.getObjType() == MapElementType.PET)
//			{
//				if(_petHead)_headAsset.bitmapData = _petHead;
//				_headAsset.width = _headAsset.height = 43;
//				_headAsset.x = 4;
//				_headAsset.y = 6;
//				_headAsset.filters = [new BlurFilter(1.3,1.3)];
//				addChildAt(_headAsset,0);
//			}
//			else if(_info.getObjType() == MapElementType.MONSTER)
//			{
//				if(_monsterHead)_headAsset.bitmapData = _monsterHead;
//				_headAsset.width = _headAsset.height = 43;
//				_headAsset.x = 4;
//				_headAsset.y = 6;
//				_headAsset.filters = [new BlurFilter(1.3,1.3)];
//				addChildAt(_headAsset,0);
//			}
		}
				
		protected function initNameField():void
		{
			_nameField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
//			_nameField.move(55,3);
			_nameField.setSize(90,18);
			_nameField.mouseEnabled = false;
			addChild(_nameField);
		}
		protected function initLevelField():void
		{
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE_EN,TextFormatAlign.CENTER);
			//_levelField.move(39,37);
			//_levelField.setSize(24,18);
			_levelField.mouseEnabled = false;
			addChild(_levelField);
		}
		
		protected function initProgressBar():void
		{
//			_hpBar = new ProgressBar(new Bitmap(getSceneHpAsset()),1,1,96,9,false,false);
//			_hpBar.move(50,24);
//			addChild(_hpBar);
		}
		
		protected function initBuff():void
		{
			_buffTile = new MTile(22,22,6);
			_buffTile.move(103,90);
			_buffTile.setSize(138,50);
			_buffTile.itemGapW = 1;
			_buffTile.verticalScrollPolicy = _buffTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_buffTile);
		}
		
		
		protected function layout():void
		{
			
		}
		
		protected function initEvent():void
		{
			_info.addEventListener(BaseRoleInfoUpdateEvent.ADDBUFF,addBuffHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.UPDATEBUFF,updateBuffHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.REMOVEBUFF,removeBuffHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,infoUpdateHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.UPGRADE,upgradeHandler);
			
		}
		
		protected function removeEvent():void
		{
			_info.removeEventListener(BaseRoleInfoUpdateEvent.ADDBUFF,addBuffHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.UPDATEBUFF,updateBuffHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.REMOVEBUFF,removeBuffHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,infoUpdateHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.UPGRADE,upgradeHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.PLAYERICON_ASSET_COMPLETE,playerIconAssetComplete);
		}
		
		protected function initBuffData():void
		{
			if(_buffTile)
			{
				_buffTile.disposeItems();
			}
			_buffItems = [];
			var list:Dictionary = _info.buffs;
			for each(var i:BuffItemInfo in list)
			{
				addBuff(i);
			}
		}
		
		protected function addBuff(data:BuffItemInfo):void
		{
			var buff:BaseBuffCell = createBuff(data);
			_buffItems.push(buff);
			_buffTile.appendItem(buff);
		}
		
		protected function addBuffHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			addBuff(evt.data as BuffItemInfo);
		}
		
		protected function updateBuffHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			var info:BuffItemInfo = evt.data as BuffItemInfo;
			var buff:BaseBuffCell;
			
			for(var i:int = 0; i < _buffItems.length; i++)
			{
				buff = _buffItems[i];
				if(buff.buffItemInfo.templateId == info.templateId)
				{
					buff.buffItemInfo = info;
				}
			}
		}
		
		protected function removeBuffHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			var info:BuffItemInfo = evt.data as BuffItemInfo;
			var buff:BaseBuffCell;
			for(var i:int = 0; i < _buffItems.length; i++)
			{
				if(_buffItems[i].buffItemInfo == info)
				{
					buff = _buffItems.splice(i,1)[0];
				}
			}
			if(buff)
				_buffTile.removeItem(buff);
		}
		
		protected function infoUpdateHandler(e:BaseRoleInfoUpdateEvent):void
		{
			if(_hpBar)_hpBar.setValue(_info.totalHp,_info.currentHp);
		}
		
		protected function upgradeHandler(e:BaseRoleInfoUpdateEvent):void
		{
			if(_levelField)_levelField.setValue(String(_info.getLevel()));
		}
		
		protected function createBuff(buffInfo:BuffItemInfo):BaseBuffCell
		{
			var cell:BaseBuffCell = new BaseBuffCell();
			cell.buffItemInfo = buffInfo;
			return cell;
		}
		
		public function show(container:DisplayObjectContainer):void
		{
			if(!parent || parent != container)
			{
				container.addChild(this);
			}
		}
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function elementType():int
		{
			return 0;
		}
		
		public function dispose():void
		{
			removeEvent();
			_info = null;
			if(_closeBtn)
			{
				_closeBtn.removeEventListener(MouseEvent.CLICK,closeBtnClickHandler);
				_closeBtn.dispose();
				_closeBtn = null;
			}
			if(_buffTile)
			{
				_buffTile.dispose();
				_buffTile = null;
			}
			for each(var i:BaseBuffCell in _buffItems)
			{
				i.dispose();
			}
			_buffItems = null;
			if(parent)parent.removeChild(this);
		}
	}
}