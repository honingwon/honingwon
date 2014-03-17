package sszt.friends.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.caches.PlayerIconCaches;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.GroupType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.im.FriendDeleteSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.friends.command.FriendsEndCommand;
	import sszt.friends.component.subComponent.ImAccordionGroupData;
	import sszt.friends.component.subComponent.ImMaccordion;
	import sszt.friends.component.subComponent.SearchBox;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.friends.FriendTitleAsset;
	import ssztui.friends.HeadBorderAsset;
	import ssztui.friends.HeartIconAsset;
	import ssztui.friends.SearchIcoAsset;
	
	public class MainPanel extends MPanel
	{
		private var _mediator:FriendsMediator;
		private var _bg:IMovieWrapper;
		private var _icon:Bitmap;
		private var _name:MAssetLabel;
		private var _txtLevel:MAssetLabel;
		private var _searchInput:TextField;
		private var _searchFriendBtn:MBitmapButton;
		private var _findPlayerBtn:MCacheAssetBtn1;
		private var _configureBtn:MCacheAssetBtn1;
		private var _maccordion:ImMaccordion;
		private var _groupData:Array;
		
		private var _headMask:MSprite;
		private var _headBorder:Bitmap;
		/**
		 * 好友度 
		 */		
		private var _friendship:MBitmapButton;
//		public static var bigIcons:Array = [null,new ShangWuBAsset1(),new ShangWuGAsset1(),new XiaoYaoBAsset1(),new XiaoYaoGAsset1(),new LiuXingBAsset1(),new LiuXingGAsset1()];
//		public static var smallIcons:Array = [null,new ShangWuBAsset2(),new ShangWuGAsset2(),new XiaoYaoBAsset2(),new XiaoYaoGAsset2(),new LiuXingBAsset2(),new LiuXingGAsset2()];
		
		public function MainPanel(mediator:FriendsMediator)
		{
			_mediator = mediator;
			initData();
			super(new Bitmap(new FriendTitleAsset()), true, -1);
			initEvent();
		}
		
		private function initData():void
		{
			var tempGroup:ImAccordionGroupData;
			_groupData = new Array();
			var groups:Array = GlobalData.imPlayList.getSelfGroup();
			tempGroup = new ImAccordionGroupData(GroupType.FRIEND,LanguageManager.getWord("ssztl.common.myFriends"),groups[0]);
			_groupData.push(tempGroup);
			for(var i:int = 1;i<groups.length;i++)
			{
				tempGroup = new ImAccordionGroupData(GlobalData.imPlayList.groups[i-1].gId,GlobalData.imPlayList.groups[i-1].gName,groups[i]);
				_groupData.push(tempGroup);
			}
			
			tempGroup = new ImAccordionGroupData(GroupType.ENEMY,LanguageManager.getWord("ssztl.common.enemy"),GlobalData.imPlayList.enemys);
			_groupData.push(tempGroup);
			tempGroup = new ImAccordionGroupData(GroupType.BLACK,LanguageManager.getWord("ssztl.common.blackList"),GlobalData.imPlayList.blacks);
			_groupData.push(tempGroup);
			tempGroup = new ImAccordionGroupData(GroupType.STRANGER,LanguageManager.getWord("ssztl.common.stranger"),GlobalData.imPlayList.strangers);
			_groupData.push(tempGroup);
			tempGroup = new ImAccordionGroupData(GroupType.RECENT,LanguageManager.getWord("ssztl.common.recentLinkman"),GlobalData.imPlayList.recents);
			_groupData.push(tempGroup);        
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(216,415);
			var _headBox:Sprite = new Sprite();
			_headBox.graphics.beginFill(0x172626,1);
			_headBox.graphics.drawRoundRect(0,0,48,48,14,14);
			_headBox.graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(10, 54, 196, 26)),
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(10, 82, 196, 287)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(15, 0, 48, 48),_headBox),
				]);
			addContent(_bg as DisplayObject);
			
//			headAssets.push(AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset1") as BitmapData,
//				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset2") as BitmapData,
//				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset3") as BitmapData,
//				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset4") as BitmapData,
//				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset5") as BitmapData,
//				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset6") as BitmapData);
			
			_headMask = new MSprite();
			_headMask.move(15,0);
			_headMask.graphics.beginFill(0x172626,1);
			_headMask.graphics.drawRoundRect(0,0,48,48,14,14);
			_headMask.graphics.endFill();
			addContent(_headMask);
			
			var index:int;
			index = GlobalData.selfPlayer.sex ? (GlobalData.selfPlayer.career *2 - 1):(GlobalData.selfPlayer.career *2 ) 
//			_icon = new Bitmap(bigIcons[index]);
//			_icon = new Bitmap(PlayerIconCaches.getIcon(PlayerIconCaches.MEDIUM,index));
//			_icon = new Bitmap(PlayerIconCaches.getIcon(-1,index));
			_icon = new Bitmap(AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset"+index) as BitmapData);
			_icon.x = index>2?-10:-25;
			_icon.y = -35;			
			addContent(_icon);
			_icon.mask = _headMask;
			
			_headBorder = new Bitmap(new HeadBorderAsset());
			_headBorder.x = 14; _headBorder.y = -1;
			addContent(_headBorder);
			
			_txtLevel = new MAssetLabel(GlobalData.selfPlayer.level + LanguageManager.getWord("ssztl.common.levelLabel"), MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			_txtLevel.move(73, 29);
			addContent(_txtLevel);
//			graphics.drawRoundRect();
			
			_name = new MAssetLabel("", MAssetLabel.LABEL_TYPE22, TextFormatAlign.LEFT);
			_name.move(73, 9);
			addContent(_name);
			_name.setHtmlValue("<font size='14'>"+GlobalData.selfPlayer.nick+"</font>");
			
			_searchInput = new TextField();
			_searchInput.type = TextFieldType.INPUT;
			_searchInput.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_searchInput.x = 16;
			_searchInput.y = 59;
			_searchInput.width = 160;
			_searchInput.height = 20;
			addContent(_searchInput);
			
			_friendship = new MBitmapButton(new HeartIconAsset());
			_friendship.move(175,15);
			addContent(_friendship);
			
			_searchFriendBtn = new MBitmapButton(new SearchIcoAsset());
//			_searchFriendBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.searchBtn"));
			_searchFriendBtn.move(180,56);
			addContent(_searchFriendBtn);
			
			_maccordion = new ImMaccordion(_mediator, _groupData, 185, 5, true);
			_maccordion.setSize(186,261);
			_maccordion.move(17,89);
			addContent(_maccordion);
			
			_findPlayerBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.friends.searchPlayer"));
			_findPlayerBtn.move(73, 377);
			addContent(_findPlayerBtn);
			
			_configureBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.friends.personalSetting"));
			_configureBtn.move(132, 356);
//			addContent(_configureBtn);
		}
		
		private function initEvent():void
		{
			_searchFriendBtn.addEventListener(MouseEvent.CLICK,searchBtnClickHandler);
			_findPlayerBtn.addEventListener(MouseEvent.CLICK,findBtnClickHandler);
			_configureBtn.addEventListener(MouseEvent.CLICK,configureBtnClickHandler);
			_friendship.addEventListener(MouseEvent.CLICK,friendshipClick);
			_friendship.addEventListener(MouseEvent.MOUSE_OVER,friendshipOver);
			_friendship.addEventListener(MouseEvent.MOUSE_OUT,friendshipOut);
		}
		
		private function removeEvent():void
		{
			_searchFriendBtn.removeEventListener(MouseEvent.CLICK,searchBtnClickHandler);
			_findPlayerBtn.removeEventListener(MouseEvent.CLICK,findBtnClickHandler);
			_configureBtn.removeEventListener(MouseEvent.CLICK,configureBtnClickHandler);
			_friendship.removeEventListener(MouseEvent.CLICK,friendshipClick);
			_friendship.removeEventListener(MouseEvent.MOUSE_OVER,friendshipOver);
			_friendship.removeEventListener(MouseEvent.MOUSE_OUT,friendshipOut);
		}
		
		private function searchBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_searchInput.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.inputFriendName"));
				return;
			}
//			var data:Vector.<Number> = GlobalData.imPlayList.search(_searchInput.text);
			var data:Array = GlobalData.imPlayList.search(_searchInput.text);
			if(data.length == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.noSearchResult"));
				return;
			}
			var pos:Point = new Point(evt.stageX - 140,evt.stageY + 15);
			SearchBox.getInstance().show(data,_mediator,pos);
			_searchInput.text = "";
			
		}
		
		private function findBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showSearchPanel();
		}
		
		private function configureBtnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showConfigurePanel();
//			_mediator.friendsModule.configurePanel.replyPanel.addEventListener(FriendEvent.SET_CHANGE,setChangeHandler);
		}
		
		private function friendshipClick(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showFriendShipPanel();
		}
		private function friendshipOver(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.friends.near"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function friendshipOut(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function setChangeHandler(evt:FriendEvent):void
		{
			_mediator.friendsModule.setChange(evt.data.auto,evt.data.replyContext);
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
			if(_icon && _icon.bitmapData)
			{
				_icon.bitmapData.dispose();
				_icon = null;
			}
			if(_headBorder && _headBorder.bitmapData)
			{
				_headBorder.bitmapData.dispose();
				_headBorder = null;
			}
			_name = null;
			_searchInput = null;
			if(_searchFriendBtn)
			{
				_searchFriendBtn.dispose();
				_searchFriendBtn = null;
			}
			if(_findPlayerBtn)
			{
				_findPlayerBtn.dispose();
				_findPlayerBtn = null;
			}
			if(_configureBtn)
			{
				_configureBtn.dispose();
				_configureBtn = null;
			}
			if(_maccordion)
			{
				_maccordion.dispose();
				_maccordion = null;
			}
			if(_txtLevel)
			{
				_txtLevel=null;
			}
			if(_headMask && _headMask.parent)
			{
				_headMask.graphics.clear();
				_headMask.parent.removeChild(_headMask);
				_headMask = null;
			}
			_groupData = null;
			super.dispose();
		}
	}
}