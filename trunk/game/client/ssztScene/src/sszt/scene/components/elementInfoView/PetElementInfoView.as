package sszt.scene.components.elementInfoView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.data.pet.PetUpgradeTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pet.PetFeedSocketHandler;
	import sszt.core.socketHandlers.pet.PetStateChangeSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.types.PetStateType;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.progress.ProgressBar1;

	public class PetElementInfoView extends BaseElementInfoView
	{
		private var _energyBar:ProgressBar1;
		private var _expBar:ProgressBar1;
		private var _energyMask:MSprite;
		private var _expMask:MSprite;
		private var _countDownView:PetUpgradeCountView;
		private var _restBtn:MBitmapButton;
		private var _fightBtn:MBitmapButton;
		private var _feedBtn:MBitmapButton;
		private var _petInfo:PetItemInfo;
		private var _asset:IMovieWrapper;
		private var _petHeadDic:Dictionary = new Dictionary();
		
		private var _bgHead:Bitmap;
		private var _infoContainer:MSprite;
		private var _sleepMov:MovieClip;
		
		public function PetElementInfoView(mediator:ElementInfoMediator)
		{
			super(mediator);
			initPetHeadDic();
		}
		
		private function initPetHeadDic():void
		{
			var petIds:Array = [260001,260002,260003, 260005];
			var key:int;
			for(var i:int = 0; i < petIds.length; i++)
			{
				key = petIds[i];
				_petHeadDic[key] = i;
			}
		}
		
		override protected function initBg():void
		{
			_infoContainer = new MSprite();
			addChild(_infoContainer);
			
			_bgHead = new Bitmap(AssetUtil.getAsset("ssztui.scene.ScenePetInfoBg2Asset") as BitmapData);
			addChild(_bgHead);
			
			_bg = new Bitmap(AssetUtil.getAsset("ssztui.scene.ScenePetInfoBgAsset") as BitmapData);
			_infoContainer.addChild(_bg);
			
			_mask = new Sprite();
			addChild(_mask);
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawCircle(0,0,25);
			_mask.graphics.endFill();
			_mask.x = 35;
			_mask.y = 36;
			_mask.buttonMode = true;
			_mask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_mask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			
			_energyMask = new MSprite();
			_expMask = new MSprite();
			_expMask.tabEnabled = _energyMask.tabEnabled = false;
			
			_energyMask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_energyMask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			_expMask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_expMask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			
			
//			_restBtn = new MCacheTabBtn1(1,3,LanguageManager.getWord("ssztl.pet.infoTagSleep"));
			_restBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.PetBtnSleepAsset") as BitmapData);
			_restBtn.move(-5,29);
			addChild(_restBtn);
			
//			_fightBtn = new MCacheTabBtn1(1,3,LanguageManager.getWord("ssztl.pet.infoTagFight"));
			_fightBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.PetBtnFightAsset") as BitmapData);
			_fightBtn.move(-5,29);
			addChild(_fightBtn);
			_fightBtn.visible = false;
			
//			_feedBtn = new MCacheTabBtn1(1,3,LanguageManager.getWord("ssztl.pet.infoTagFood"));
			_feedBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.PetBtnFoodAsset") as BitmapData);
			_feedBtn.move(1,9);
			addChild(_feedBtn);
			
			_asset = GlobalAPI.movieManagerApi.getMovieWrapper(AssetUtil.getAsset("ssztui.common.MailAsset",MovieClip) as MovieClip,18,18,7);
			_asset.move(149,28);
			addChild(_asset as DisplayObject);
			
			initBitmapdatas();
		}
		
		private function headOverHandler(e:MouseEvent):void
		{
			var ob:Object = e.currentTarget;
			switch(ob)
			{
				case _mask:
					if(_headAsset) setBrightness(_headAsset,0.15);
					TipsUtil.getInstance().show(GlobalData.petList.getPetById(_info.getObjId()),null,new Rectangle(e.stageX,e.stageY,120,0));
					return;
				case _energyMask:
				{
					TipsUtil.getInstance().show(
						LanguageManager.getWord("ssztl.pet.fullDegree")+"："+GlobalData.petList.getPetById(_info.getObjId()).energy+"/"+ 100,
						null,new Rectangle(e.stageX,e.stageY,0,0));
					if(_energyBar) setBrightness(_energyBar,0.3);
					return;
				}
				case _expMask:
				{
					//宠物顶级则显示 0/0
					var currentExp:int = 0;
					var needExp:int = 0;
					//如果宠物等级 非顶级
					if(_petInfo && PetUpgradeTemplateList.list[_petInfo.level + 1])
					{
						needExp = PetUpgradeTemplateList.getMountsUpgradeTemplate(_petInfo.level + 1).exp;
						currentExp = _petInfo.exp - PetUpgradeTemplateList.getMountsUpgradeTemplate(_petInfo.level).totalExp;
					}
					TipsUtil.getInstance().show(
						LanguageManager.getWord("ssztl.common.experience")+"："+currentExp + "/"+ needExp,
						null,new Rectangle(e.stageX,e.stageY,0,0));
					if(_expBar) setBrightness(_expBar,0.3);
					return;
				}
			}
			
		}
		private function headOutHandler(e:MouseEvent):void
		{
			var ob:Object = e.currentTarget;
			switch(ob)
			{
				case _mask:
					TipsUtil.getInstance().hide();
					if(_headAsset) setBrightness(_headAsset,0);
					return;
				case _energyMask:
				{
					TipsUtil.getInstance().hide();
					if(_energyBar) setBrightness(_energyBar,0);
					return;
				}
				case _expMask:
				{
					TipsUtil.getInstance().hide();
					if(_expBar) setBrightness(_expBar,0);
					return;
				}
			}
		}
		
		override protected function initEvent():void
		{
			_restBtn.addEventListener(MouseEvent.CLICK,restClickHandler);
			_fightBtn.addEventListener(MouseEvent.CLICK,fightClickHandler);
			_feedBtn.addEventListener(MouseEvent.CLICK,feedClickHandler);
			_restBtn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_fightBtn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_feedBtn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_restBtn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_fightBtn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_feedBtn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,playerUpgradeHandler);
		}
		
		override protected function removeEvent():void
		{
			_restBtn.removeEventListener(MouseEvent.CLICK,restClickHandler);
			_feedBtn.removeEventListener(MouseEvent.CLICK,feedClickHandler);
//			_speedBtn.removeEventListener(MouseEvent.CLICK,speedClickHandler);
//			_upgradeBtn.removeEventListener(MouseEvent.CLICK,upgradeClickHandler);
			_restBtn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_feedBtn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
//			_speedBtn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
//			_upgradeBtn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_restBtn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_feedBtn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
//			_speedBtn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
//			_upgradeBtn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,playerUpgradeHandler);
			if(_petInfo)
			{
				_petInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_ENERGY,updateEnergyHandler);
				_petInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_EXP,updateExpHandler);
				_petInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE,petInfoUpdateHandler);
//				_petInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE_TIME,updateTimeHandler);
				_petInfo.removeEventListener(PetItemInfoUpdateEvent.RENAME,updateNameHandler);
				_petInfo.removeEventListener(PetItemInfoUpdateEvent.CHANGE_STATE, petStateChangeHandler);
				_petInfo = null;
			}
		}
		
		override protected function initBitmapdatas():void
		{
			if(petHeadAssets.length == 0)
			{
				petHeadAssets.push(
					AssetUtil.getAsset("ssztui.scene.PetHeadAsset1") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PetHeadAsset3") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PetHeadAsset4") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PetHeadAsset2") as BitmapData);
			}
		}
		
		override protected function initHead(change:Boolean = true):void
		{
			if(!_petInfo)
			{
				_petInfo = GlobalData.petList.getPetById(_info.getObjId());
			}
			if(!_petInfo)return;
			var assetIndex:int = _petHeadDic[_petInfo.templateId];
			if(_headAsset && _headAsset.parent) _headAsset.parent.removeChild(_headAsset);
			_headAsset = new Bitmap(petHeadAssets[assetIndex]);
			_headAsset.x = 14;
			_headAsset.y = 13;
			addChild(_headAsset);
		}
		
		override public function setInfo(info:BaseRoleInfo):void
		{
			super.setInfo(info);
			if(!_info)return;
			if(!_petInfo )
			{
				_petInfo = GlobalData.petList.getPetById(_info.getObjId());
			}
			if(!_petInfo)return;
			updateState();
			_petInfo.addEventListener(PetItemInfoUpdateEvent.CHANGE_STATE, petStateChangeHandler);
		}
		
		private function petStateChangeHandler(event:Event):void
		{
			updateState();
		}
		
		private function updateState():void
		{
			if(!_petInfo)return;
			var b:Boolean = _petInfo.state == PetStateType.FIGHT;
			_fightBtn.visible = !b;
			_restBtn.visible = b;
			_infoContainer.visible = b;
			if(_headAsset) _headAsset.alpha = b?1:0.5;
			if(b)
			{
				if(_sleepMov && _sleepMov.parent) _sleepMov.parent.removeChild(_sleepMov);
			}else{
				_sleepMov = AssetUtil.getAsset("ssztui.scene.PetSleepMovAsset") as MovieClip;
				addChild(_sleepMov);
			}
//			_fightBtn.visible = _petInfo.state == PetStateType.FIGHT ? false : true;
//			_restBtn.visible =  !_fightBtn.visible;
			
		}
		
		private function playerUpgradeHandler(evt:CommonModuleEvent):void
		{
			updateTimeHandler(null);
		}
		
		private function overHandler(evt:MouseEvent):void
		{
			var message:String;
			
			if(evt.currentTarget == _restBtn) message = LanguageManager.getWord("ssztl.common.rest");
			else if(evt.currentTarget == _feedBtn) message = LanguageManager.getWord("ssztl.scene.giveEat");
			else if(evt.currentTarget == _fightBtn) message = LanguageManager.getWord("ssztl.pet.outFight");
			else message = LanguageManager.getWord("ssztl.common.upgrade");
			
			TipsUtil.getInstance().show(message,null,new Rectangle(evt.stageX,evt.stageY,0,0));			
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override protected function setValue():void
		{
			if(!_petInfo)
			{
				_petInfo = GlobalData.petList.getPetById(_info.getObjId());
			}
			if(_petInfo)
			{
				_petInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_ENERGY,updateEnergyHandler);
				_petInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE,petInfoUpdateHandler);
				_petInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_EXP,updateExpHandler);
//				_petInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE_TIME,updateTimeHandler);
				_petInfo.addEventListener(PetItemInfoUpdateEvent.RENAME,updateNameHandler);
				_energyBar.setCurrentValue(_petInfo.energy);
				setExpBar();
				_levelField.setValue(_petInfo.level.toString());
				_nameField.setValue(_info.getName());
				_nameField.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_petInfo.templateId).quality);
				_countDownView.addEventListener(Event.COMPLETE,completeHandler);
//				PetGetUpgradeTimeSocketHandler.send(_petInfo.id);
			}
		}
		
		private function setExpBar():void
		{
			//宠物顶级则显示 0/0  或  0%
			var currentExp:int = 0;
			var needExp:int = 0;
			//如果宠物等级 非顶级
			if(_petInfo && PetUpgradeTemplateList.list[_petInfo.level + 1])
			{
				needExp = PetUpgradeTemplateList.getMountsUpgradeTemplate(_petInfo.level + 1).exp;
				currentExp = _petInfo.exp - PetUpgradeTemplateList.getMountsUpgradeTemplate(_petInfo.level).totalExp;
			}
			_expBar.setValue(needExp,currentExp);
		}
		
		private function updateNameHandler(evt:PetItemInfoUpdateEvent):void
		{
			if(_petInfo)
			{
				_nameField.setValue(_petInfo.nick);
				_nameField.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_petInfo.templateId).quality);
			}
		}
		
		private function completeHandler(evt:Event):void
		{
			if(_petInfo.level - GlobalData.selfPlayer.level >= 5) return;
//			_upgradeBtn.enabled = true;
			if(!_asset.parent) addChild(_asset as DisplayObject);
			if(_asset) _asset.play();
		}
		
		private function updateTimeHandler(evt:PetItemInfoUpdateEvent):void
		{
			if(_petInfo)
			{
//				var currentTime:int
//				if(_petInfo.level > 1) currentTime = _petInfo.time - PetUpgradeTemplateList.getPetUpgradeTemplate(_petInfo.level).totalTime;
//				else currentTime = _petInfo.time;
//				if(currentTime >= PetUpgradeTemplateList.getPetUpgradeTemplate(_petInfo.level + 1).time && (_petInfo.level - GlobalData.selfPlayer.level) < 5)
//				{
//					currentTime = PetUpgradeTemplateList.getPetUpgradeTemplate(_petInfo.level + 1).time;
//					_upgradeBtn.enabled = true;
//					if(!_asset.parent) addChild(_asset as DisplayObject);
//					_asset.play();
//				}else
//				{
//					if(_asset) _asset.stop();
//					if(_asset && _asset.parent)  _asset.parent.removeChild(_asset as DisplayObject); 
//					_upgradeBtn.enabled = false;
//				}
//				_countDownView.start(currentTime,PetUpgradeTemplateList.getPetUpgradeTemplate(_petInfo.level + 1).time);
			}
		}
		
		private function updateEnergyHandler(evt:PetItemInfoUpdateEvent):void
		{
			if(_petInfo) _energyBar.setCurrentValue(_petInfo.energy);
		}
		private function updateExpHandler(evt:PetItemInfoUpdateEvent):void
		{
			setExpBar();
		}
		private function petInfoUpdateHandler(evt:PetItemInfoUpdateEvent):void
		{
			if(_petInfo)
			{
				_levelField.setValue(_petInfo.level.toString());
				updateTimeHandler(null);
			}
		}
		
		private function restClickHandler(evt:MouseEvent):void
		{
			if(_petInfo)
			{
				PetStateChangeSocketHandler.send(_petInfo.id,PetStateType.REST);	
			}
		}
		
		private function fightClickHandler(event:MouseEvent):void
		{
			if(_petInfo)
			{
				PetStateChangeSocketHandler.send(_petInfo.id,PetStateType.FIGHT);	
			}
		}
		
		private function feedClickHandler(evt:MouseEvent):void
		{
			if(GlobalData.bagInfo.getItemCountById(CategoryType.PET_FOOD) == 0)
			{
				BuyPanel.getInstance().show([CategoryType.PET_FOOD], new ToStoreData(ShopID.NPC_SHOP));
			}
			else if(_petInfo)
			{
				PetFeedSocketHandler.send(_petInfo.id);
			}
			
			
//			if(_petInfo)
//			{
//				if(_petInfo.energy >= 100)
//				{
//					QuickTips.show(LanguageManager.getWord("ssztl.pet.petFull"));
//					return;
//				}
//				var id:int = CategoryType.getPetFoodIdByQuality(ItemTemplateList.getTemplate(_petInfo.templateId).quality);
//				var list:Array = GlobalData.bagInfo.getItemById(id);
//				var list:Array = GlobalData.bagInfo.getItemById(CategoryType.PET_FOOD_ONE);
//				if(list.length == 0)list = GlobalData.bagInfo.getItemById(CategoryType.PET_FOOD_TWO);
//				if(list.length == 0)list = GlobalData.bagInfo.getItemById(CategoryType.PET_FOOD_THREE);
//				if(list.length == 0)list = GlobalData.bagInfo.getItemById(CategoryType.PET_FOOD_FOUR);
//				if(list.length == 0)
//				{
//					BuyPanel.getInstance().show([CategoryType.PET_FOOD_FOUR],new ToStoreData(ShopID.QUICK_BUY));
//					return;
//				}
//				PetEnergyUpdateSocketHandler.send(_petInfo.id,list[0].itemId);
//			}
		}
		
		private function speedClickHandler(evt:MouseEvent):void
		{
			if(_petInfo)
			{
//				if(GlobalData.selfPlayer.userMoney.yuanBao < PetUpgradeTemplateList.getPetUpgradeTemplate(_petInfo.level).yuanBao)
//				{
//					QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnough"));
//					return;
//				}
//				PetLevelSpeedSocketHandler.send(_info.getObjId());
			}
		}
		
		private function upgradeClickHandler(evt:MouseEvent):void
		{
			if(_petInfo)
			{
//				if(GlobalData.selfPlayer.lifeExperiences < PetUpgradeTemplateList.getPetUpgradeTemplate(_petInfo.level).lifeExp)
//				{
//					QuickTips.show("历练不足，无法升级");
//					return;
//				}
				if(_petInfo.level >= GlobalData.selfPlayer.level + 5)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.pet.levelDifference"));
					return;
				}
				_asset.stop();
				if(_asset.parent) _asset.parent.removeChild(_asset as DisplayObject); 
//				PetUpgradeSocketHandler.send(_info.getObjId());
			}
		}
		
		override protected function initNameField():void
		{
			_nameField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_nameField.textColor = 0xfffccc;
			_nameField.move(86,8);
			_nameField.setSize(90,18);
			_infoContainer.addChild(_nameField);
		}
		
		override protected function initLevelField():void
		{
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_levelField.setLabelType([new TextFormat("Tahoma",11,0xFFFCCC)]);
			_levelField.move(64,10);
			_levelField.mouseEnabled = false;
			_infoContainer.addChild(_levelField);
		}
		
		override protected function initProgressBar():void
		{
			_energyBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getPetHptAsset()),1,100,83,10,true,false);
			_energyBar.move(60,27);
			_infoContainer.addChild(_energyBar);			
			_expBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getPetExptAsset()),1,100,65,5,true,true);
			_expBar.move(60,40);
			_infoContainer.addChild(_expBar);
			_countDownView = new PetUpgradeCountView();
			_countDownView.move(50,29);
			_infoContainer.addChild(_countDownView);
			_energyBar.mouseEnabled = _energyBar.mouseChildren = false;
			
			_energyMask.graphics.beginFill(0,0);
			_energyMask.graphics.drawRect(60,27,83,10);
			_energyMask.graphics.endFill();
			_infoContainer.addChild(_energyMask);
			
			_expMask.graphics.beginFill(0,0);
			_expMask.graphics.drawRect(60,40,65,5);
			_expMask.graphics.endFill();
			_infoContainer.addChild(_expMask);
		}
		
		override public function dispose():void
		{
			if(_bgHead && _bgHead.bitmapData)
			{
				_bgHead.bitmapData.dispose();
				_bgHead = null;
			}
			if(_energyBar)
			{
				_energyBar.dispose();
				_energyBar = null;
			}
			if(_expBar)
			{
				_expBar.dispose();
				_expBar = null;
			}
			if(_countDownView)
			{
				_countDownView.removeEventListener(Event.COMPLETE,completeHandler);
				_countDownView.dispose();
				_countDownView = null;
			}
			if(_asset)
			{
				_asset.dispose();
				_asset = null;
			}
			if(_infoContainer)
			{
				_infoContainer.dispose();
				_infoContainer = null;
			}
			_mask.removeEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_mask.removeEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			_energyMask.removeEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_energyMask.removeEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			_expMask.removeEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_expMask.removeEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			super.dispose();
		}
	}
}