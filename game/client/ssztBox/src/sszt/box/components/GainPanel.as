package sszt.box.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.box.GainTitleAsset;
	
	public class GainPanel extends MPanel
	{
		public static const MAX_SIZE:int = 32;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _cellList:Array;
		private var _itemList:Array;
		public function GainPanel()
		{
			_cellList = [];
//			_itemList = itemList;
			super(new MCacheTitle1("",new Bitmap(new GainTitleAsset())), true, -1, true, true);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(332,173);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(9,4,314,162)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,9,304,38),new Bitmap(CellCaches.getCellBgPanel8())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,47,304,38),new Bitmap(CellCaches.getCellBgPanel8())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,85,304,38),new Bitmap(CellCaches.getCellBgPanel8())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,123,304,38),new Bitmap(CellCaches.getCellBgPanel8()))
			]);
			addContent(_bg as DisplayObject);
			
			_tile = new MTile(38,38,8);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.setSize(304,152);
			_tile.move(14,9);
			for(var i:int=0;i<MAX_SIZE;i++)
			{
				var cell:StoreItemCell = new StoreItemCell();
				_tile.appendItem(cell);
				_cellList.push(cell);
			}
			addContent(_tile);
		}
		
		public function initTile(list:Array):void
		{
			for each(var j:StoreItemCell in _cellList)
			{
				j.itemInfo = null;
			}
			var length:int = list.length<MAX_SIZE?list.length:MAX_SIZE;
			for(var i:int=0;i<length;i++)
			{
				(_cellList[i] as StoreItemCell).itemInfo = list[i];
			}
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_cellList)
			{
				for each(var cell:StoreItemCell in _cellList)
				{
					cell.dispose();
					cell = null;
				}
				_cellList = null;
			}
			_itemList = null;
			super.dispose();
		}
	}
}