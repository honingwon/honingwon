package sszt.core.view.getAndUse
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mx.events.CloseEvent;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.socketHandlers.pet.PetCallSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MPanel3;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BarAsset2;
	import ssztui.ui.BorderAsset2;
	
	public class GetAndUseEquipPanel extends MPanel3
	{
		private var _useBtn:MCacheAssetBtn1;
		private var _tile:MTile;
		private var _list:Array;
		private static var instance:GetAndUseEquipPanel;
		
		public static function getInstance() : GetAndUseEquipPanel
		{
			if (instance == null)
			{
				instance = new GetAndUseEquipPanel;
			}
			return instance;
		}
		
		
		//构造函数
		public function GetAndUseEquipPanel()
		{
			super(new MCacheTitle1("",new Bitmap(AssetUtil.getAsset("ssztui.common.changeEqAsset",BitmapData) as BitmapData)),true,-1,true,false);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this.x = CommonConfig.GAME_WIDTH - 320;
			this.y = CommonConfig.GAME_HEIGHT - 260;
			setContentSize(267, 146);
			
			setToBackgroup([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,13,0,0),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,63,0,0),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(12, 117, 80, 20), new MAssetLabel(LanguageManager.getWord("ssztl.common.hasBetterEquip"),MAssetLabel.LABEL_TYPE1))
			]);
			
			_tile = new MTile(38, 38, 5);
			_tile.setSize(240, 90);
			_tile.move(26, 15);
			_tile.horizontalScrollPolicy =  _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = 12;
			_tile.itemGapW = 7;
			addContent(_tile);
			this._list = [];
			var _loc_1:int = 0;
			var cell:BaseItemInfoCell = null;
			for(var i:int = 0; i< 10 ;++i)
			{
				cell = new BaseItemInfoCell();
				cell.addEventListener(MouseEvent.CLICK, this.cellClickHandler);
				_tile.appendItem(cell);
				_list.push(cell);
			}
			_useBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.getUseEquip"));
			_useBtn.move(100, 113);
			addContent(this._useBtn);
			
		}
		
		
		//初始化事件
		private function initEvent():void
		{
			_useBtn.addEventListener(MouseEvent.CLICK, this.useBtnClickHandler);
		}
		
		//销毁事件
		private function removeEvent():void
		{
			_useBtn.removeEventListener(MouseEvent.CLICK, this.useBtnClickHandler);
		}
		
		private function cellClickHandler(event:MouseEvent) : void
		{
			var cell:BaseItemInfoCell = event.currentTarget as BaseItemInfoCell;
			useEquip(cell);
		}
		
		private function useBtnClickHandler(event:MouseEvent) : void
		{
			var cell:BaseItemInfoCell = null;
			for each (cell in this._list)
			{
				
				useEquip(cell);
			}
			this.dispose();
		}
		
		//用于现在是当前提示框
		public function show(info:ItemInfo):void
		{
			var cell:BaseItemInfoCell = null;
			for each (cell in this._list)
			{
				
				if (cell.itemInfo == null)
				{
					cell.itemInfo = info;
					break;
				}
			}
			if (parent == null)
			{
				GlobalAPI.layerManager.addPanel(this);
			}
		}
		
		//使用当前装备
		private function useEquip(cell:BaseItemInfoCell) : void
		{
			var iteminfo:ItemInfo = cell.itemInfo;
			if (iteminfo != null)
			{
				if (iteminfo.template.needCareer != 0 && iteminfo.template.needCareer != GlobalData.selfPlayer.career)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.careerNotFit"));
				}
				if (iteminfo.template.needSex != 0 && iteminfo.template.needSex != GlobalData.selfPlayer.getSex())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.sexNotFit"));
				}
				if (iteminfo.template.needLevel > GlobalData.selfPlayer.level)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.levelNotEnough"));
				}
				if (iteminfo.template.bindType == 0 && !iteminfo.isBind)
				{
					function useEquipAlertHandler(event:CloseEvent) : void
					{
						if (event.detail == MAlert.OK)
						{
							ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG, iteminfo.place, CommonBagType.BAG, 29, 1);
							cell.itemInfo = null;
						}
					}
					MAlert.show(LanguageManager.getWord("ssztl.common.wearChangeBind"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,useEquipAlertHandler);
					return
				}
				ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG, iteminfo.place, CommonBagType.BAG, 29, 1);
				cell.itemInfo = null;
			}
		}
		//析构
		override public function dispose():void
		{
			this.removeEvent();
			if (this._tile)
			{
				this._tile.dispose();
				this._tile = null;
			}
			for each (var cell:BaseItemInfoCell in this._list)
			{
				cell.removeEventListener(MouseEvent.CLICK, this.cellClickHandler);
				cell.dispose();
			}
			this._list = null;
			if (this._useBtn)
			{
				this._useBtn.dispose();
				this._useBtn = null;
			}
			
			instance = null;
			if (parent)
			{
				parent.removeChild(this);
			}
			super.dispose();
		}
		
	}
}