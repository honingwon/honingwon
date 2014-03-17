package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.iconInfo.FriendIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class FriendIconBtn extends BaseIconBtn
	{
		private var _friendIconBtn:MBitmapButton;
		public function FriendIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipFriend");
		}
		
		override protected function initView():void
		{
			super.initView();
			
			_friendIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconFriendAsset") as BitmapData);
			addChild(_friendIconBtn);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			if(AddFriendPanel.getInstance().parent) return;
			var tmpFriendTopInfo:FriendIconInfo;
			GlobalAPI.tickManager.removeTick(GlobalData.quickIconInfo);
			if(GlobalData.quickIconInfo.friendIconInfoList.length > 0)
			{
				tmpFriendTopInfo = GlobalData.quickIconInfo.friendIconInfoList[0];
				
			}
			else
			{
				return;
			}
			
			AddFriendPanel.getInstance().show(_quickIconMediator);
			/**
			if(GlobalData.friendAlert)
			{
				GlobalData.friendAlert.dispose();
				GlobalData.friendAlert = MTimerAlert.show(60,MAlert.REFUSE,"[" + tmpFriendTopInfo.serverId + "]" + tmpFriendTopInfo.nick  + LanguageManager.getWord("ssztl.scene.requireFriend") ,LanguageManager.getWord("ssztl.common.alert"),MAlert.AGREE | MAlert.CHECK | MAlert.REFUSE,null,closeHandler);
			}else
			{
				GlobalData.friendAlert = MTimerAlert.show(60,MAlert.REFUSE,"[" + tmpFriendTopInfo.serverId + "]" + tmpFriendTopInfo.nick  + LanguageManager.getWord("ssztl.scene.requireFriend") ,LanguageManager.getWord("ssztl.common.alert"),MAlert.AGREE | MAlert.CHECK | MAlert.REFUSE,null,closeHandler);
			}
			
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.AGREE)
				{
					_quickIconMediator.sendFriendAccept(tmpFriendTopInfo.id,true);
					GlobalData.friendAlert = null;
					GlobalData.quickIconInfo.removeFromFriendList(tmpFriendTopInfo.id);
				}
				else if(evt.detail == MAlert.REFUSE)
				{
					_quickIconMediator.sendFriendAccept(tmpFriendTopInfo.id,false);
					GlobalData.friendAlert = null;
					GlobalData.quickIconInfo.removeFromFriendList(tmpFriendTopInfo.id);
				}else if(evt.detail == MAlert.CHECK)
				{
					GlobalData.friendAlert.dispose();
					GlobalData.friendAlert = null;
					AddFriendPanel.getInstance().show(_quickIconMediator);
//					SetModuleUtils.addRole(tmpFriendTopInfo.id);
				}
			
				GlobalAPI.tickManager.addTick(GlobalData.quickIconInfo);
			}
			**/
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_friendIconBtn)
			{
				_friendIconBtn.dispose();
				_friendIconBtn = null;
			}
		}
	}
}