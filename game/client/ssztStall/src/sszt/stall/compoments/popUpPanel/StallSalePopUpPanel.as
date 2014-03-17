package sszt.stall.compoments.popUpPanel
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import ssztui.ui.CopperAsset;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.utils.IntUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.stall.compoments.cell.StallShoppingBegSaleCell;
	import sszt.stall.mediator.StallMediator;
	
	public class StallSalePopUpPanel extends StallBasePopUpPanel
	{
	
		public function StallSalePopUpPanel(stallMediator:StallMediator,cellItemInfo:ItemInfo)
		{
			super(stallMediator,cellItemInfo,false,true);
		}
		
		override public function okHandler(e:MouseEvent):void
		{
			if(getPrice() == 0)
			{
				MAlert.show("出售商品的单价不能为0","提示");
			}
			else
			{
				cellItemInfo.stallSellPrice = getPrice();
				cellItemInfo.lock = true;
				GlobalData.clientBagInfo.addToStallBegSaleVector(cellItemInfo);
				dispose();
			}
		}
		
		
		
	}

}