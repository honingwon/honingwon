package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mx.rpc.xml.QualifiedResourceManager;
	
	import sszt.constData.ActionType;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.characterActionInfos.ScenePetCharacterActions;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetDialogTemplate;
	import sszt.core.data.pet.PetDialogTemplateList;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePetInfoUpdateEvent;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;

	public class BaseScenePet extends BaseRole implements ITick
	{
		private var _quality:int;   //资质
		private var _list:Array;    //对白列表
		private var _lastTime:Number;
		private var _figureVisible:Boolean = true;
		private var _qualityTitleAsset:Bitmap;
		private var _growTitleAsset:Bitmap;
		
		public function BaseScenePet(info:BaseScenePetInfo)
		{
			super(info);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			var temp:int = Math.floor(7500 * Math.random() + 1);
			if(temp == 50)
			{
				var index:int = Math.floor(_list.length*Math.random() + 1);
				var template:PetDialogTemplate;
				if(getTimer() - _lastTime > 15000)
				{
					_lastTime = getTimer();
					for each(var i:PetDialogTemplate in _list)
					{
						if(i.id == index)
						{
							template = i;
							break;
						}
					}
					if(template) showPaopao(template.message);
				}
			}
		}
		
		public function startTalk():void
		{
			GlobalAPI.tickManager.addTick(this);
			_lastTime = getTimer();
			_quality = GlobalData.petList.getFightPet().template.quality;
			_list = PetDialogTemplateList.getListByQuality(_quality);
		}
		
		override protected function init():void
		{
			super.init();
			
			_mouseAvoid = true;
//			nick.move(0,-90);
			nick.x = -70;
			nick.y = -95;
			
			var tmpColor:String;
			var tmp:ItemTemplateInfo = ItemTemplateList.getTemplate(getScenePetInfo().templateId);
			if(tmp) tmpColor = CategoryType.getQualityColorString(tmp.quality);
			else tmpColor = "#FCFF1B";
			if(getScenePetInfo())
			{
				nick.htmlText = "<font color = '#" + tmpColor + "'>" + getScenePetInfo().getName() + "</font>\n" + "<font color ='#FCFF1B'>[" + getScenePetInfo().getOwnerName() + "]</font>";
			}
			mouseChildren = mouseEnabled = tabChildren = tabEnabled = false;
			
			updatePetTitle();
		}
		
		private function updatePetTitle():void
		{
			var t:BitmapData;
			var count:int = 0;
			var qualityFirst:Boolean = getScenePetInfo().getIsQualityFirst();
			var qualitySecond:Boolean = getScenePetInfo().getIsQualitySecond();
			var qualityThird:Boolean = getScenePetInfo().getIsQualityThird();
			var growFirst:Boolean = getScenePetInfo().getIsGrowFirst();
			var growSecond:Boolean = getScenePetInfo().getIsGrowSecond();
			var growThird:Boolean = getScenePetInfo().getIsGrowThird();
			if(qualityFirst || qualitySecond || qualityThird)
			{
				_qualityTitleAsset = new Bitmap();
				addChild(_qualityTitleAsset);
				_qualityTitleAsset.x = -57;
				_qualityTitleAsset.y = -40*count -130;
				count++;
				if(qualityFirst) t = AssetUtil.getAsset("mhsm.scene.PetQualityTitleAsset1") as BitmapData;
				else if(qualitySecond) t = AssetUtil.getAsset("mhsm.scene.PetQualityTitleAsset2") as BitmapData;
				else if(qualityThird) t = AssetUtil.getAsset("mhsm.scene.PetQualityTitleAsset3") as BitmapData;
				if(t) _qualityTitleAsset.bitmapData = t;
			}
			if(growFirst || growSecond || growThird)
			{
				_growTitleAsset = new Bitmap();
				addChild(_growTitleAsset);
				_growTitleAsset.x = -57;
				_growTitleAsset.y = -40*count -130;
				if(growFirst) t = AssetUtil.getAsset("mhsm.scene.PetGrowTitleAsset1") as BitmapData;
				else if(growSecond) t = AssetUtil.getAsset("mhsm.scene.PetGrowTitleAsset2") as BitmapData;
				else if(growThird) t = AssetUtil.getAsset("mhsm.scene.PetGrowTitleAsset3") as BitmapData; 
				if(t) _growTitleAsset.bitmapData = t;
			}
			if(t == null) ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,petTitleAssetHandler);
		}
		
		private function petTitleAssetHandler(evt:CommonModuleEvent):void
		{
			if(_qualityTitleAsset)
			{
				if(getScenePetInfo().getIsQualityFirst()) _qualityTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.PetQualityTitleAsset1") as BitmapData;
				else if(getScenePetInfo().getIsQualitySecond()) _qualityTitleAsset.bitmapData  = AssetUtil.getAsset("mhsm.scene.PetQualityTitleAsset2") as BitmapData;
				else if(getScenePetInfo().getIsQualityThird()) _qualityTitleAsset.bitmapData  = AssetUtil.getAsset("mhsm.scene.PetQualityTitleAsset3") as BitmapData;
			}
			if(_growTitleAsset)
			{
				if(getScenePetInfo().getIsGrowFirst()) _growTitleAsset.bitmapData = AssetUtil.getAsset("mhsm.scene.PetGrowTitleAsset1") as BitmapData;
				else if(getScenePetInfo().getIsGrowSecond()) _growTitleAsset.bitmapData  = AssetUtil.getAsset("mhsm.scene.PetGrowTitleAsset2") as BitmapData;
				else if(getScenePetInfo().getIsGrowThird()) _growTitleAsset.bitmapData  = AssetUtil.getAsset("mhsm.scene.PetGrowTitleAsset3") as BitmapData;
			}
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			if(getScenePetInfo())
			{
				getScenePetInfo().addEventListener(BaseScenePetInfoUpdateEvent.NAME_UPDATE,updateNameHandler);
				getScenePetInfo().addEventListener(BaseScenePetInfoUpdateEvent.STYLE_UPDATE,styleUpdateHandler);
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			if(getScenePetInfo())
			{
				getScenePetInfo().removeEventListener(BaseScenePetInfoUpdateEvent.NAME_UPDATE,updateNameHandler);
				getScenePetInfo().removeEventListener(BaseScenePetInfoUpdateEvent.STYLE_UPDATE,styleUpdateHandler);
			}
		}
		
		override protected function initBloodBar():void{}
		
		private function updateNameHandler(evt:BaseScenePetInfoUpdateEvent):void
		{
			var tmpColor:String;
			var tmp:ItemTemplateInfo = ItemTemplateList.getTemplate(getScenePetInfo().templateId);
			if(tmp) tmpColor = CategoryType.getQualityColorString(tmp.quality);
			else tmpColor = "#FCFF1B";
			if(getScenePetInfo())
			{
				nick.htmlText = "<font color = '#" + tmpColor + "'>" + getScenePetInfo().getName() + "</font>\n" + "<font color ='#FCFF1B'>[" + getScenePetInfo().getOwnerName() + "]</font>";
			}
		}
		
		public function setFigureVisible(value:Boolean):void
		{
			_figureVisible = value;
			_character.setFigureVisible(value);
			if(_figureVisible)
			{
				if(nick && nick.parent != this)addChild(nick);
				if(_shadow && _shadow.parent != this)addChildAt(_shadow,0);
			}
			else
			{
				if(nick && nick.parent)nick.parent.removeChild(nick);
				if(_shadow && _shadow.parent)_shadow.parent.removeChild(_shadow);
				if(_paopao)_paopao.hide();
			}
		}
		
		public function getScenePetInfo():BaseScenePetInfo
		{
			return _info as BaseScenePetInfo;
		}
		
		override protected function getTotalHP():int
		{
			return getScenePetInfo().totalHp;
		}
		
		override protected function getCurrentHP():int
		{
			return getScenePetInfo().currentHp;
		}
		
		override protected function initCharacter():void
		{
			updateCharacter();
		}
		
		override protected function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			
		}
		
		private function styleUpdateHandler(evt:BaseScenePetInfoUpdateEvent):void
		{
			updateCharacter();
		}
		
		private function updateCharacter():void
		{
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			var tmp:PetTemplateInfo;
			if(getScenePetInfo())
			{
				if(getScenePetInfo().styleId == 0 || getScenePetInfo().styleId == -1)
				{
					tmp = getScenePetInfo().template;
				}
				else
				{
					tmp = PetTemplateList.getPet(getScenePetInfo().styleId);
					if(!tmp)tmp = getScenePetInfo().template;
				}
				_character = GlobalAPI.characterManager.createPetCharacter(tmp);
				_character.show();
//				_character.move(-185,-230);
				addChild(_character as DisplayObject);
			}
			
			var owner:BaseScenePlayerInfo = this.getScenePetInfo().getOwner();
			if (owner)
			{
//				if (owner.getIsHide())
//				{
//					this.hidePet();
//				}
//				else
//				{
//					this.showPet();
//				}
			}
			
		}
		
		public function hidePet() : void
		{
			this.visible = false;
		}
		
		public function showPet() : void
		{
			this.visible = true;
		}
		
		
		override protected function walkStartHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			super.walkStartHandler(evt);
			_character.doActionType(ActionType.WALK);
		}
		
		override public function doWalkAction():void
		{
			if(_character.currentAction != ActionType.WALK)
				_character.doActionType(ActionType.WALK);
		}
		
		override protected function walkComplete():void
		{
			super.walkComplete();
			_character.doActionType(ActionType.STAND);
		}
		
		override public function dispose():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,petTitleAssetHandler);
			GlobalAPI.tickManager.removeTick(this);
			super.dispose();
		}
	}
}