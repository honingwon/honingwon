package sszt.core.view.getAndUse
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.socketHandlers.pet.PetCallSocketHandler;
	import sszt.core.socketHandlers.vip.VipCardUseSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MPanel2;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;
	
	public class GetAndUsePanel extends MPanel
	{
		private var _info:ItemTemplateInfo;
		private var _btn:MCacheAssetBtn1;
		private var _cell:GetAndUseCell;
		private var _nameField:MAssetLabel;
		private var _flashAsset:IMovieWrapper;
		
		private static var instance:GetAndUsePanel;
		public static function getInstance():GetAndUsePanel
		{
			if(instance == null)
			{
				instance = new GetAndUsePanel();
			}
			return instance;
		}
		
		public function GetAndUsePanel()
		{
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1,true,false);
			_titleTopOffset = 8;
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(225,200);
			this.move(CommonConfig.GAME_WIDTH / 2 + 275, CommonConfig.GAME_HEIGHT / 2 - 130);
			
			setToBackgroup([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(5, 135, 215, 25), new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(87, 28, 50, 50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,108,225,15), new MAssetLabel(LanguageManager.getWord("ssztl.core.getAndUseAward"),MAssetLabel.LABEL_TYPE20)),
			]);
			
			this._btn = new MCacheAssetBtn1(2,0, LanguageManager.getWord("ssztl.core.getAndUse"));
			this._btn.move(62, 150);
			addContent(this._btn);
			this._nameField = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			this._nameField.move(112,82);
			addContent(this._nameField);
			
			this._cell = new GetAndUseCell();
			this._cell.move(87, 28);
			addContent(this._cell);
		}
		
		private function initEvent():void
		{
			_btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			if (this._cell.info == null) return;
			var itemInfo:ItemInfo = GlobalData.bagInfo.getItemById(_cell.info.templateId)[0];
			if(itemInfo)
			{
				if (itemInfo.template.canUse)
				{
					if (CategoryType.isPetEgg(itemInfo.template.categoryId))
					{
						PetCallSocketHandler.send(itemInfo.itemId);
//						SetModuleUtils.addPet(new ToPetData());
					}
					else if (itemInfo.template.categoryId == CategoryType.MUNTS)
					{
						if (GlobalData.mountsList.mountsCount >= 3)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.mounts.cannotCallMore"));
							return;
						}
						ItemUseSocketHandler.sendItemUse(itemInfo.place);
//						SetModuleUtils.addMounts(new ToMountsData(0));
					}
//					else if (itemInfo.template.categoryId == CategoryType.PET)
//					{
//						ItemUseSocketHandler.sendItemUse(itemInfo.place);
////						SetModuleUtils.addPet();
//					}
					else if(itemInfo.template.categoryId == CategoryType.VIP)
					{
						if(itemInfo.template.templateId == CategoryType.VIP_HOUR_CARD)
						{
							if(GlobalData.selfPlayer.getVipType() == VipType.NORMAL || GlobalData.selfPlayer.getVipType() == VipType.OneHour)
							{
								VipCardUseSocketHandler.send(itemInfo.place);
							}
							else
							{
								MAlert.show(LanguageManager.getWord("ssztl.core.maxVip"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK);
							}
						}
						else
						{
							QuickTips.show('here must be 【VIP ONE HOUR CARD】!');
						}
					}
					else
					{
//						if (ItemInfoChecker.isItemLock(_loc_2))
//						{
//							return;
//						}
						ItemUseSocketHandler.sendItemUse(itemInfo.place);
					}
				}
				else if (CategoryType.isEquip(itemInfo.template.categoryId))
				{
					ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG, itemInfo.place, CommonBagType.BAG, 29, 1);
				}
				else if (CategoryType.isPet(itemInfo.template.categoryId))
				{
				}
			}
			if (GlobalData.taskCallback != null)
			{
				GlobalData.taskCallback();
			}
			dispose();
		}
		
		public function show(info:ItemTemplateInfo):void
		{
			_info = info;
			_cell.info = info;
			_nameField.setValue(info.name);
			_nameField.textColor = CategoryType.getQualityColor(info.quality);
			GlobalAPI.layerManager.addPanel(this);
		}
		
		public function get info():ItemTemplateInfo
		{
			return _info;
		}
		
		override public function doEscHandler():void
		{
		}
		
		override public function dispose():void
		{
			this.removeEvent();
			if (this._btn)
			{
				this._btn.dispose();
				this._btn = null;
			}
			if (this._cell)
			{
				this._cell.dispose();
				this._cell = null;
			}
			if (this._flashAsset)
			{
				this._flashAsset.dispose();
				this._flashAsset = null;
			}
			instance = null;
			super.dispose();
		}
	}
}