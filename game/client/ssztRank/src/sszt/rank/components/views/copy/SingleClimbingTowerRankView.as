package sszt.rank.components.views.copy
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.rank.components.itemView.copy.SingleClimbingTowerRankItemView;
	import sszt.rank.components.views.RankViewImpl;
	import sszt.rank.data.RankInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	public class SingleClimbingTowerRankView extends RankViewImpl
	{
		private var _colWidth:Array = [60, 240, 175]; 	//475
		private var _rankInfos:RankInfo;
		
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		
		private var _resultViewList:Array;
		
		public function SingleClimbingTowerRankView(rankInfos:RankInfo)
		{
			super();
			
			_rankInfos = rankInfos;
			_resultViewList = [];
			
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<_colWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+_colWidth[i]:_colWidth[0]+i*2);
			}
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(colX[0],1,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(colX[1],1,2,20),new MCacheSplit1Line()),
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,3,  _colWidth[0],16),new MAssetLabel(LanguageManager.getWord("ssztl.rank.stageNum"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(colX[0]+2,3,_colWidth[1],16),new MAssetLabel(LanguageManager.getWord("ssztl.rank.challenger"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(colX[1]+2,3,_colWidth[2],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.time"),MAssetLabel.LABEL_TYPE_TITLE2)));
			
			_tile = new MTile(475,28,1);
			_tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.move(0,23);
			_tile.setSize(475,280);
			addChild(_tile);
		}
		
		public function setData():void
		{
			var itemView:SingleClimbingTowerRankItemView;
			var list:Array = _rankInfos.getCurrRankInfo(0);
			
			_tile.clearItems();
			
			if(_resultViewList && _resultViewList.length>0)
			{
				for each(itemView in _resultViewList)
				{
					itemView.removeEventListener(MouseEvent.CLICK,itemClickHandler);
					itemView.dispose();
					itemView = null;
				}
			}
			_resultViewList = [];
			for(var i:int = 0; i < list.length; i++)
			{
				itemView = new SingleClimbingTowerRankItemView(list[i]);
				itemView.addEventListener(MouseEvent.CLICK, itemClickHandler);
				_resultViewList.push(itemView);
				_tile.appendItem(itemView);
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			curItemChange(evt.currentTarget as SingleClimbingTowerRankItemView);
		}
		
		private function curItemChange(item:SingleClimbingTowerRankItemView):void
		{
			item.select = true;
		}
		
		override public function hide():void
		{
			super.hide();
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			
			if(_resultViewList)
			{
				for each(var itemView:SingleClimbingTowerRankItemView in _resultViewList)
				{
					itemView.dispose();	
					itemView = null;
				}
				_resultViewList = null;
			}
			
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			
			_rankInfos = null;
			super.dispose();
		}
	}
}