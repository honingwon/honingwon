package sszt.scene.components.resourceWar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.resourceWar.ResourceWarInfoUpdateEvent;
	import sszt.scene.data.resourceWar.ResourceWarUserRankItemInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.scene.DotaCampRankIndexAsset;
	
	public class ResourceWarUserRankView extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneMediator;
		private var _tile:MTile;
		private var _pageView:PageView;

		public static var COLWidth:Array = [40,85,40,62];
		
		public function ResourceWarUserRankView(argMediator:SceneMediator)
		{
			_mediator = argMediator;
			super();
		}
		
		override protected function configUI():void
		{
			var colX:Array = [];
			for(var i:int=0; i<COLWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+COLWidth[i]:COLWidth[0]+i*2);
			}
			
			super.configUI();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(1,1,234,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(1+colX[0],2,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(1+colX[1],2,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(1+colX[2],2,2,20),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2,4,COLWidth[0],16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.rank"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2+colX[0],4,COLWidth[1],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.name"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2+colX[1],4,COLWidth[2],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.camp"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(2+colX[2],4,COLWidth[3],16),new MAssetLabel(LanguageManager.getWord("ssztl.common.YuanBaoScore"),MAssetLabel.LABEL_TYPE_TITLE2)),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(1,24,234,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(1,52,234,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(1,80,234,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(1,108,234,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(1,136,234,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(1,164,234,2)),
//				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,608,388)),				
			]);
			addChild(_bg as DisplayObject);
			
			_tile = new MTile(234,28,1);
			_tile.setSize(234, 140);
			_tile.move(1,25);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_pageView = new PageView(5,false,100);
			_pageView.move(68,170);
			addChild(_pageView);
			
			initEvents();
		}
		private function initEvents():void
		{
			_pageView.addEventListener(PageEvent.PAGE_CHANGE, _pageChangeHandler);
			_mediator.sceneModule.resourceWarInfo.addEventListener(ResourceWarInfoUpdateEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
		}
		
		private function removeEvents():void
		{
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE, _pageChangeHandler);
			_mediator.sceneModule.resourceWarInfo.removeEventListener(ResourceWarInfoUpdateEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
		}
		
		private function _pageChangeHandler(event:Event):void
		{
			clearView();
			_mediator.sceneModule.resourceWarInfo.currentPage = _pageView.currentPage;
		}
		
		private function rankInfoUpdateHandler(event:Event):void
		{
			clearView();
			var totalRankList:Array = _mediator.sceneModule.resourceWarInfo.rankList;
			var currRankList:Array = _mediator.sceneModule.resourceWarInfo.getCurrPageRankList();
			var itemInfo:ResourceWarUserRankItemInfo;
			var itemView:ResourceWarUserRankItemView;
			for(var i:int = 0; i < currRankList.length; i++)
			{
				itemInfo = currRankList[i];
				itemView = new ResourceWarUserRankItemView();
				itemView.updateView(itemInfo,i);
				_tile.appendItem(itemView);
			}
			_pageView.totalRecord = totalRankList.length;
		}
		
		public function clearView():void
		{
			if(_tile)
			{
				_tile.disposeItems();
			}
		}
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			removeEvents();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			super.dispose();
		}
	}
}