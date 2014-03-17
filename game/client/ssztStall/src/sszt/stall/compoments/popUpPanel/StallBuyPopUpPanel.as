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
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.stall.compoments.cell.StallShoppingBegBuyCell;
	import sszt.stall.mediator.StallMediator;
	
	public class StallBuyPopUpPanel extends StallBasePopUpPanel
	{
		public function StallBuyPopUpPanel(stallMediator:StallMediator,argItemInfo:ItemInfo)
		{
			super(stallMediator,argItemInfo,true,true);
		}
		
		override public function okHandler(e:MouseEvent):void
		{
			if(getPrice()== 0)
			{
				MAlert.show("求购商品的单价不能为0","提示");
			}
			else
			{
//				stallMediator.sendAddData(false,cellItemInfo.place,getCount(),getPrice());
				GlobalData.stallInfo.addToBegBuyVector(new StallBuyCellInfo(cellItemInfo.templateId,getPrice(),getCount()));
				dispose();
			}
		}
	}
}

