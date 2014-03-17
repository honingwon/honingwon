package sszt.club.components.clubMain.pop
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubDeviceUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubLevelUpSocketHandler;
	import sszt.club.socketHandlers.ClubLevelupUpdateSocketHandler;
	import sszt.club.socketHandlers.ClubUpgradeDeviceSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubFurnaceLevelTemplate;
	import sszt.core.data.club.ClubFurnaceTemplateList;
	import sszt.core.data.club.ClubLevelTemplate;
	import sszt.core.data.club.ClubLevelTemplateList;
	import sszt.core.data.club.ClubShopLevelTemplate;
	import sszt.core.data.club.ClubShopLevelTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubLevelUpPanel extends MPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		
		private var _okBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		
		private var _typeLabel:MAssetLabel;
		private var _descript:MAssetLabel;
		private var _nextEffect:MAssetLabel;
		private var _need:MAssetLabel;
		private var _cost:MAssetLabel;
		
		private var _sprites:Array;
		private var _currentItem:Sprite;
		
		private var _clubLevel:TextField;
		private var _shopLevel:TextField;
		private var _furnaceLevel:TextField;
		
		private var _decripts:Array = [LanguageManager.getWord("ssztl.club.upgradeClubPrompt1"),
			LanguageManager.getWord("ssztl.club.upgradeClubPrompt2"),
			LanguageManager.getWord("ssztl.club.upgradeClubPrompt3")];
		private var _types:Array = [LanguageManager.getWord("ssztl.club.upgradeClub"),
			LanguageManager.getWord("ssztl.club.clubFurnace2"),
			LanguageManager.getWord("ssztl.club.clubStore2")];
		
		public function ClubLevelUpPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
//			super(new MCacheTitle1("",new Bitmap(new ClubLevelUpTitleAsset())),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(401,294);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,401,262)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,6,390,96)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,105,390,152)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(10,109,382,22))
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(61,23,73,58),new Bitmap(new LevelUpIconAsset())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(164,23,73,58),new Bitmap(new FurnaceAsset())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(267,23,73,58),new Bitmap(new ShopAsset()))
				]);
			addContent(_bg as DisplayObject);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(28,150,47,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.explain"),MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(28,174,47,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.nextLevel"),MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(28,195,47,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.request"),MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(28,216,47,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.cost"),MAssetLabel.LABELTYPE2)));
			
//			_selectBg = new BorderAsset4();
//			_selectBg.mouseEnabled = false;
//			_selectBg.width = 83;
//			_selectBg.height = 68;
			
			_clubLevel = new TextField();
			_clubLevel.textColor = 0xffffff;
			_clubLevel.x = 98;
			_clubLevel.y = 31;
			_clubLevel.width = 40;
			_clubLevel.height = 25;
			_clubLevel.mouseEnabled = _clubLevel.mouseWheelEnabled = false;
			_clubLevel.filters = [new GlowFilter(0x000000,1,2,2,10)];
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),16,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
			_clubLevel.defaultTextFormat = t;
			_clubLevel.setTextFormat(t);
			_clubLevel.text = LanguageManager.getWord("ssztl.common.levelValue", _mediator.clubInfo.clubDetailInfo.clubLevel);
			addContent(_clubLevel);
			_furnaceLevel = new TextField();
			_furnaceLevel.textColor = 0xffffff;
			_furnaceLevel.x = 200;
			_furnaceLevel.y = 31;
			_furnaceLevel.width = 40;
			_furnaceLevel.height = 25;
			_furnaceLevel.mouseEnabled = _furnaceLevel.mouseWheelEnabled = false;
			_furnaceLevel.filters = [new GlowFilter(0x000000,1,2,2,10)];
//			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT);
			_furnaceLevel.defaultTextFormat = t;
			_furnaceLevel.setTextFormat(t);
			_furnaceLevel.text = LanguageManager.getWord("ssztl.common.levelValue", _mediator.clubInfo.deviceInfo.furnaceLevel);
			addContent(_furnaceLevel);		
			_shopLevel = new TextField();
			_shopLevel.textColor = 0xffffff;
			_shopLevel.x = 303;
			_shopLevel.y = 31;
			_shopLevel.width = 40; 
			_shopLevel.height = 25;
			_shopLevel.mouseEnabled = _shopLevel.mouseWheelEnabled = false;
			_shopLevel.filters = [new GlowFilter(0x000000,1,2,2,10)];
//			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFFFFF,null,null,null,null,null,TextFormatAlign.LEFT);
			_shopLevel.defaultTextFormat = t;
			_shopLevel.setTextFormat(t);
			_shopLevel.text = LanguageManager.getWord("ssztl.common.levelValue", _mediator.clubInfo.deviceInfo.shopLevel);
			addContent(_shopLevel);
					
			_sprites = [];
			var sprite:Sprite;
			for(var i:int = 0;i<3;i++)
			{
				sprite = new Sprite();
				sprite.graphics.beginFill(0,0);
				sprite.graphics.drawRect(61+ i*103,23,73,58);
				sprite.graphics.endFill();
				sprite.buttonMode = true;
				addContent(sprite);
				_sprites.push(sprite);
				sprite.addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			
			_typeLabel = new MAssetLabel("",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_typeLabel.move(18,112);
			addContent(_typeLabel);
			_descript = new MAssetLabel("",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_descript.move(73,150);
			addContent(_descript);
			_nextEffect = new MAssetLabel("",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_nextEffect.move(73,174);
			addContent(_nextEffect);
			_need = new MAssetLabel("",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_need.move(73,195);
			addContent(_need);
			_cost = new MAssetLabel("",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_cost.move(73,216);
			addContent(_cost);
			
			_okBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.upgrade"));
			_okBtn.move(100,268);
			addContent(_okBtn);
			_cancelBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(238,268);
			addContent(_cancelBtn);
			
			initEvent();
			updateData(0);
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var item:Sprite = evt.currentTarget as Sprite;
			var index:int = _sprites.indexOf(item);
			updateData(index);
		}
		
		private function updateData(index:int):void
		{
			_currentItem = _sprites[index];
//			if(!_selectBg.parent) addContent(_selectBg);
//			_selectBg.x = 56 + index*103;
//			_selectBg.y = 18;
			_typeLabel.setValue(_types[index]);
			_descript.setValue(_decripts[index]);
//			if(index == 0)
//			{
//				var info1:ClubLevelTemplate = ClubLevelTemplateList.getTemplate(_mediator.clubInfo.clubDetailInfo.clubLevel + 1);
//				if(info1)
//				{
//					_nextEffect.setValue(info1.getEffectToString());
//					_need.setValue(info1.getNeedToString());
//					_cost.setValue(info1.getCostToString());
//				}
//			}else if(index == 1)
//			{
//				var info2:ClubFurnaceLevelTemplate = ClubFurnaceTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.furnaceLevel + 1);
//				if(info2)
//				{
//					_nextEffect.setValue(info2.getEffectToString());
//					_need.setValue(info2.getNeedToString());
//					_cost.setValue(info2.getCostToString());
//				}
//			}else 
//			{
//				var info3:ClubShopLevelTemplate = ClubShopLevelTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.shopLevel + 1);
//				if(info3)
//				{
//					_nextEffect.setValue(info3.getEffectToString());
//					_need.setValue(info3.getNeedToString());
//					_cost.setValue(info3.getCostToString());
//				}
//			}
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
			_mediator.clubInfo.deviceInfo.addEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
			_mediator.clubInfo.clubDetailInfo.addEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,clubLevelUpdateHandler);
		}
		
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);
			_mediator.clubInfo.deviceInfo.removeEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
			_mediator.clubInfo.clubDetailInfo.removeEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,clubLevelUpdateHandler);
		}
		
		private function clubLevelUpdateHandler(evt:ClubDetailInfoUpdateEvent):void
		{
			_clubLevel.text = LanguageManager.getWord("ssztl.common.levelValue",_mediator.clubInfo.clubDetailInfo.clubLevel);
		}
		
		private function updateHandler(evt:ClubDeviceUpdateEvent):void
		{
			_clubLevel.text = LanguageManager.getWord("ssztl.common.levelValue",_mediator.clubInfo.clubDetailInfo.clubLevel);
			_furnaceLevel.text = LanguageManager.getWord("ssztl.common.levelValue",_mediator.clubInfo.deviceInfo.furnaceLevel);
			_shopLevel.text = LanguageManager.getWord("ssztl.common.levelValue",_mediator.clubInfo.deviceInfo.shopLevel);
			updateData(_sprites.indexOf(_currentItem));
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			var index:int = _sprites.indexOf(_currentItem);
			switch (index)
			{
				case 0:
					var info1:ClubLevelTemplate = ClubLevelTemplateList.getTemplate(_mediator.clubInfo.clubDetailInfo.clubLevel + 1);
					if(info1)
					{
						if(info1.needRich > _mediator.clubInfo.clubDetailInfo.clubRich)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough"));
							return;
						}
						ClubLevelUpSocketHandler.send();
					}else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.club.levelAchieveMax"));
					}
					break;
				case 1:
					var info2:ClubFurnaceLevelTemplate = ClubFurnaceTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.furnaceLevel + 1);
					if(info2)
					{
						if(_mediator.clubInfo.clubDetailInfo.clubLevel < info2.needClubLevel)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubLevelNotEnough"));
							return;
						}
						if(GlobalData.selfPlayer.userMoney.copper < info2.needCopper)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
							return;
						}
						if(_mediator.clubInfo.clubDetailInfo.clubRich < info2.needClubRich)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough2"));
							return;
						}
						ClubUpgradeDeviceSocketHandler.send(1);
					}else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.club.levelAchieveMax"));
					}
					break;
				case 2:
					var info3:ClubShopLevelTemplate = ClubShopLevelTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.shopLevel + 1);
					if(info3)
					{
						if(_mediator.clubInfo.clubDetailInfo.clubLevel < info3.needClubLevel)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubLevelNotEnough"));
							return;
						}
						if(GlobalData.selfPlayer.userMoney.copper < info3.needCopper)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
							return;
						}
						if(_mediator.clubInfo.clubDetailInfo.clubRich < info3.needClubRich)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough2"));
							return;
						}
						ClubUpgradeDeviceSocketHandler.send(2);
					}else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.club.levelAchieveMax"));
					}
					break;
			}
		}
		
		private function cancelClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			_typeLabel = null;
			_descript = null;
			_nextEffect = null;
			_need = null;
			_cost = null;
			_currentItem = null;
			if(_sprites)
			{
				for(var i:int = 0;i<_sprites.length;i++)
				{
					_sprites[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
				}
				_sprites = null;
			}
			_clubLevel = null;
			_shopLevel = null;
			_furnaceLevel = null;
			_types = null;
			_decripts = null;
			super.dispose();
		}
	}
}