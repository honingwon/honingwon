package sszt.friends.component
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.GroupItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.im.FriendGroupDeleteSocketHandler;
	import sszt.core.socketHandlers.im.FriendGroupMoveSocketHandler;
	import sszt.core.socketHandlers.im.FriendGroupUpdateSocketHandler;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class GroupSetupPanel extends Sprite
	{
		public static const PARENT_CLOSE:String = "parent dispose";
		private var addBtn:MCacheAsset3Btn;
		private var deleteBtn:MCacheAsset3Btn;
		private var reNameBtn:MCacheAsset3Btn;
		private var _bg:IMovieWrapper;
		private var addNameText:TextField;
		private var reNameText:TextField;
		private var testBtn:MCacheAsset3Btn;
		private var deleteChoseCombox:ComboBox;
		private var reNamechoseCombox:ComboBox;
		private var closeBtn:MCacheAsset1Btn;
		
		public function GroupSetupPanel()
		{
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(1,87,298,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(67,17,176,22)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(67,143,176,22)),
				]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,0,56,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.addGroup"),MAssetLabel.LABELTYPE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,19,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.inputName"),MAssetLabel.LABELTYPE1)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,42,56,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.deleteGroup"),MAssetLabel.LABELTYPE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,62,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.selectGroup"),MAssetLabel.LABELTYPE1)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,96,69,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.renameGroup"),MAssetLabel.LABELTYPE2)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,119,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.selectGroup"),MAssetLabel.LABELTYPE1)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,145,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.inputName"),MAssetLabel.LABELTYPE1)));
			
			
			addNameText = new TextField();
			addNameText.textColor = 0xffffff;
			addNameText.x = 67;
			addNameText.y = 18;
			addNameText.width = 178;
			addNameText.height = 19;
			addNameText.type = TextFieldType.INPUT;
			addChild(addNameText);
						
			deleteChoseCombox = new ComboBox();
			deleteChoseCombox.move(66,60);
			deleteChoseCombox.setSize(178,20);
			deleteChoseCombox.enabled = true;
			addChild(deleteChoseCombox);
			
			reNamechoseCombox = new ComboBox();
			reNamechoseCombox.move(66,117);
			reNamechoseCombox.setSize(178,20);
			reNamechoseCombox.enabled = true;
			addChild(reNamechoseCombox);
			
			var tempData:Array = new Array();
			for(var i:int =0;i<GlobalData.imPlayList.groups.length;i++)
			{
				tempData.push({label:GlobalData.imPlayList.groups[i].gName,value:GlobalData.imPlayList.groups[i].gId});
			}
			deleteChoseCombox.dataProvider = new DataProvider(tempData);
			reNamechoseCombox.dataProvider = new DataProvider(tempData);
			
			reNameText = new TextField();
			reNameText.textColor = 0xffffff;
			reNameText.x = 66;
			reNameText.y = 143;
			reNameText.width = 178;
			reNameText.height = 19;
			reNameText.type = TextFieldType.INPUT;
			addChild(reNameText);
			
			addBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.add"));
			addBtn.move(247,15);
			addChild(addBtn);
			
			deleteBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.delete"));
			deleteBtn.move(247,58);
			addChild(deleteBtn);
			
			reNameBtn = new MCacheAsset3Btn(0,LanguageManager.getWord("ssztl.common.sure"));
			reNameBtn.move(247,141);
			addChild(reNameBtn);
			
			closeBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.close"));
			closeBtn.move(112,172);
			addChild(closeBtn);
		}
		
		private function initEvent():void
		{
			addBtn.addEventListener(MouseEvent.CLICK,addClickHandler);
			deleteBtn.addEventListener(MouseEvent.CLICK,deleteClickHandler);
			reNameBtn.addEventListener(MouseEvent.CLICK,reNameClickHandler);
			closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.ADD_GROUP,groupChangeHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.DELETE_GROUP,groupChangeHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.GROUP_RENAME,groupChangeHandler);
		}
		
		private function removeEvent():void
		{
			addBtn.removeEventListener(MouseEvent.CLICK,addClickHandler);
			deleteBtn.removeEventListener(MouseEvent.CLICK,deleteClickHandler);
			reNameBtn.removeEventListener(MouseEvent.CLICK,reNameClickHandler);
			closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.ADD_GROUP,groupChangeHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.DELETE_GROUP,groupChangeHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.GROUP_RENAME,groupChangeHandler);
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			dispatchEvent(new Event(PARENT_CLOSE));
		}
		
		private function groupChangeHandler(evt:FriendEvent):void
		{
			var tempData:Array = new Array();
			for(var i:int =0;i<GlobalData.imPlayList.groups.length;i++)
			{
				tempData.push({label:GlobalData.imPlayList.groups[i].gName,value:GlobalData.imPlayList.groups[i].gId});
			}
			deleteChoseCombox.dataProvider = new DataProvider(tempData);
			reNamechoseCombox.dataProvider = new DataProvider(tempData);
		}
				
		private function addClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(GlobalData.imPlayList.groups.length>=10)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.addGroupFail"));
				return ;
			}
			if(addNameText.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.inputGroupName"));
				return ;
			}
			if(GlobalData.imPlayList.hasGroup(addNameText.text))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.groupExsited"));
				return ;
			}
			if(!WordFilterUtils.checkNameAllow(addNameText.text))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.hasIllegalcharacters"));
				return;
			}
			FriendGroupUpdateSocketHandler.sendUpate(0,addNameText.text);
		}
		
		private function deleteClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(deleteChoseCombox.selectedItem)
			{
				if(GlobalData.imPlayList.canDeleteGroup(deleteChoseCombox.selectedItem.value))
				{
					FriendGroupDeleteSocketHandler.sendDelete(deleteChoseCombox.selectedItem.value);
				}else
				{
					QuickTips.show(LanguageManager.getWord("ssztl.friends.cleanBeforeDelete"));
				}
			}
		}
		
		private function reNameClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(reNameText.text == "")
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.inputGroupName"));
				return ;
			}
			if(GlobalData.imPlayList.hasGroup(reNameText.text))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.groupExsited"));
				return ;
			}
			if(!WordFilterUtils.checkNameAllow(reNameText.text))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.hasIllegalcharacters"));
				return;
			}
			if(reNamechoseCombox.selectedItem)
			{
				FriendGroupUpdateSocketHandler.sendUpate(reNamechoseCombox.selectedItem.value,reNameText.text);
			}
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(addBtn)
			{
				addBtn.dispose();
				addBtn = null;
			}
			if(deleteBtn)
			{
				deleteBtn.dispose();
				deleteBtn = null;
			}
			if(reNameBtn)
			{
				reNameBtn.dispose();
				reNameBtn = null;
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			deleteChoseCombox = null;
			reNamechoseCombox = null;
			addNameText = null;
			reNameText = null;
			if(testBtn)
			{
				testBtn.dispose();
				testBtn = null;
			}
			if(closeBtn)
			{
				closeBtn.dispose();
				closeBtn = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}