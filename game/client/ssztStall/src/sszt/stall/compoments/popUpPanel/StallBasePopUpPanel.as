package sszt.stall.compoments.popUpPanel
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import ssztui.ui.CopperAsset;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.stall.StallModule;
	import sszt.stall.compoments.cell.StallShoppingBegSaleCell;
	import sszt.stall.mediator.StallMediator;
	
	public class StallBasePopUpPanel extends MPanel
	{
		public var stallMediator:StallMediator;
		private var _cellItemInfo:ItemInfo;
		private var _bg:IMovieWrapper;
		
		private var _okBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		
		private var _tmpCell:BaseItemInfoCell;
		private var _tmpCellNameField:TextField;
		private var _tmpCellCountField:TextField;
		private var _tmpCellPriceField:TextField;
		private var _isCountCanInput:Boolean;
		private var _isPriceCanInput:Boolean;
		
		
		public function StallBasePopUpPanel(argStallMediator:StallMediator,cellItemInfo:ItemInfo,isCountCanInput:Boolean = false,isPriceCanInput:Boolean = false)
		{
			stallMediator = argStallMediator;
			this._cellItemInfo = cellItemInfo;
			_isCountCanInput = isCountCanInput;
			_isPriceCanInput = isPriceCanInput;
			super(new MCacheTitle1("物品信息"),true,0.5,true,true);
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(317,172);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,317,138)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(25,16,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(1,63,316,2),new MCacheSplit2Line()),
				
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(109,72,83,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,105,268,22),new MLabelField2Bg(268,200)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(266,110,19,11),new Bitmap(new CopperAsset())),
			]);
			
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(27,76,52,19),new MAssetLabel("物品数量",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(29,107,52,19),new MAssetLabel("物品单价",MAssetLabel.LABELTYPE2)));
			
			
			_tmpCell = new BaseItemInfoCell();
//			_tmpCell.width = 38;
//			_tmpCell.height = 38;
			_tmpCell.move(26,17);
			addContent(_tmpCell);
			_tmpCell.itemInfo = this._cellItemInfo;
			
			_tmpCellNameField = new TextField();
			_tmpCellNameField.text = this._cellItemInfo.template.name;
			_tmpCellNameField.selectable = false;
			_tmpCellNameField.width = 101;
			_tmpCellNameField.height = 19;
			_tmpCellNameField.x = 83;
			_tmpCellNameField.y = 26;
			addContent(_tmpCellNameField);
			
			_tmpCellCountField = new TextField();
			_tmpCellCountField.textColor = 0xFFFFFF;
			_tmpCellCountField.selectable = false;
			if(_isCountCanInput)
			{
				_tmpCellCountField.selectable = true;
				_tmpCellCountField.type = "input";
			}
			_tmpCellCountField.restrict = "0123456789";
			_tmpCellCountField.text = this._cellItemInfo.count.toString();
			_tmpCellCountField.x = 109;
			_tmpCellCountField.y = 72;
			_tmpCellCountField.width = 83;
			_tmpCellCountField.height = 22;
			addContent(_tmpCellCountField);
			
			_tmpCellPriceField = new TextField();
			_tmpCellPriceField.textColor = 0xFFFFFF;
			_tmpCellPriceField.selectable = false;
			if(_isPriceCanInput)
			{
				_tmpCellPriceField.selectable = true;
				_tmpCellPriceField.type = "input";
			}
			_tmpCellPriceField.maxChars = 9;
//			_tmpCellPriceField.autoSize =TextFieldAutoSize.LEFT;
			_tmpCellPriceField.text = "1";
			_tmpCellPriceField.restrict = "0123456789";
			_tmpCellPriceField.x = 91;
			_tmpCellPriceField.y =105;
			_tmpCellPriceField.width = 180;
			_tmpCellPriceField.height = 22;
			addContent(_tmpCellPriceField);
			
			
			_okBtn = new MCacheAsset1Btn(0,"确定");
			_okBtn.move(25,144);
			addContent(_okBtn);
			
			_cancelBtn = new MCacheAsset1Btn(0,"取消");
			_cancelBtn.move(211,144);
			addContent(_cancelBtn);
			
		}
		
		
		private function initEvents():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,okHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelHandler);
		}
		
		private function removeEvents():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,okHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelHandler);
		}
		
		
		public function okHandler(e:MouseEvent):void
		{
		}
		
		private function cancelHandler(e:MouseEvent):void
		{
			dispose();
		}
		
		public function get stallModule():StallModule
		{
			return stallMediator.stallModule;
		}
		
		public function setPrice(price:int):void
		{
			_tmpCellPriceField.text = price.toString();
		}
		
		public function getPrice():int
		{
			return Number(_tmpCellPriceField.text);
		}
		
		public function getCount():int
		{
			return Number(_tmpCellCountField.text);
		}
		
		public function setCount(count:int):void
		{
			_tmpCellCountField.text = count.toString();
		}
		
		public function get cellItemInfo():ItemInfo
		{
			return _cellItemInfo;
		}
		
		public function set cellItemInfo(value:ItemInfo):void
		{
			_cellItemInfo = value;
		}
		
		override public function  dispose():void
		{
			removeEvents();
			stallMediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_cellItemInfo = null;
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
			if(_tmpCell)
			{
				_tmpCell.dispose();
				_tmpCell = null;
			}
			_tmpCellNameField = null;
			_tmpCellCountField = null;
			_tmpCellPriceField = null;
			super.dispose();
		}
	}
}