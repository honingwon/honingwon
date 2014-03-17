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
	import flash.text.TextFormatAlign;
	
	import sszt.activity.components.cell.AwardCell;
	import sszt.activity.components.itemView.CopyItemView;
	import sszt.activity.data.ActivityInfo;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyEnterNumberList;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.copy.CopyType;
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
	import ssztui.activity.FBAboutTagAsset;
	
	/**
	 * 每日副本
	 */
	public class CopyTabPanel extends Sprite implements IActivityTabPanel
	{
		private var _mediator:ActivityMediator;
		
		private var _bg:IMovieWrapper;
		private var _desciptionLabel:TextField;
		private var _itemMTile:MTile;
		private var _cellMTile:MTile;
		
		private var _copyItemViewList:Array;
		private var _cellViewList:Array;
		private var _currentItemView:CopyItemView;
		
		public static var COLWidth:Array = [180,70,70,100];
		
		public function CopyTabPanel(argMediator:ActivityMediator)
		{
			_mediator = argMediator;
			super();
			initialView();
		}
		
		private function initialView():void
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
//				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(456,8,186,367)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(432,7,170,26)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(432,180,170,2)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(432,181,170,26)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(485,12,65,15),new Bitmap(new FBAboutTagAsset() as BitmapData)),
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
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(431,360,172,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.updataCopyCount"),MAssetLabel.LABEL_TYPE_TAG)),
				
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6,10,COLWidth[0],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.copyName"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[0],10,COLWidth[1],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.enterLevel"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[1],10,COLWidth[2],16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.copyProgress"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(6+colX[2],10,COLWidth[3],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE2)));
			
			_desciptionLabel = new TextField();
			_desciptionLabel.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,4);
			_desciptionLabel.mouseEnabled = _desciptionLabel.mouseWheelEnabled = false;
			_desciptionLabel.width = 157;
			_desciptionLabel.height = 141;
			_desciptionLabel.x = 438;
			_desciptionLabel.y = 36;
			_desciptionLabel.wordWrap = true;
			_desciptionLabel.multiline = true;
			addChild(_desciptionLabel);
			
			_copyItemViewList = [];
			_cellViewList = [];
			
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
			_cellMTile.horizontalScrollPolicy = _cellMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			setDataHandler(null);
		}
				
		private function itemViewClickHandler(e:MouseEvent):void
		{
			setIndex(e.currentTarget as CopyItemView);
		}
		
		private function setIndex(argItemView:CopyItemView):void
		{
			if(_currentItemView == argItemView)return;
			if(_currentItemView)
			{
				_currentItemView.select = false;
			}
			_currentItemView = argItemView;
			_currentItemView.select = true;			
			updateView();
		}
		
		private function updateView():void
		{
			clearCellViewList();
			var _tmpCell:AwardCell;
			for(var i:int = 0;i < _currentItemView.copyTemplateInfo.award.length;i++)
			{
				_tmpCell = new AwardCell();
				_tmpCell.info = ItemTemplateList.getTemplate(_currentItemView.copyTemplateInfo.award[i]);
				if(_tmpCell.info != null)
				{
					_cellViewList.push(_tmpCell);
					_cellMTile.appendItem(_tmpCell);
				}
			}
			_desciptionLabel.htmlText = _currentItemView.copyTemplateInfo.descript;
		}
		
		private function clearCellViewList():void
		{
			_cellViewList.length = 0;
			_cellMTile.disposeItems();
		}
		
		private function compareFunction(copy1:CopyTemplateItem,copy2:CopyTemplateItem):int
		{
			if(copy1.minLevel > copy2.minLevel)
				return 1;
			else if(copy1.minLevel == copy2.minLevel)
			{
				if(copy1.id > copy2.id) return 1;
			}
			return -1;
		}
		
		private function clearCopyItemList():void
		{
			_itemMTile.disposeItems();
			_copyItemViewList = [];
		}
		
		private function setDataHandler(evt:Event):void
		{
			clearCopyItemList();
			var selfLevel:int = GlobalData.selfPlayer.level;
			var _copyItemView:CopyItemView;
			var tmpList:Array = CopyTemplateList.getListByType(0);
			tmpList.sort(compareFunction);
			for(var i:int = 0;i < tmpList.length;i++)
			{
				var minLevel:int = tmpList[i].minLevel;
				if(tmpList[i].isShowInActivity)
				{
					_copyItemView = new CopyItemView(tmpList[i],_mediator);
					_copyItemView.addEventListener(MouseEvent.CLICK,itemViewClickHandler);
					_copyItemViewList.push(_copyItemView);
					_itemMTile.appendItem(_copyItemView);
				}
			}
			if(tmpList.length > 0)
			{
				setIndex(_copyItemViewList[0]);
			}
		}
		
		public function show():void
		{
			GlobalData.copyEnterCountList.addEventListener(CopyEnterNumberList.SETDATACOMPLETE,setDataHandler);
//			_mediator.getCopyNumber();//已经在登录的时候获取最新所以不需要再更新
		}
		
		public function hide():void
		{
			GlobalData.copyEnterCountList.removeEventListener(CopyEnterNumberList.SETDATACOMPLETE,setDataHandler);
			if(_currentItemView) _currentItemView.select = false;
			_currentItemView = null;
			if(parent)parent.removeChild(this);
		}
		
		private function get activityInfo():ActivityInfo
		{
			return _mediator.moduel.activityInfo;
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			GlobalData.copyEnterCountList.removeEventListener(CopyEnterNumberList.SETDATACOMPLETE,setDataHandler);
			if(_currentItemView) _currentItemView = null;
			if(_bg) _bg.dispose();
			_bg = null;
			_mediator = null;
			_desciptionLabel = null;
			_itemMTile.disposeItems();
			_cellMTile.disposeItems();
			_itemMTile.dispose();
			_cellMTile.dispose();
			_itemMTile = null;
			_cellMTile = null;
			if(parent) parent.removeChild(this);
		}
	}
}