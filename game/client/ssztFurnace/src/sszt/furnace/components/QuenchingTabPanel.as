package sszt.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.components.cell.FurnaceBaseCell;
	import sszt.furnace.components.cell.FurnaceCell;
	import sszt.furnace.data.FurnaceBuyType;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.furnace.BorderCellBgAsset;
	import ssztui.furnace.DownArrowBgAsset;
	
	public class QuenchingTabPanel extends BaseFurnaceTabPanel
	{
		private var _bg:IMovieWrapper;
		
		public static const COMPOSE_STONE_CATEGORYID_LIST:Array = CategoryType.COMPOSE_STONE_TYPE;
		public static const QUENCHING_MATERIAL_CATEGORYID_LIST:Array = [CategoryType.QUENCHING];
		
		private var _quenchingBtn:MCacheAssetBtn1;
		private var _quenchingBtn2:MCacheAssetBtn1;
		
		private var _resultCell:FurnaceBaseCell;
		
		private var _showCell:BaseItemInfoCell;
		
		/**
		 * 材料不足警告 红色 文字0/1
		 * */
		private var _stuffName:MAssetLabel;
		private var _useMoneyTextField:MAssetLabel;
		
		private var _furnaceItemInfo:FurnaceItemInfo;
		private var _materialTemplateId:int;
		private var _currentMoney:int;
		private var _yuanbaoCost:int;
		private var _useYuanbao:Boolean;
		
		private var _previewText:Bitmap;
		private var _assetsComplete:Boolean;
		
		public function QuenchingTabPanel(mediator:FurnaceMediator)
		{
			super(mediator);
		}
		
		override protected function init():void
		{
			_previewText = new Bitmap();
			_previewText.x = 11;
			_previewText.y = 60;
			addChild(_previewText);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(11,12,50,50),new Bitmap(new BorderCellBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,18,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(152,117,28,39),new Bitmap(new DownArrowBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(100,57,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(184,57,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(142,157,50,50),new Bitmap(new BorderCellBgAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(148,163,38,38),new Bitmap(CellCaches.getCellBg())),
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(79,233,120,14),new MAssetLabel(LanguageManager.getWord("ssztl.furnace.compositeNum"),MAssetLabel.LABEL_TYPE20,"left")),
			]);
			addChild(_bg as DisplayObject);
			super.init();
			
			_quenchingBtn = new MCacheAssetBtn1(2,0,'淬炼');
			_quenchingBtn.move(64,269);
			addChild(_quenchingBtn);
			_quenchingBtn.enabled = false;
			
			_quenchingBtn2 = new MCacheAssetBtn1(2,0,'完美淬炼');
			_quenchingBtn2.move(166,269);
			addChild(_quenchingBtn2);
			_quenchingBtn2.enabled = false;
			
			_resultCell = new FurnaceBaseCell();
			_resultCell.move(148,163);
			addChild(_resultCell);
			
			_showCell = new FurnaceCell();
			_showCell.move(17,18);
			addChild(_showCell);
			
			_stuffName = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
			_stuffName.move(209,105);
			addChild(_stuffName);
			_stuffName.setHtmlValue("");
			
			_useMoneyTextField = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_useMoneyTextField.move(65,320);
			addChild(_useMoneyTextField);
		}
		
		override public function addAssets():void
		{
			_assetsComplete = true;
			_previewText.bitmapData = AssetUtil.getAsset("ssztui.furnace.TextPreviewAsset",BitmapData) as BitmapData;
		}
		
		override protected function getCellPos():Array
		{
			return [new Point(106,63),new Point(190,63)];
		}
		
		override protected function getBackgroundName():Array
		{
			return ['宝石','材料'];//淬炼石
		}
		
		override protected function middleCellClearHandler(e:FuranceEvent):void
		{
			clear();
		}
		
		/**
		 * 清空主面板数据，不清除‘结果格子’
		 * */
		private function clear():void
		{
			FurnaceCell(_cells[0]).furnaceItemInfo = null;
			FurnaceCell(_cells[1]).info = null;
			
			_quenchingBtn.enabled = false;
			_quenchingBtn2.enabled = false;
			
			_showCell.info = null;
			
			_stuffName.setValue('');
			_useMoneyTextField.text ='0';
		}
		
		override protected function otherCellClickHandler(e:FuranceEvent):void
		{
			var tmpFurnaceItemInfo:FurnaceItemInfo = e.data as FurnaceItemInfo;
			if(tmpFurnaceItemInfo.bagItemInfo.templateId == 201031 || tmpFurnaceItemInfo.bagItemInfo.templateId == 201032 || tmpFurnaceItemInfo.bagItemInfo.templateId == 201033)
			{
				return;
			}
			
			clear();
			_resultCell.info = null;
			
			furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.FURANCE_CELL_UPDATE,{info:tmpFurnaceItemInfo,place:0}));
		}
		
		override protected function updateFurnaceHandler(evt:FuranceEvent):void
		{
			_furnaceItemInfo = evt.data["info"] as FurnaceItemInfo;
			FurnaceCell(_cells[0]).furnaceItemInfo = _furnaceItemInfo;
			
			if(_furnaceItemInfo)
			{
				var materialCell:FurnaceCell = _cells[1];
				if(_furnaceItemInfo.bagItemInfo.template.property3 >= 1 && _furnaceItemInfo.bagItemInfo.template.property3 <= 3)
				{
					_materialTemplateId = 201031;
					_yuanbaoCost =180;
				}
				else if(_furnaceItemInfo.bagItemInfo.template.property3 >= 4 && _furnaceItemInfo.bagItemInfo.template.property3 <= 6)
				{
					_materialTemplateId = 201032;
					_yuanbaoCost =720;
				}
				else
				{
					_materialTemplateId = 201033;
					_yuanbaoCost =2800;
				}
				
				var materialNum:int = furnaceInfo.getFurnaceItemNumByTemplateId(_materialTemplateId);
				if(materialNum < 1)
				{
					_stuffName.setHtmlValue("<font color='#ff0000'>"+"0/1</font>");
					_quenchingBtn.enabled = false;
					_quenchingBtn2.enabled = false;
				}
				else
				{
					_quenchingBtn.enabled = true;
					_quenchingBtn2.enabled = true;
					
					_currentMoney = 2000;
					_useMoneyTextField.text =_currentMoney.toString();
				}
				
				materialCell.info = ItemTemplateList.getTemplate(_materialTemplateId);
				if(_furnaceItemInfo.bagItemInfo.templateId > 202140)
				{
					_showCell.info = ItemTemplateList.getTemplate(_furnaceItemInfo.bagItemInfo.templateId+200);
				}
				else
				{
					_showCell.info = ItemTemplateList.getTemplate(_furnaceItemInfo.bagItemInfo.templateId+400);
				}
			}
			else
			{
				clear();
			}
		}
		
		protected function successHandler(e:FuranceEvent):void
		{
			//2是完美淬炼 1是普通淬炼
			var code:int = e.data as int;
			var templateId:int = _furnaceItemInfo.bagItemInfo.templateId;
			if(templateId > 202140)//精致宝石进行淬炼
			{
				if(code == 2)
				{
					_resultCell.info = ItemTemplateList.getTemplate(templateId+200);
				}
				else
				{
					_resultCell.info = ItemTemplateList.getTemplate(templateId);
				}
			}
			else
			{
				if(code == 2)
				{
					_resultCell.info = ItemTemplateList.getTemplate(templateId+400);
				}
				else
				{
					_resultCell.info = ItemTemplateList.getTemplate(templateId+200);
				}
			}
			
		}
		
		protected function quenchingBtn2ClickHandler(event:MouseEvent):void
		{
			_useYuanbao = true;
			sendData();
		}
		
		protected function quenchingBtnClickHandler(event:MouseEvent):void
		{
			_useYuanbao = false;
			sendData();
		}
		
		private function sendData():void
		{
			if(GlobalData.bagInfo.currentSize >= GlobalData.selfPlayer.bagMaxCount)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
				return;
			}
			
			if(_currentMoney > GlobalData.selfPlayer.userMoney.allCopper)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.ComposeMoneyNotEnoughFail"));
				return;
			}
			
			var useBindItem:Boolean = _mediator.furnaceModule.furnacePanel.getUseBindItem();
			var place:int = furnaceInfo.getFurnaceMaterialByTemplateId(_materialTemplateId,useBindItem).bagItemInfo.place;
			if(_useYuanbao)
			{
				MAlert.show(LanguageManager.getWord("ssztl.furnace.yuanbaoCostAlert",_yuanbaoCost),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
				function closeHandler(evt:CloseEvent):void
				{
					if(evt.detail == MAlert.OK)
					{
						_mediator.sendQuenching(_cells[0].furnaceItemInfo.bagItemInfo.place,place,_useYuanbao);
						_quenchingBtn.enabled = false;	
						_quenchingBtn2.enabled = false;	
					}
				}
			}
			else
			{
				_mediator.sendQuenching(_cells[0].furnaceItemInfo.bagItemInfo.place,place,_useYuanbao);
				_quenchingBtn.enabled = false;
				_quenchingBtn2.enabled = false;	
			}
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				furnaceInfo.updateBagToFurnace(tmpItemIdList[i],qualityItemListChecker,QUENCHING_MATERIAL_CATEGORYID_LIST);
			}
		}
		
		/**检测列表过滤条件**/
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.property3 <= 10 &&
				(COMPOSE_STONE_CATEGORYID_LIST.indexOf(argItemInfo.template.categoryId)+1) &&
				argItemInfo.template.quality != 0)
			{
				if(argItemInfo.template.categoryId == 329 && argItemInfo.template.property3 >6)
				{
					return false;
				}
				if(argItemInfo.templateId > 202340)
				{
					return false;
				}
				return true;
			}
			return false;
		}
		
		override public function show():void
		{
			super.show();
			/**加载数据到快速购买**/
			furnaceInfo.currentBuyType = FurnaceBuyType.QUENCHING;
			/**加载数据到另外两个面板**/
			furnaceInfo.initialFurnaceVector(qualityItemListChecker,QUENCHING_MATERIAL_CATEGORYID_LIST);
			/**监听背包变化**/
			furnaceModule.furnaceInfo.addEventListener(FuranceEvent.QUENCHING_SUCCESS,successHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			
			_quenchingBtn.addEventListener(MouseEvent.CLICK,quenchingBtnClickHandler);
			_quenchingBtn2.addEventListener(MouseEvent.CLICK,quenchingBtn2ClickHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_quenchingBtn.addEventListener(MouseEvent.CLICK,quenchingBtnClickHandler);
			_quenchingBtn2.addEventListener(MouseEvent.CLICK,quenchingBtn2ClickHandler);
			furnaceModule.furnaceInfo.removeEventListener(FuranceEvent.QUENCHING_SUCCESS,successHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_quenchingBtn)
			{
				_quenchingBtn.dispose();
				_quenchingBtn = null;
			}
			if(_quenchingBtn2)
			{
				_quenchingBtn2.dispose();
				_quenchingBtn2 = null;
			}
			if(_resultCell)
			{
				_resultCell.dispose();
				_resultCell = null;
			}
			if(_showCell)
			{
				_showCell.dispose();
				_showCell = null;
			}
			_stuffName = null;
			_useMoneyTextField = null;
			_furnaceItemInfo = null;
		}
	}
}