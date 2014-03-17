package sszt.scene.components.resourceWar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.resourceWar.ResourceWarInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.scene.DotaTitleRewardAsset;
	import ssztui.ui.CellBigBgAsset;

	public class RewardShowPanel extends MPanel
	{
		private static var _instance:RewardShowPanel;
		
		private const CONTENT_WIDTH:int = 486;
		private const CONTENT_HEIGHT:int = 301;
		private const CELL_POS:Array = [
			new Point(130,73),
			new Point(218,73),
			new Point(306,73),
			new Point(42,213),
			new Point(130,213),
			new Point(218,213),
			new Point(306,213),
			new Point(394,213),
		];
		
		private var _itemList:Array;
		
		private var _bg:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _bgLayoutPath:String;
		
		private var _cellList:Array;
		
		public function RewardShowPanel()
		{
			_itemList = [];
			_cellList = [];
			
			_itemList = _itemList.concat(ResourceWarInfo.CAMP_REWARDS);
			_itemList.push(ResourceWarInfo.REWARDS_FIRST);
			_itemList.push(ResourceWarInfo.REWARDS_SECOND);
			_itemList.push(ResourceWarInfo.REWARDS_THIRD);
			_itemList.push(ResourceWarInfo.REWARDS_FORTH);
			_itemList.push(ResourceWarInfo.REWARDS_FIFTH);
			
			super(new Bitmap(new DotaTitleRewardAsset()),true,-1,true,true);
		}
		public static function getInstance():RewardShowPanel
		{
			if (_instance == null){
				_instance = new RewardShowPanel();
			};
			return (_instance);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(CONTENT_WIDTH, CONTENT_HEIGHT);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(12,6,462,285),new BackgroundType.BORDER_12));
			
			_bgLayout = new Bitmap();
			_bgLayout.x = 14;
			_bgLayout.y = 8;
			addContent(_bgLayout);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(130,73,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,73,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(306,73,50,50),new Bitmap(new CellBigBgAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(42,213,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(130,213,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,213,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(306,213,50,50),new Bitmap(new CellBigBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(394,213,50,50),new Bitmap(new CellBigBgAsset())),
			]);
			addContent(_bg as DisplayObject);
			
			_bgLayoutPath = GlobalAPI.pathManager.getBannerPath("dotaRewardShowBg.jpg");
			GlobalAPI.loaderAPI.getPicFile(_bgLayoutPath, loadBgComplete,SourceClearType.NEVER);
			
			var itemId:int;
			var itemTemplateInfo:ItemTemplateInfo;
			var cell:ResourceWarRewardCell;
			var i:int = 0;
			var pos:Point;
			for each(itemId in _itemList)
			{
				itemTemplateInfo = ItemTemplateList.getTemplate(itemId);
				cell = new ResourceWarRewardCell();
				addContent(cell);
				pos = CELL_POS[i];
				cell.move(pos.x, pos.y)
				cell.info = itemTemplateInfo;
				_cellList.push(cell);
				i++;
			}
		}
		
		public function show():void
		{
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}else
			{
				dispose();
			}
		}
		
		private function loadBgComplete(data:BitmapData):void
		{
			_bgLayout.bitmapData = data;
		}
		
		override public function dispose():void
		{
			super.dispose();
			GlobalAPI.loaderAPI.removeAQuote(_bgLayoutPath,loadBgComplete);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgLayout)
			{
				_bgLayout = null;
			}
			_bgLayoutPath = null;
			if(_cellList)
			{
				for(var i:int = 0; i< _cellList.length; i++)
				{
					(_cellList[i] as ResourceWarRewardCell).dispose();
					_cellList[i] = null;
				}
			}
			_cellList = null;
			_itemList = null;
			_instance = null;
			
		}
	}
}