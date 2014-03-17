package sszt.scene.components.quickIcon
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.data.quickIcon.iconInfo.FriendIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	public class FriendItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		
		private var _friendIfo:FriendIconInfo;
		private var _nameLabel:MAssetLabel;
		private var _isSureLabel:MAssetLabel;
		private var _selected:Boolean;
		private var _sureBtn:MCacheAssetBtn1;
		private var _unSureBtn:MCacheAssetBtn1;
		public var _quickIconMediator:QuickIconMediator;
		public function FriendItemView(info:FriendIconInfo,argMediator:QuickIconMediator)
		{
			_quickIconMediator = argMediator;
			super();
			_friendIfo = info;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
//			this.buttonMode = this.mouseChildren = true;
			
//			graphics.beginFill(0,0);
//			graphics.drawRect(0,0,185,27);
//			graphics.endFill();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(0,0,246,36)),
			]); 
			addChild(_bg as DisplayObject);
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_nameLabel.move(10,11);
			addChild(_nameLabel);
			_nameLabel.setHtmlValue("<a href=\'event:0\'><u>" +_friendIfo.nick+"</u></a> <font color='#fffccc'>请求加好友？</font>"); // [" + _friendIfo.serverId + "]"
			_nameLabel.mouseEnabled = true;
			
			_isSureLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_isSureLabel.move(95,11);
			addChild(_isSureLabel);
//			_isSureLabel.setValue(LanguageManager.getWord("ssztl.scene.ifRequireFriend"));
			
			_sureBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.agree"));
			_sureBtn.move(159,7);
			addChild(_sureBtn);
			
			_unSureBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.refuse"));
			_unSureBtn.move(201,7);
			addChild(_unSureBtn);
			
		}
		
		
	
		
		private function initEvents():void
		{
			_sureBtn.addEventListener(MouseEvent.CLICK,sureAddFriend);
			_unSureBtn.addEventListener(MouseEvent.CLICK,unSureAddFriend);
			_nameLabel.addEventListener(TextEvent.LINK,showdetail);
		}
		
		private function sureAddFriend(evt:MouseEvent):void
		{
			_quickIconMediator.sendFriendAccept(_friendIfo.id,true);
			GlobalData.quickIconInfo.removeFromFriendList(_friendIfo.id);
			GlobalData.quickIconInfo.dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_CHANGE));
		}
		private function showdetail(evt:TextEvent):void
		{
			SetModuleUtils.addRole(_friendIfo.id);
		}
		private function unSureAddFriend(evt:MouseEvent):void
		{
			_quickIconMediator.sendFriendAccept(_friendIfo.id,false);
			GlobalData.quickIconInfo.removeFromFriendList(_friendIfo.id);
			GlobalData.quickIconInfo.dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.FRIEND_ICON_CHANGE));
		}
		
		private function removeEvents():void
		{
			_sureBtn.removeEventListener(MouseEvent.CLICK,sureAddFriend);
			_unSureBtn.removeEventListener(MouseEvent.CLICK,unSureAddFriend);
			_nameLabel.removeEventListener(TextEvent.LINK,showdetail);
		}
		
		private function onClickHandler(evt:MouseEvent):void
		{
			
		}
		
		
		public function get friendIfo():Object
		{
			return _friendIfo;
		}
		
		
		public function dispose():void
		{
			removeEvents();
			_nameLabel = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}