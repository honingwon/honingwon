package sszt.stall.compoments
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Proxy;
	
	import ssztui.ui.CopperAsset;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.labelField.MLabelField;
	import sszt.ui.mcache.labelField.MLabelField1Bg;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallBuyCellInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.stall.mediator.StallMediator;

	public class StallPanel extends MPanel
	{
		private var _stallMediator:StallMediator;
		public var dealPanel:DealPanel;
		public var goodsPanel:GoodsPanel;
		
		private var _bg:IMovieWrapper;
		public function StallPanel(stallMeidator:StallMediator)
		{
			_stallMediator = stallMeidator;
			//模块名字，可移动，非模态
			super(new MCacheTitle1("摆摊"),true,-1,true,false);
			initialPanel();
			this.move(26,62);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(509,400);
			
			_bg = BackgroundUtils.setBackground([
				//顾客留言
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,252,400)),
				
				new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(6,29,244,24)),
				
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(5,52,242,275)),
				
				new BackgroundInfo(BackgroundType.BAR_5,new Rectangle(67,333,171,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,359,250,2),new MCacheSplit2Line()),
						
						
				//个人商铺背景
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(257,0,252,400)),
				
				new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(261,29,244,24)),
				
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(270,175,225,22),new MLabelField2Bg(225,160)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(463,181,19,11),new Bitmap(new CopperAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(270,349,225,22),new MLabelField2Bg(225,160)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(463,355,19,11),new Bitmap(new CopperAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(270,372,225,22),new MLabelField2Bg(225,160)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(463,378,19,11),new Bitmap(new CopperAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(268,57,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(268,95,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(268,133,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(258,201,250,2),new MCacheSplit2Line()),
				//底色
				new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(261,204,244,24)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(268,232,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(268,270,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(268,308,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				
				
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(56,6,144,25),new MCacheTitle1("顾客留言")));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(13,33,52,17),new MAssetLabel("交易信息",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(13,337,52,17),new MAssetLabel("摊位名称",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(310,6,144,25),new MCacheTitle1("个人商铺")));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(266,33,52,17),new MAssetLabel("待售商品",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(278,178,52,17),new MAssetLabel("待售总价",MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(266,208,52,17),new MAssetLabel("收购商品",MAssetLabel.LABELTYPE1)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(278,353,52,17),new MAssetLabel("待购总价",MAssetLabel.LABELTYPE2)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(282,376,52,17),new MAssetLabel("金币",MAssetLabel.LABELTYPE2)));
		}
		
		
		public function initialPanel():void
		{
			if(!goodsPanel)
			{
				goodsPanel = new GoodsPanel(_stallMediator);
			}
			if(!dealPanel)
			{
				dealPanel = new DealPanel(_stallMediator);
			}
			addContent(goodsPanel);
			addContent(dealPanel);
		}
		
		
		public function setData():void
		{
			for(var i:int = 0;i<GlobalData.clientBagInfo.stallBegSaleVector.length;i++)
			{
				goodsPanel.begSaleGoodsCellVector[i].itemInfo = GlobalData.clientBagInfo.stallBegSaleVector[i];
			}
			goodsPanel.updateSalePrice();
			for(var j:int = 0;j<GlobalData.stallInfo.begBuyInfoVector.length;j++)
			{
				goodsPanel.begBuyGoodsCellVector[j].stallBuyInfo = GlobalData.stallInfo.begBuyInfoVector[j];
			}
			goodsPanel.updateBuyPrice();
			
			dealPanel.setData();
		}
		
		public function clearData():void
		{
			if(GlobalData.selfPlayer.stallName != ""){}
			else
			{
				var saleCount:int = GlobalData.clientBagInfo.stallBegSaleVector.length;
				var buyCount:int = GlobalData.stallInfo.begBuyInfoVector.length;
				if(saleCount == 0&&buyCount == 0){}
				else
				{
					GlobalData.stallInfo.clearAllVector();
				}
			}
		}
		
		 override public function dispose():void
		{
			 clearData();
			 _stallMediator = null;
			 if(_bg)
			 {
				_bg.dispose();
				_bg = null;
			 }
			 if(goodsPanel)
			 {
				 goodsPanel.dispose();
				 goodsPanel = null;
			 }
			 
			 if(dealPanel)
			 {
				 dealPanel.dispose();
				 dealPanel = null;
			 }

			super.dispose();
		}
	}
}