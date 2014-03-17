package sszt.activity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import sszt.activity.components.cell.AwardCell;
	import sszt.activity.components.itemView.BossItemView;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.activity.socketHandlers.BossInfoSocketHandler;
	import sszt.core.data.activity.ActivityPvpTemplateList;
	import sszt.core.data.activity.BossTemplateInfo;
	import sszt.core.data.activity.BossTemplateInfoList;
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
	import ssztui.activity.TaskAboutTagAsset;
	
	/**
	 * ‘每日活动’面板下‘世界boss’选项卡
	 */
	public class BossTabPanel extends Sprite implements IActivityTabPanel
	{
		private var _mediator:ActivityMediator;
		
		private var _bg:IMovieWrapper;
		private var _itemMTile:MTile;
		private var _cellMTile:MTile;
		private var _desciptionLabel:TextField;
		
		private var _itemList:Array;
		private var _cellList:Array;
		private var _currentItem:BossItemView;
		
		public function BossTabPanel(argMediator:ActivityMediator)
		{
			super();
			
			_mediator = argMediator;
			
			initView();
			initTemplateData();
			
			initEvent();
		}
		
		private function initView():void
		{
			var _rowBg:Shape = new Shape();	
			_rowBg.graphics.beginFill(ActivityPanel.EVEN_COLOR,1);
			_rowBg.graphics.drawRect(9,59,438,26);
			_rowBg.graphics.drawRect(9,115,438,26);
			_rowBg.graphics.drawRect(9,171,438,26);
			_rowBg.graphics.drawRect(9,227,438,26);
			_rowBg.graphics.drawRect(9,283,438,26);
			_rowBg.graphics.drawRect(9,339,438,26);
			_rowBg.graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(5,5,444,373)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(8,8,438,22)),
				
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(453,5,192,373)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(456,8,186,367)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(455,8,188,26)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(457,152,184,2)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(455,153,188,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(517,12,65,15),new Bitmap(new TaskAboutTagAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(533,157,34,15),new Bitmap(new AewardItemTagAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(160,9,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(230,9,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(347,9,2,20),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,438,306),_rowBg),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,57,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,85,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,113,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,141,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,169,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,197,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,225,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,253,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,281,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,309,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,337,438,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(8,365,438,2)),
				
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(60,11,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.name"),MAssetLabel.LABEL_TYPE_TITLE2,"left")));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(170,11,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2,"left")));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(264,11,28,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.state"),MAssetLabel.LABEL_TYPE_TITLE2,"left")));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(380,11,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.belongMap"),MAssetLabel.LABEL_TYPE_TITLE2,"left")));
			
			_itemList = [];
			_cellList = [];
			
			_itemMTile = new MTile(438,28);
			_itemMTile.itemGapH = _itemMTile.itemGapW = 0;
			_itemMTile.setSize(438,345);
			_itemMTile.move(8,30);
			addChild(_itemMTile);
			_itemMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_itemMTile.verticalScrollBar.lineScrollSize = 28;
			
			_cellMTile = new MTile(38, 38, 4);
			_cellMTile.itemGapH = 3;
			_cellMTile.itemGapW = 4;
			_cellMTile.setSize(165, 162);
			_cellMTile.move(467,185);
			addChild(_cellMTile);
			_cellMTile.horizontalScrollPolicy = _cellMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			_desciptionLabel = new TextField();
			_desciptionLabel.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,3);
			_desciptionLabel.mouseEnabled = _desciptionLabel.mouseWheelEnabled = false;
			_desciptionLabel.width = 180;
			_desciptionLabel.height = 111;
			_desciptionLabel.x = 462;
			_desciptionLabel.y = 37;
			_desciptionLabel.wordWrap = true;
			_desciptionLabel.multiline = true;
			addChild(_desciptionLabel);
		}
		
		private function initTemplateData():void
		{
			for each(var bossTemplateInfo:BossTemplateInfo in BossTemplateInfoList.list)
			{
				var itemView:BossItemView = new BossItemView(bossTemplateInfo);
				_itemMTile.appendItem(itemView);
				_itemList.push(itemView);
			}
			if(_itemList.length > 0)
			{
				switchTo(_itemList[0]);
			}
			_itemMTile.sortOn(['sortFieldBossType', 'sortFieldBossMapId', 'sortFieldBossLevel'],[Array.NUMERIC, Array.NUMERIC, Array.NUMERIC]);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _itemList.length; i++)
			{
				BossItemView(_itemList[i]).addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			_mediator.moduel.activityInfo.addEventListener(ActivityInfoEvents.UPDATE_BOSS_INFO, handleBossInfoUpdate);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _itemList.length; i++)
			{
				BossItemView(_itemList[i]).removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			
			_mediator.moduel.activityInfo.removeEventListener(ActivityInfoEvents.UPDATE_BOSS_INFO, handleBossInfoUpdate);
		}
		
		private function handleBossInfoUpdate(e:Event):void
		{
			clearView();
			var item:BossItemView;
			var list:Dictionary = _mediator.moduel.activityInfo.bossList;
			for(var i:int = 0; i < _itemList.length; i++)
			{
				item = _itemList[i];
				item.bossItemInfo = list[item.info.id];
			}
		}
		
		private function clearView():void
		{
			var item:BossItemView;
			for(var i:int = 0; i < _itemList.length; i++)
			{
				item = _itemList[i];
				item.bossItemInfo = null;
			}
		}
		
		private function switchTo(value:BossItemView):void
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
			var target:BossItemView = evt.currentTarget as BossItemView;
			if(_currentItem == target) return;
			switchTo(target);
		}
		
		private function updateView():void
		{
			clearCells();
			
			var cell:AwardCell;
			var awards:Array = _currentItem.info.drop;
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
			BossInfoSocketHandler.send();
			
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