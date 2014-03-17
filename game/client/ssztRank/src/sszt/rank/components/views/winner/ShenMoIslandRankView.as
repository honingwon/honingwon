package sszt.rank.components.views.winner
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.rank.components.itemView.winner.ShenMoIslandRankItemView;
	import sszt.rank.components.views.RankViewImpl;
	import sszt.rank.data.RankInfo;
	import sszt.rank.data.RankType;
	import sszt.rank.events.RankEvent;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	public class ShenMoIslandRankView extends RankViewImpl
	{
		private var _bg:IMovieWrapper;
		private var _resultViewList:Array;
		private var _tile:MTile;
		private var _rankInfos:RankInfo;
		private var _curItemView:ShenMoIslandRankItemView;
		
		public function ShenMoIslandRankView(rankInfos:RankInfo)
		{
			super();
			_rankInfos = rankInfos;
			_resultViewList = [];
			
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(56,5,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(320,5,11,17),new MCacheSplit3Line())
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(19,6,28,16),new MAssetLabel(LanguageManager.getWord("ssztl.rank.stageNum"),MAssetLabel.LABELTYPE3)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(179,6,28,16),new MAssetLabel(LanguageManager.getWord("ssztl.rank.winner"),MAssetLabel.LABELTYPE3)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(353,6,28,16),new MAssetLabel(LanguageManager.getWord("ssztl.rank.passTime"),MAssetLabel.LABELTYPE3)));
			
			_tile = new MTile(389,33,1);
			_tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = 0;
			_tile.itemGapW = 0;
			_tile.move(0,24);
			_tile.setSize(412,334);
			addChild(_tile);
		}
		
		override public function initEvents():void
		{
			_rankInfos.addEventListener(RankEvent.SHENMOISLAND_UPDATE,listUpdateHandler);
		}
		
		override public function removeEvents():void
		{
			_rankInfos.removeEventListener(RankEvent.SHENMOISLAND_UPDATE,listUpdateHandler);
		}
		
		private function listUpdateHandler(evt:RankEvent):void
		{
			var rankType:RankType = evt.data as RankType;
			var itemView:ShenMoIslandRankItemView;
			var list:Array = _rankInfos.shenMoIslandList;
			if(_tile)
			{
				_tile.clearItems();
			}
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
			for(var i:int = RankInfo.PAGE_SIZE*(_rankInfos.currentPage-1);i<RankInfo.PAGE_SIZE*_rankInfos.currentPage;i++)
			{
				if(list && list[i])
				{
					itemView = new ShenMoIslandRankItemView(list[i]);
					itemView.addEventListener(MouseEvent.CLICK,itemClickHandler);
//					itemView.itemInfo = list[i];
					_resultViewList.push(itemView);
					_tile.appendItem(itemView);
				}
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			curItemChange(evt.currentTarget as ShenMoIslandRankItemView);
		}
		
		private function curItemChange(item:ShenMoIslandRankItemView):void
		{
//			item.addChild(RankPanel.SELECTED_SHAPE);
			item.select = true;
		}
		
		override public function hide():void
		{
			super.hide();
			_curItemView = null;
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
				for each(var itemView:ShenMoIslandRankItemView in _resultViewList)
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
			_curItemView = null;
			super.dispose();
		}
	}
}