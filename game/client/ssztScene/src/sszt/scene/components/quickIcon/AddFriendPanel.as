package sszt.scene.components.quickIcon
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.data.quickIcon.iconInfo.FriendIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.ui.WinTitleHintAsset;

	/**
	 * 添加好友详情 
	 * @author lisg
	 * 
	 */	
	public class AddFriendPanel extends MPanel
	{
		private static var _instance:AddFriendPanel;
		
		private var _bg:IMovieWrapper;
		
		
		private var _allAgree:MCacheAssetBtn1;
		private var _allNoAgree:MCacheAssetBtn1;
		private var _itemMTile:MTile;
		public var _quickIconMediator:QuickIconMediator;
		private var _pageView:PageView;
		
		
		public function AddFriendPanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.AddFriendTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.AddFriendTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1,true,false);
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(276,280);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,260,270)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,252,224)),
			]);
			addContent(_bg as DisplayObject);
			
			_itemMTile = new MTile(246,36);
			_itemMTile.itemGapH = 1;
			_itemMTile.itemGapW = 0;
			_itemMTile.setSize(246,184);
			_itemMTile.move(15,9);
			addContent(_itemMTile);
			_itemMTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_itemMTile.verticalScrollBar.lineScrollSize = 26;
			
			_allAgree = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.allAgree"));
			_allAgree.move(65,237);
			addContent(_allAgree);
			
			_allNoAgree = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.allRefuse"));
			_allNoAgree.move(142,237);
			addContent(_allNoAgree);
			
			_pageView = new PageView(1,false, 100);
			_pageView.move(84, 198);
			addContent(_pageView);
			
			initEvents();
		}
		
		public static function getInstance():AddFriendPanel
		{
			if(_instance == null)
			{
				_instance = new AddFriendPanel();
			}
			return _instance;
		}
		
		public function show(argMediator:QuickIconMediator):void
		{
			if(GlobalData.quickIconInfo.friendIconInfoList==null)return;
			_quickIconMediator = argMediator;
			this.x = CommonConfig.GAME_WIDTH/2 - 206 ;
			this.y = CommonConfig.GAME_HEIGHT/2 - 226;
			if (!(parent)){
				GlobalAPI.layerManager.addPanel(this);
			};
			
			
			
			initEvents();
			initTitleData(null);
			_pageView.setPage(1);
		}
		
	
		
		private function pageChangeHandler(e:PageEvent):void
		{
			initTitleData(null);
		}
		private function getList(pageIndex:int = 0,pageSize:int = 5):Array
		{
			var result:Array;
			result = [];
			if(GlobalData.quickIconInfo.friendIconInfoList.length>0)
			{
				for each(var fd:FriendIconInfo in GlobalData.quickIconInfo.friendIconInfoList)
				{
					result.push(fd);
				}
			}
			_pageView.totalRecord = Math.ceil(result.length/pageSize);
			_pageView.setPage(_pageView.currentPage);
			return result.slice(pageIndex * pageSize,(pageIndex + 1) * pageSize);			
		}
		
		private function initTitleData(evt:QuickIconInfoEvent):void
		{
			_itemMTile.disposeItems();
			var list:Array = getList(_pageView.currentPage - 1);				
			for each(var j:FriendIconInfo in list)
			{
				var friendView:FriendItemView = new FriendItemView(j,_quickIconMediator);
				_itemMTile.appendItem(friendView);
			}	
			
		}
		
		private function initEvents():void
		{
			GlobalData.quickIconInfo.addEventListener(QuickIconInfoEvent.FRIEND_ICON_CHANGE,initTitleData)
			_allAgree.addEventListener(MouseEvent.CLICK,allAgree);
			_allNoAgree.addEventListener(MouseEvent.CLICK,allNoAgree);
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			
		}
		
		private function allAgree(evt:MouseEvent):void
		{
			if(GlobalData.quickIconInfo.friendIconInfoList.length>0)
			{
				for each(var fdFnfo1:FriendIconInfo in GlobalData.quickIconInfo.friendIconInfoList)
				{
					_quickIconMediator.sendFriendAccept(fdFnfo1.id,true);
				}
				GlobalData.quickIconInfo.setFriendIconInfoList();
			}
			dispose();
		}
		private function allNoAgree(evt:MouseEvent):void
		{
			if(GlobalData.quickIconInfo.friendIconInfoList.length>0)
			{
				for each(var fdFnfo2:FriendIconInfo  in GlobalData.quickIconInfo.friendIconInfoList)
				{
					_quickIconMediator.sendFriendAccept(fdFnfo2.id,false);
				}
				GlobalData.quickIconInfo.setFriendIconInfoList();
			}
			dispose();
		}
		private function removeEvents():void
		{
			GlobalData.quickIconInfo.removeEventListener(QuickIconInfoEvent.FRIEND_ICON_CHANGE,initTitleData)
			_allAgree.removeEventListener(MouseEvent.CLICK,allAgree);
			_allNoAgree.removeEventListener(MouseEvent.CLICK,allNoAgree);
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
		}
		
		
		
		override public function dispose():void
		{
			validate();
			removeEvents();
			_instance = null;
			super.dispose();
		}
		
	}
}