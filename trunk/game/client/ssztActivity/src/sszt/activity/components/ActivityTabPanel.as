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
	import sszt.activity.components.itemView.ActivityItemView;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActivityTemplateInfo;
	import sszt.core.data.activity.ActivityTemplateInfoList;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.activity.AewardItemTagAsset;
	import ssztui.activity.PvpTagAsset;
	import ssztui.activity.RowBgAsset;
	
	/**
	 * ‘每日活动’面板下‘每日活动’选项卡
	 */
	public class ActivityTabPanel extends Sprite implements IActivityTabPanel
	{
		private var _mediator:ActivityMediator;
		
		private var _bg:IMovieWrapper;
		private var _itemMTile:MTile;
		private var _cellMTile:MTile;
		private var _desciptionLabel:TextField;
		
		private var _itemList:Array;
		private var _cellList:Array;
		private var _currentItem:ActivityItemView;
		
		private var _pageView:PageView;
		private var _currentPage:int = 1;
		
		public static var COLWidth:Array = [110,70,120,110];
		
		public function ActivityTabPanel(argMediator:ActivityMediator)
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
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,10,COLWidth[0],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.copyName"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6+colX[0],10,COLWidth[1],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.needLevel"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6+colX[1],10,COLWidth[2],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6+colX[2],10,COLWidth[3],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE2))
			]);
			addChild(_bg as DisplayObject);
			
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
			
			_pageView = new PageView(6,false,100);
			_pageView.move(97,346);
//			addChild(_pageView);
			
			_cellMTile = new MTile(38, 38, 4);
			_cellMTile.itemGapH = _cellMTile.itemGapW = 1;
			_cellMTile.setSize(156, 160);
			_cellMTile.move(439,210);
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
			for each(var activityTemplateInfo:ActivityTemplateInfo in ActivityTemplateInfoList.list)
			{
				if(activityTemplateInfo.isOpen)
				{
					var itemView:ActivityItemView = new ActivityItemView(activityTemplateInfo);
					_itemMTile.appendItem(itemView);
					_itemList.push(itemView);
				}
			}
			_pageView.totalRecord = _itemList.length;
			if(_itemList.length > 0)
			{
				switchTo(_itemList[0]);
			}
		}
		private function pageChangeHandler(evt:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			_currentPage = _pageView.currentPage;
			
			_itemMTile.clearItems();
			var start:int = _pageView.pageSize*(_currentPage-1);
			var end:int = Math.min(_pageView.pageSize*_currentPage-1,_itemList.length-1);
			
			for(var i:int=start; i<=end; i++)
			{
				_itemMTile.appendItem(_itemList[i]);
			}
		}
		
		private function initEvent():void
		{
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			for(var i:int = 0; i < _itemList.length; i++)
			{
				ActivityItemView(_itemList[i]).addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			for(var i:int = 0; i < _itemList.length; i++)
			{
				ActivityItemView(_itemList[i]).removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		private function switchTo(value:ActivityItemView):void
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
			var target:ActivityItemView = evt.currentTarget as ActivityItemView;
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
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			_desciptionLabel = null;
			_itemList = null;
			_cellList = null;
			_currentItem = null;
		}
	}
}