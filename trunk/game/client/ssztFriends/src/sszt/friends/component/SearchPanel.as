package sszt.friends.component
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.socketHandlers.im.QueryFriendInfoSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.friends.FindTitleAsset;
	
	public class SearchPanel extends MPanel
	{
		private var _mediator:FriendsMediator;
		private var _bg:IMovieWrapper;
		private var _searchBtn:MCacheAssetBtn1;
		private var _searchInput:TextField;
		private var _addFriendBtn:MCacheAssetBtn1;
		private var _addBlackBtn:MCacheAssetBtn1;
		private var _playerInfoView:PlayerInfoView;
		private var _searchData:Object;
		private var _combobox:ComboBox;
		
		public function SearchPanel(mediator:FriendsMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new FindTitleAsset())),true,-1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(340, 177);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(10, 2, 320, 128)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(18, 10, 304, 28))
				]);
			addContent(_bg as DisplayObject);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(22,16,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.playerName") + "：",MAssetLabel.LABEL_TYPE_TAG)));

			_combobox = new ComboBox();
			_combobox.setSize(50,20);
			_combobox.move(72,9);
			_combobox.editable = false;
			var dp:DataProvider = new DataProvider();
			var index:int = 0;
			for each(var id:int in GlobalData.serverList)
			{
				if(id == GlobalData.selfPlayer.serverId)index = GlobalData.serverList.indexOf(String(id));
				dp.addItem({label:LanguageManager.getWord("ssztl.common.serverValue",id),value:id});
			}
			_combobox.dataProvider = dp;
			addContent(_combobox);
			_combobox.selectedIndex = index;
			_combobox.visible = false;
			
			_searchInput = new TextField();
			_searchInput.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_searchInput.type = TextFieldType.INPUT;
			_searchInput.x = 85;
			_searchInput.y = 16;
			_searchInput.width = 155;
			_searchInput.height = 16;
			addContent(_searchInput);
			
			_searchBtn = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.friends.searchFriend"));
			_searchBtn.move(257,12);
			addContent(_searchBtn);
			
			_addFriendBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.friends.addFriend"));
			_addFriendBtn.move(93,139);
			addContent(_addFriendBtn);
			_addFriendBtn.enabled = false;
			
			_addBlackBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.blackList"));
			_addBlackBtn.move(173,139);
			addContent(_addBlackBtn);
			_addBlackBtn.enabled = false;
			
			_playerInfoView = new PlayerInfoView();
			_playerInfoView.move(0,38);
			addContent(_playerInfoView);
							
		}
		
		private function initEvent():void
		{
			_searchBtn.addEventListener(MouseEvent.CLICK,searchBtnClickHandler);
			_addFriendBtn.addEventListener(MouseEvent.CLICK,addFriendBtnClickHandler);
			_addBlackBtn.addEventListener(MouseEvent.CLICK,addBlackBtnClickHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.QUERY_RETURN,returnHandler);
		}
		
		private function removeEvent():void
		{
			_searchBtn.removeEventListener(MouseEvent.CLICK,searchBtnClickHandler);
			_addFriendBtn.removeEventListener(MouseEvent.CLICK,addFriendBtnClickHandler);
			_addBlackBtn.removeEventListener(MouseEvent.CLICK,addBlackBtnClickHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.QUERY_RETURN,returnHandler);
		}
		
		private function returnHandler(evt:FriendEvent):void
		{
			_searchData = evt.data;
			if(evt.data)
			{
				_addBlackBtn.enabled = true;
				_addFriendBtn.enabled = true;
			}
			else
			{
				_addBlackBtn.enabled = false;
				_addFriendBtn.enabled = false;
			}
			_playerInfoView.showInfo(evt.data);
		}
		
		private function searchBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_searchInput.text == "") 
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.nameNull"));
				return;
			}
			if(_searchInput.text == ("[" + GlobalData.selfPlayer.serverId + "]" + GlobalData.selfPlayer.nick))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.cannotSearchSelf"));
				return ;
			}
			QueryFriendInfoSocketHandler.sendQuery(_combobox.selectedItem.value,_searchInput.text);
		}
		
		private function addFriendBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.imPlayList.getFriend(_searchData.id))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.friendExist"));
			}else
			{
				FriendUpdateSocketHandler.sendAddFriend(_combobox.selectedItem.value,_searchInput.text,true);
			}
			dispose();
		}
		
		private function addBlackBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			FriendUpdateSocketHandler.sendAddFriend(_combobox.selectedItem.value,_searchInput.text,false);
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_searchBtn)
			{
				_searchBtn.dispose();
				_searchBtn = null;
			}
			_searchInput = null;
			if(_addFriendBtn)
			{
				_addFriendBtn.dispose();
				_addFriendBtn = null;
			}
			if(_addBlackBtn)
			{
				_addBlackBtn.dispose();
				_addBlackBtn = null;
			}
			if(_playerInfoView)
			{
				_playerInfoView.dispose();
				_playerInfoView = null;
			}
			_searchData = null;
			super.dispose();
		}
		
	}
}