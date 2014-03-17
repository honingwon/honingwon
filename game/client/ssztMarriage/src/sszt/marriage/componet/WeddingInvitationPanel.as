package sszt.marriage.componet
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.marriage.MarriageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.marriage.componet.item.WeddingInvitationItemView;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.marriage.InviteTitleAsset;
	import ssztui.ui.SplitCompartLine2;
	
	/**
	 * 邀请好友参加婚礼
	 * */
	public class WeddingInvitationPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _inviteHandler:Function;
		private var _pageChangeHandler:Function;
		private var _oneClickInvitationHandler:Function;
		
		private var _btnOneClickInvitation:MCacheAssetBtn1;
		private var _pageView:PageView;
		private var _tile:MTile;		
		
		public function WeddingInvitationPanel(oneClickInvitationHandler:Function, inviteHandler:Function, pageChangeHandler:Function)
		{
			_oneClickInvitationHandler = oneClickInvitationHandler;
			_inviteHandler = inviteHandler;
			_pageChangeHandler = pageChangeHandler;
			
			super(new MCacheTitle1("",new Bitmap(new InviteTitleAsset())),true,-1,true,true);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(364,385);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,348,375)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,340,367)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,372,340,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(15,9,334,24)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(145,10,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(197,10,2,22),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(269,10,2,22),new MCacheSplit1Line()),
				
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,33,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,63,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,93,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,123,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,153,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,183,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,213,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,243,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,273,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,303,334,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,333,334,2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15,13,130,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.name"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(147,13,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.level"),MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(199,13,70,15),new MAssetLabel(LanguageManager.getWord("ssztl.friend.closeRelation"),MAssetLabel.LABEL_TYPE_TITLE2)),
			]);
			addContent(_bg as DisplayObject);
			
			_btnOneClickInvitation = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.marry.inviteAll"));
			_btnOneClickInvitation.move(273,341);
			addContent(_btnOneClickInvitation);
			
			_pageView = new PageView(MarriageInfo.WEDDING_INVITATION_PAGESIZE,false,110);
			_pageView.move(127,340);
			addContent(_pageView);
			
			_tile = new MTile(340,30,1);
			_tile.setSize(340,300);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile.move(15,34);
			_tile.verticalScrollBar.lineScrollSize = 30;
			addContent(_tile);
		}
		
		private function initEvent():void
		{
			_btnOneClickInvitation.addEventListener(MouseEvent.CLICK,_oneClickInvitationHandler);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,_pageChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnOneClickInvitation.removeEventListener(MouseEvent.CLICK,_oneClickInvitationHandler);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,_pageChangeHandler);
		}
		
		public function updateView(data:Array, total:int):void
		{
			clearView();
			
			_pageView.totalRecord = total;
			
			var itemView:WeddingInvitationItemView;
			var dataItem:ImPlayerInfo;
			for each(dataItem in data)
			{
				itemView = new WeddingInvitationItemView(dataItem,_inviteHandler);
				_tile.appendItem(itemView);
			}
		}
		
		public function disableAllBtn():void
		{
			var items:Array = _tile.getItems();
			var item:WeddingInvitationItemView;
			for each(item in items)
			{
				item.disableBtn();
			}
		}
		
		private function clearView():void
		{
			_tile.disposeItems();
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			
			_inviteHandler = null;
			_pageChangeHandler = null;
			_oneClickInvitationHandler = null;
			
			if(_btnOneClickInvitation)
			{
				_btnOneClickInvitation.dispose();
				_btnOneClickInvitation= null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView= null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile= null;
			}
		}
	}
}