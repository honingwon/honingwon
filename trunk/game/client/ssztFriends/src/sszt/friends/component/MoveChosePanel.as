package sszt.friends.component
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.GroupType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.im.FriendGroupMoveSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class MoveChosePanel extends MPanel
	{
		private var _mediator:FriendsMediator;
		private var _bg:IMovieWrapper;
		private var _okBtn:MCacheAsset1Btn;
		private var _cancel:MCacheAsset1Btn;
		private var _combox:ComboBox;
		private var _userId:Number;
		private var _gid:Number;
		
		public function MoveChosePanel(mediator:FriendsMediator,gid:Number,id:Number)
		{
			_mediator = mediator;
			_gid = gid;
			_userId = id;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.friends.friendGroupMove")),true,-1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(283,144);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,283,107)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,45,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.friends.selectGroup"),MAssetLabel.LABELTYPE1))
			]);
			addContent(_bg as DisplayObject);
			
			_okBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(17,116);
			addContent(_okBtn);
			
			_cancel = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.cannel"));
			_cancel.move(194,116);
			addContent(_cancel);
			
			_combox = new ComboBox();
			_combox.setSize(176,22);
			_combox.move(84,42);
			addContent(_combox);
			
			var tempData:Array = new Array();
			tempData.push({label:LanguageManager.getWord("ssztl.common.myFriends"),value:GroupType.FRIEND});
			for(var i:int =0;i<GlobalData.imPlayList.groups.length;i++)
			{
				tempData.push({label:GlobalData.imPlayList.groups[i].gName,value:GlobalData.imPlayList.groups[i].gId});
			}
			_combox.dataProvider = new DataProvider(tempData);
			
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,okBtnClickHandler);
			_cancel.addEventListener(MouseEvent.CLICK,cancelBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,okBtnClickHandler);
			_cancel.removeEventListener(MouseEvent.CLICK,cancelBtnClickHandler);
		}
		
		private function okBtnClickHandler(evt:MouseEvent):void
		{
			if(_gid == _combox.selectedItem.value)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.friends.selectSameGroup"));
				return ;
			}
			FriendGroupMoveSocketHandler.sendMove(_gid,_combox.selectedItem.value,_userId);
			dispose();
		}
		
		private function cancelBtnClickHandler(evt:MouseEvent):void
		{
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
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_cancel)
			{
				_cancel.dispose();
				_cancel = null;
			}
			_combox = null;	
			super.dispose();
		}
		
	}
}