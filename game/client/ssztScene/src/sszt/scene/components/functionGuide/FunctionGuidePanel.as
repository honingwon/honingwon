package sszt.scene.components.functionGuide
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.functionGuide.FunctionGuideItemInfo;
	import sszt.core.data.functionGuide.FunctionGuideItemList;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	
	public class FunctionGuidePanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _cellList:Array;
		private var _tile:MTile;
		private var _flag:int = 0;
		private var _mediator:SceneMediator
		public function FunctionGuidePanel(mediator:SceneMediator)
		{
			_cellList = [];
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(AssetUtil.getAsset("mhsm.scene.FunctionGuideTitleAsset") as BitmapData)),true,-1,true,false);
			move(CommonConfig.GAME_WIDTH-380,CommonConfig.GAME_HEIGHT-290);
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(296,161);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,296,161)),
				new BackgroundInfo(BackgroundType.BAR_6, new Rectangle(6,6,285,148)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,15,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(60,15,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(105,15,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,15,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(195,15,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(240,15,40,40),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,60,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(60,60,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(105,60,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,60,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(195,60,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(240,60,40,40),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,105,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(60,105,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(105,105,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,105,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(195,105,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(240,105,40,40),new Bitmap(CellCaches.getCellBg()))
			]);
			addContent(_bg as DisplayObject);
			
			_tile = new MTile(40,40,6);
			_tile.itemGapH = 5;
			_tile.itemGapW = 5;
			_tile.setSize(265,130);
			_tile.move(17,17);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addContent(_tile);
			
			for each(var item:FunctionGuideItemInfo in FunctionGuideItemList.itemInfoList)
			{
				var cell:FunctionCell = new FunctionCell();
				if(item.level <= GlobalData.selfPlayer.level)
				{
					cell.info = item;
					cell.buttonMode = true;
				}
				else
				{
					cell.info = null;
				}
				cell.addEventListener(MouseEvent.CLICK,cellClickHandler);
				_tile.appendItem(cell);
				_cellList[item.place] = cell;
			}
		}
		
		private function cellClickHandler(evt:MouseEvent):void
		{
			if(FunctionCell(evt.currentTarget).info)
			{
				var info:FunctionGuideItemInfo = FunctionCell(evt.currentTarget).info as FunctionGuideItemInfo;
				_mediator.showFunctionDetailPanel(info);
			}
		}
		
		private function initEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeHandler);
		}
		
		private function upgradeHandler(evt:CommonModuleEvent):void
		{
			var info:FunctionGuideItemInfo = FunctionGuideItemList.getItemInfoByLevel(GlobalData.selfPlayer.level);
			if(info)
			{
				_cellList[info.place].info = info;
			}
		}
		
		private function gameSizeHandler(evt:CommonModuleEvent):void
		{
			move(CommonConfig.GAME_WIDTH-380,CommonConfig.GAME_HEIGHT-290);
		}
		
		
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_cellList)
			{
				for each(var cell:FunctionCell in _cellList)
				{
					cell.removeEventListener(MouseEvent.CLICK,cellClickHandler);
					cell.dispose();
					cell = null;
				}
				_cellList = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			super.dispose();
		}
	}
}