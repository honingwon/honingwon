package sszt.activity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.activity.components.cell.AwardCell;
	import sszt.activity.components.itemView.PvPItemView;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.core.data.activity.ActivityPvpTemplateInfo;
	import sszt.core.data.activity.ActivityPvpTemplateList;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	import ssztui.activity.AewardItemTagAsset;
	import ssztui.activity.PvpTagAsset;
	import ssztui.activity.TaskAboutTagAsset;
	
	/**
	 * ‘每日活动’面板下‘激情竞技’选项卡
	 */
	public class ActivityPvPTabPanel extends Sprite implements IActivityTabPanel
	{
		private var _mediator:ActivityMediator;
		
		private var _bg:IMovieWrapper;
		private var _itemMTile:MTile;
		private var _cellMTile:MTile;
		private var _desciptionLabel:TextField;
		
		private var _itemList:Array;
		private var _cellList:Array;
		private var _currentItem:PvPItemView;
		
		public static var COLWidth:Array = [150,70,100,100];
		
		public function ActivityPvPTabPanel(argMediator:ActivityMediator)
		{
			super();
			
			_mediator = argMediator;
			
			initView();
			initTemplateData();
			
			initEvent();
		}
		
		private function initView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+COLWidth[i]:COLWidth[0]+i*2);
			}
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,426,380)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(431,3,172,380)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(6,6,420,24)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(432,7,170,26)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(432,180,170,2)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(432,181,170,26)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(485,12,65,15),new Bitmap(new PvpTagAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(500,185,34,15),new Bitmap(new AewardItemTagAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5+colX[0],7,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5+colX[1],7,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5+colX[2],7,2,22),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,68,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,102,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,136,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,170,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,204,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,238,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,272,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,306,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,340,410,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,374,410,2)),
				
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6,10,COLWidth[0],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.name"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[0],10,COLWidth[1],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.needLevel"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[1],10,COLWidth[2],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[2],10,COLWidth[3],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE2)));
			
			_itemList = [];
			_cellList = [];
			
			_itemMTile = new MTile(420,34);
			_itemMTile.itemGapH = _itemMTile.itemGapW = 0;
			_itemMTile.setSize(420,340);
			_itemMTile.move(6,35);
			addChild(_itemMTile);
			_itemMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_itemMTile.verticalScrollBar.lineScrollSize = 34;
			
			_cellMTile = new MTile(38, 38, 4);
			_cellMTile.itemGapH = _cellMTile.itemGapW = 1;
			_cellMTile.setSize(156, 160);
			_cellMTile.move(439,210);
			addChild(_cellMTile);
			addChild(_cellMTile);
			_cellMTile.horizontalScrollPolicy = _cellMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			_desciptionLabel = new TextField();
			_desciptionLabel.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,3);
			_desciptionLabel.mouseEnabled = _desciptionLabel.mouseWheelEnabled = false;
			_desciptionLabel.width = 157;
			_desciptionLabel.height = 141;
			_desciptionLabel.x = 438;
			_desciptionLabel.y = 36;
			_desciptionLabel.wordWrap = true;
			_desciptionLabel.multiline = true;
			addChild(_desciptionLabel);
		}
		
		private function initTemplateData():void
		{
			for each(var activityPvpTemplateInfo:ActivityPvpTemplateInfo in ActivityPvpTemplateList.list)
			{
				var itemView:PvPItemView = new PvPItemView(activityPvpTemplateInfo);
				_itemMTile.appendItem(itemView);
				_itemList.push(itemView);
			}
			if(_itemList.length > 0)
			{
				switchTo(_itemList[0]);
			}
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _itemList.length; i++)
			{
				PvPItemView(_itemList[i]).addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _itemList.length; i++)
			{
				PvPItemView(_itemList[i]).removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		private function switchTo(value:PvPItemView):void
		{
			if(_currentItem)
			{
				_currentItem.selected = false;
			}
			_currentItem = value;
			_currentItem.selected = true;
			updateView();
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var target:PvPItemView = evt.currentTarget as PvPItemView;
			if(_currentItem == target) return;
			switchTo(target);
		}
		
		private function updateView():void
		{
			clearCells();
			
			var cell:AwardCell;
			var awards:Array = _currentItem.info.awards;
			for(var i:int = 0; i < awards.length; i++)
			{
				cell = new AwardCell();
				cell.info = ItemTemplateList.getTemplate(awards[i]);
				if(cell.info != null)
				{
					_cellList.push(cell);
					_cellMTile.appendItem(cell);
				}
			}
			_desciptionLabel.htmlText = _currentItem.info.description;
		}
		
		private function clearCells():void
		{
			if(_cellList.length <= 0) return;
			_cellMTile.disposeItems();
			_cellList = [];
		}
		
		public function show():void
		{
			if(_currentItem)
			{
				_currentItem.selected = false;
				_currentItem.selected = true;
			}
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_itemMTile)
			{
				_itemMTile.disposeItems();
				_itemMTile.dispose();
				_itemMTile = null;
			}
			if(_cellMTile)
			{
				_cellMTile.disposeItems();
				_cellMTile.dispose();
				_cellMTile = null;
			}
			_desciptionLabel = null;
			_itemList = null;
			_cellList = null;
			_currentItem = null;
		}
	}
}