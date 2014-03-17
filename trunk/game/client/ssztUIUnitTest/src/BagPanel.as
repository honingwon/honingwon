package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.bag.BagBgAsset;
	import ssztui.bag.BagTitleAsset;
	import ssztui.bag.VipBgAsset;

	public class BagPanel extends MPanel
	{
		
		
		private var _allItemBtn:MCacheTabBtn1;        //全部
		private var _equipmentBtn:MCacheTabBtn1;         //任务道具
		private var _drugsBtn:MCacheTabBtn1;            //药物
		private var _gemstoneBtn:MCacheTabBtn1;        //宝石
		private var _goodsBtn:MCacheTabBtn1;          //物品
		private var _btnArray:Array;                   
		
		private var _pagesBtns:Array = [];   //页数按钮
		private var _currentPage:int;
		private var _bg:IMovieWrapper;
		
		private var _currentType:int;                     //当前物品类型
		public function BagPanel()
		{
			super(new MCacheTitle1("",new Bitmap(new BagTitleAsset())),true,-1,true,false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(257,374);
			
			//需要外部加载
			var bg2:Bitmap = new Bitmap(new BagBgAsset(0,0));
			bg2.x = 7;
			bg2.y = 26;
			addContent(bg2);
			
			var bg1:Bitmap = new Bitmap(new VipBgAsset(0,0));
			bg1.x = 252;
			bg1.y = 13;
			addContent(bg1);
			
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,33,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,71,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,109,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,147,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,185,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,223,228,38),new Bitmap(CellCaches.getCellBgPanel6()))
			]);
			addContent(_bg as DisplayObject);
			
			
			_allItemBtn = new MCacheTabBtn1(0,0,"全部");
			_allItemBtn.move(10,4);
			addContent(_allItemBtn);
			_equipmentBtn = new MCacheTabBtn1(0,0,"装备");
			_equipmentBtn.move(57,4);
			addContent(_equipmentBtn);
			_drugsBtn=new MCacheTabBtn1(0,0,"药品");
			_drugsBtn.move(104,4);
			addContent(_drugsBtn);
			_gemstoneBtn=new MCacheTabBtn1(0,0,"宝石");
			_gemstoneBtn.move(151,4);
			addContent(_gemstoneBtn);
			_goodsBtn = new MCacheTabBtn1(0,0,"物品");
			_goodsBtn.move(198,4);
			addContent(_goodsBtn);
			_btnArray = [_allItemBtn,_equipmentBtn,_drugsBtn,_gemstoneBtn,_goodsBtn];
			_btnArray[_currentType].selected = true;
			
			
			var _pages:Array = ["1","2","3","4","5","6"]; 
			
			for(var i:int = 0;i < 6;i++)
			{
				var page:MCacheSelectBtn1 = new MCacheSelectBtn1(0,0,_pages[i]);
				_pagesBtns.push(page);
				_pagesBtns[i].move(108+i*23,263);
				addContent(page);	
			}
			_pagesBtns[_currentPage].selected = true;
			_pages = null;
			
			
			
			
			
			
			
		}
	}
}