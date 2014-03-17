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
	import sszt.scene.data.resourceWar.ResourceWarCampRankItemInfo;
	import sszt.scene.data.resourceWar.ResourceWarInfoUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	import ssztui.scene.DotaCampRankIndexAsset;
	
	public class ResourceWarCampRankView extends MSprite
	{
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		
		private var _rankIndex:Bitmap;
		
		public function ResourceWarCampRankView(argMediator:SceneMediator)
		{
			_mediator = argMediator;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
//			_bg = BackgroundUtils.setBackground([
//				
//			]);
//			addChild(_bg as DisplayObject);
			
			_tile = new MTile(230,58,1);
			_tile.setSize(230, 174);
			_tile.move(3,11);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_rankIndex = new Bitmap(new DotaCampRankIndexAsset());
			_rankIndex.x = 1;
			_rankIndex.y = 7;
			addChild(_rankIndex);
			
			initEvents();
		}
		private function initEvents():void
		{
			_mediator.sceneModule.resourceWarInfo.addEventListener(ResourceWarInfoUpdateEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
		}
		private function removeEvents():void
		{
			_mediator.sceneModule.resourceWarInfo.removeEventListener(ResourceWarInfoUpdateEvent.RANK_INFO_UPDATE,rankInfoUpdateHandler);
		}
		private function rankInfoUpdateHandler(event:Event):void
		{
			clearView();
			var rankList:Array = _mediator.sceneModule.resourceWarInfo.campRankList
			var itemInfo:ResourceWarCampRankItemInfo;
			var itemView:ResourceWarCampRankItemView;
			for(var i:int = 0; i < rankList.length; i++)
			{
				itemInfo = rankList[i];
				itemView = new ResourceWarCampRankItemView();
				itemView.updateView(itemInfo);
				_tile.appendItem(itemView);
			}
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
			if(_rankIndex && _rankIndex.bitmapData)
			{
				_rankIndex.bitmapData.dispose();
				_rankIndex = null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			super.dispose();
		}
		
	}
}