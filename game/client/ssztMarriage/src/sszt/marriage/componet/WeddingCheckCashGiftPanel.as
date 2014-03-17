package sszt.marriage.componet
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.marriage.MarriageInfo;
	import sszt.core.data.marriage.WeddingCashGiftItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.marriage.componet.item.WeddingCashGiftItemView;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageView;
	
	import ssztui.marriage.OnInviteTitleAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class WeddingCheckCashGiftPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _oneClickGetHandler:Function;
		
		private var _btnOneClickGet:MCacheAssetBtn1;
		private var _pageView:PageView;
		private var _tile:MTile;
		
		public function WeddingCheckCashGiftPanel(oneClickGetHandler:Function)
		{
			_oneClickGetHandler = oneClickGetHandler;
			
			super(new MCacheTitle1("",new Bitmap(new OnInviteTitleAsset())),true,-1,true,true);
			
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(364,415);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,348,405)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,340,397)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,402,340,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(15,9,334,24)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(145,10,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(269,10,2,22),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,33,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,63,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,93,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,123,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,153,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,183,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,213,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,243,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,273,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,303,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,333,334,2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,13,130,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.name"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(147,13,122,15),new MAssetLabel(LanguageManager.getWord("ssztl.marry.cashGiftTitle"),MAssetLabel.LABEL_TYPE_TITLE2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,377,364,15),new MAssetLabel(LanguageManager.getWord("ssztl.marry.cashGiftTip"),MAssetLabel.LABEL_TYPE_TAG)),
			]);
			addContent(_bg as DisplayObject);
			
			_btnOneClickGet = new MCacheAssetBtn1(0,3,"_btnOneClickGet");
//			addContent(_btnOneClickGet);
			
			_pageView = new PageView(MarriageInfo.WEDDING_INVITATION_PAGESIZE,false,110);
			_pageView.move(127,340);
			addContent(_pageView);
			
			_tile = new MTile(340,30,1);
			_tile.setSize(340,300);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile.move(15,34);
			_tile.verticalScrollBar.lineScrollSize = 30;
			addContent(_tile);
		}
		
		private function initEvent():void
		{
			_btnOneClickGet.addEventListener(MouseEvent.CLICK,_oneClickGetHandler);
			//			_pageView.addEventListener(PageEvent.PAGE_CHANGE,_pageChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnOneClickGet.removeEventListener(MouseEvent.CLICK,_oneClickGetHandler);
			//			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,_pageChangeHandler);
		}
		
		public function updateView(data:Array, total:int):void
		{
			clearView();
			
			_pageView.totalRecord = total;
			
			var itemView:WeddingCashGiftItemView;
			var dataItem:WeddingCashGiftItemInfo;
			for each(dataItem in data)
			{
				itemView = new WeddingCashGiftItemView(dataItem);
				_tile.appendItem(itemView);
			}
		}
		
		private function clearView():void
		{
			_tile.disposeItems();
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			
			if(_btnOneClickGet)
			{
				_btnOneClickGet.dispose();
				_btnOneClickGet= null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView= null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile= null;
			}
		}
		
	}
}