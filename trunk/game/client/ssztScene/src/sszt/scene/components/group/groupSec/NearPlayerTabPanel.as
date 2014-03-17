package sszt.scene.components.group.groupSec
{
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.group.groupSec.NearUnteamPlayerItem;
	import sszt.scene.data.team.BaseTeamInfo;
	import sszt.scene.data.team.UnteamPlayerInfo;
	import sszt.scene.events.NearDataUpdateEvent;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.GroupMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	import sszt.ui.styles.TextFormatType;
	
	public class NearPlayerTabPanel extends MSprite implements IgroupTabView
	{
		private var _mediator:GroupMediator;
		private var _bg:IMovieWrapper;
//		private var _bg1:Bitmap;
//		private var _searchBtn:MCacheAssetBtn1,_createBtn:MCacheAssetBtn1;
		private var _pageView:PageView;
//		private var _searchClub:String,_searchMaster:String;
		private var _tile:MTile;
		private var _list:Array;
//		private var _clubSearch:TextField,_masterSearch:TextField;
		private var _currentPlayerItem:NearUnteamPlayerItem;
		
		private static const PAGESIZE:int = 8;
//		public static var SELECTEDBORDER:SelectedBorder;
		private var _tip:MAssetLabel;
		
		public function NearPlayerTabPanel(mediator:GroupMediator)
		{
			_mediator = mediator;
//			_mediator.clubInfo.initClubList();
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(134,4,2,20),new MCacheSplit1Line()),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(144,4,2,20),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(209,4,2,20),new MCacheSplit1Line()),
			]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(41,6,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.role") ,MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(154,6,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(165,6,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(220,6,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.strike"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(227,6,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT)));
			
			
			_pageView = new PageView(PAGESIZE,false,92);
			_pageView.move(88,290);
			addChild(_pageView);
			
			_list = [];
			_tile = new MTile(266,32);
			_tile.setSize(266,256);
			_tile.move(3,27);
			_tile.itemGapH = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = "off";
			addChild(_tile);
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_tip.textColor = 0x827960;
			_tip.move(134,125);
			addChild(_tip);
			_tip.setHtmlValue(LanguageManager.getWord("ssztl.chat.noNearbyPlayer"));
						
			getData();
		}
		
		
		private function initDataView():void
		{
			clearDataView();
			
			var players:Array = _mediator.sceneInfo.nearData.unteamPlayers;
			_pageView.totalRecord = players.length;
			for each(var i:UnteamPlayerInfo in players)
			{
				var unteamPlayer:NearUnteamPlayerItem = new NearUnteamPlayerItem(i);
				_list.push(unteamPlayer);				
			}			
			var currentPage:int = _pageView.currentPage;
			
			var temp:Array = _list.slice(( currentPage - 1) * PAGESIZE,currentPage * PAGESIZE);
			for each(var player:NearUnteamPlayerItem in temp)
			{
//				var player:NearUnteamPlayerItem = new NearUnteamPlayerItem(t);
				_tile.appendItem(player);
			}
			if(temp.length == 0) _tip.visible = true;
			else  _tip.visible = false;
			invalidate(InvalidationType.STATE);
		}		
		
		private function clearDataView():void
		{
			_tile.clearItems();
			_currentPlayerItem = null;
			for(var i:int = 0; i < _list.length; i++)
			{
				_list[i].dispose();
			}
			_list = [];
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.nearData.addEventListener(NearDataUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,teamPlayerUpdateHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,teamPlayerUpdateHandler);
//			_mediator.clubInfo.clubListInfo.addEventListener(ClubListInfoUpdateEvent.SETCLUBLIST,setClubListHandler);
//			_searchBtn.addEventListener(MouseEvent.CLICK,searchBtnClickHandler);
//			_createBtn.addEventListener(MouseEvent.CLICK,createBtnClickHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.nearData.removeEventListener(NearDataUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,teamPlayerUpdateHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,teamPlayerUpdateHandler);
//			_mediator.clubInfo.clubListInfo.removeEventListener(ClubListInfoUpdateEvent.SETCLUBLIST,setClubListHandler);
//			_searchBtn.removeEventListener(MouseEvent.CLICK,searchBtnClickHandler);
//			_createBtn.removeEventListener(MouseEvent.CLICK,createBtnClickHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		public function assetsCompleteHandler():void
		{
//			_bg1.bitmapData = AssetUtil.getAsset("ssztui.club.ClubListBgAsset",BitmapData) as BitmapDaa;
		}
		
		private function setDataCompleteHandler(evt:NearDataUpdateEvent):void
		{
			initDataView();
		}
		
		private function teamPlayerUpdateHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			getData();
		}
		
//		private function playerItemClickHandler(evt:MouseEvent):void
//		{
//			if(_currentPlayerItem) 
//			{
//				_currentPlayerItem.selected = false;
//				_currentPlayerItem = null;
//			}
//			if(evt.currentTarget is NearUnteamPlayerItem)
//			{
//				_currentPlayerItem = evt.currentTarget as NearUnteamPlayerItem;
//				_currentPlayerItem.selected = true;
//			}
//		}
		public function refash():void
		{
			getData();
		}
//		private function clearItems():void
//		{
//			for(var i:int = 0; i < _list.length; i++)
//			{
//				_list[i].dispose();
//			}
//			_list = [];
//			_tile.clearItems();
//		}
				
		private function pageChangeHandler(e:PageEvent):void
		{
			getData();
		}
		
		private function getData():void
		{
//			ClubQueryListSocketHandler.send(_pageView.currentPage,PAGESIZE,_searchClub,_searchMaster);
			_mediator.getNearlyData();
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
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_list)
			{
				for(var i:int = 0; i < _list.length; i++)
				{
					_list[i].dispose();
				}
			}
			_list = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			_tip = null;
//			_mediator.clubInfo.clearClubList();
			_mediator = null;
			super.dispose();
		}
	}
}