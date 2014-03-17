package sszt.club.components.clubMain.pop.sec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import sszt.club.components.clubMain.pop.items.ClubListItem;
	import sszt.club.datas.list.ClubListItemInfo;
	import sszt.club.events.ClubListInfoUpdateEvent;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubQueryListSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	import sszt.ui.styles.TextFormatType;
	
	public class ClubListPanel extends MSprite implements IClubMainPanel
	{
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _searchBtn:MCacheAssetBtn1,_createBtn:MCacheAssetBtn1;
		private var _pageView:PageView;
		private var _evenRowBg:Shape;
		private var _searchClub:String;//_searchMaster:String;
		private var _tile:MTile;
		private var _list:Array;
		private var _clubSearch:TextField;//_masterSearch:TextField;
		
		private const PAGESIZE:int = 10;
		
		public function ClubListPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			_mediator.clubInfo.initClubList();
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([				
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(5,4,625,316)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,319,625,25),new MCacheCompartLine2()),
//				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(7,6,621,312)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(70,328,125,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(258,328,125,22)), 
//				new BackgroundInfo(BackgroundType.BORDER_7,new Rectangle(264,351,134,24)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(9,8,617,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(59,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(188,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(337,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(388,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(469,9,2,19),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(520,9,2,19),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,55,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,80,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,105,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,130,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,155,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,180,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,205,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,230,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,255,617,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,280,617,2))
			]);
			addChild(_bg as DisplayObject);
			_evenRowBg = new Shape();	
			_evenRowBg.graphics.beginFill(0x172527,1);
			_evenRowBg.graphics.drawRect(9,57,617,23);
			_evenRowBg.graphics.drawRect(9,107,617,23);
			_evenRowBg.graphics.drawRect(9,157,617,23);
			_evenRowBg.graphics.drawRect(9,207,617,23);
			_evenRowBg.graphics.drawRect(9,257,617,23);
			addChild(_evenRowBg);

			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(12,331,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(207,331,64,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubLeader") + "：",MAssetLabel.LABEL_TYPE_TAG)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(21,11,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.rank"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(99,11,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubName"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(251,11,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubLeader") ,MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(350,11,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(404,11,52,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.clubMoney"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(482,11,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.club.member"),MAssetLabel.LABEL_TYPE_TITLE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(560,11,28,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABEL_TYPE_TITLE2)));
			
			_clubSearch = new TextField();
			_clubSearch.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_clubSearch.type = TextFieldType.INPUT;
			_clubSearch.maxChars = 10;
			_clubSearch.x = 73;
			_clubSearch.y = 331;
			_clubSearch.width = 135;
			_clubSearch.height = 18;
			addChild(_clubSearch);
//			_masterSearch = new TextField();
//			_masterSearch.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
//			_masterSearch.type = TextFieldType.INPUT;
//			_masterSearch.maxChars = 10;
//			_masterSearch.x = 261;
//			_masterSearch.y = 331;
//			_masterSearch.width = 135;
//			_masterSearch.height = 18;
//			addChild(_masterSearch);
			
			_searchBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.searchClub"));
			_searchBtn.move(390,328);
			addChild(_searchBtn);
			_createBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.club.createClub"));
			_createBtn.move(550,328);
			addChild(_createBtn);
			_createBtn.visible = GlobalData.selfPlayer.clubId == 0;
			
			_pageView = new PageView(PAGESIZE);
			_pageView.move(249,288);
			addChild(_pageView);
			
			_list = [];
			_tile = new MTile(617,25);
			_tile.setSize(617,250);
			_tile.move(9,31);
			_tile.itemGapH = 0;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = "off";
			addChild(_tile);
			
			getData();
		}
		
		private function initEvent():void
		{
			_mediator.clubInfo.clubListInfo.addEventListener(ClubListInfoUpdateEvent.SETCLUBLIST,setClubListHandler);
			_searchBtn.addEventListener(MouseEvent.CLICK,searchBtnClickHandler);
			_createBtn.addEventListener(MouseEvent.CLICK,createBtnClickHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.clubInfo.clubListInfo.removeEventListener(ClubListInfoUpdateEvent.SETCLUBLIST,setClubListHandler);
			_searchBtn.removeEventListener(MouseEvent.CLICK,searchBtnClickHandler);
			_createBtn.removeEventListener(MouseEvent.CLICK,createBtnClickHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		public function assetsCompleteHandler():void
		{
		}
		
		private function setClubListHandler(e:ClubListInfoUpdateEvent):void
		{
			clearItems();
			
			_pageView.totalRecord = _mediator.clubInfo.clubListInfo.total;
			var list:Array = _mediator.clubInfo.clubListInfo.list;
			for(var i:int = 0; i < list.length; i++)
			{
				var item:ClubListItem = new ClubListItem(_mediator,list[i],(_pageView.currentPage - 1) * PAGESIZE + i + 1);
				_tile.appendItem(item);
				_list.push(item);
			}
		}
		
		private function clearItems():void
		{
			for each(var item:ClubListItem in _list)
			{
				item.dispose();
			}
			_list = [];
			_tile.clearItems();
		}
		
		private function searchBtnClickHandler(e:MouseEvent):void
		{
			_searchClub = _clubSearch.text;
//			_searchMaster = _masterSearch.text;
			getData();
		}
		
		private function createBtnClickHandler(e:MouseEvent):void
		{
			_mediator.sendNotification(ClubMediatorEvent.SHOW_CREATEPANEL);
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			getData();
		}
		
		private function getData():void
		{
			ClubQueryListSocketHandler.send(_pageView.currentPage,PAGESIZE,_searchClub);
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
			if(_searchBtn)
			{
				_searchBtn.dispose();
				_searchBtn = null;
			}
			if(_createBtn)
			{
				_createBtn.dispose();
				_createBtn = null;
			}			
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_evenRowBg)
			{
				_evenRowBg = null;
			}
			if(_list)
			{
				for each(var item:ClubListItem in _list)
				{
					item.dispose();
				}
			}
			_list = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			_mediator.clubInfo.clearClubList();
			_mediator = null;
			super.dispose();
		}
	}
}