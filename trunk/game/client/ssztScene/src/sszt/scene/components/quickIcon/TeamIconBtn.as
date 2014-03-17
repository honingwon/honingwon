package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.iconInfo.TeamIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class TeamIconBtn extends BaseIconBtn
	{
		private var _teamIconBtn:MBitmapButton;
		public function TeamIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipTeam");
		}
		
		override protected function initView():void
		{
			super.initView();
			_teamIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconTeamAsset") as BitmapData);
			addChild(_teamIconBtn);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			var tmpTeamTopInfo:TeamIconInfo;
			GlobalAPI.tickManager.removeTick(GlobalData.quickIconInfo);
			if(GlobalData.quickIconInfo.teamIconInfoList.length > 0)
			{
				tmpTeamTopInfo = GlobalData.quickIconInfo.teamIconInfoList[0];
			}
			else
			{
				return;
			}
			if(!_quickIconMediator.sceneInfo.playerList.self)return;
			//			if(PlayerHangupType.inHangup(_quickIconMediator.sceneInfo.playerList.self.hangupState) && _quickIconMediator.sceneInfo.hangupData.autoGroup)
			if(_quickIconMediator.sceneInfo.playerList.self.getIsHangup() && _quickIconMediator.sceneInfo.hangupData.autoGroup)
			{
				if(_quickIconMediator.sceneInfo.hangupData.isAccept)
				{
					_quickIconMediator.sendTeamAccept(tmpTeamTopInfo.id,true);
					GlobalData.quickIconInfo.removeTeamIconInfoList();
				}else
				{
					_quickIconMediator.sendTeamAccept(tmpTeamTopInfo.id,false);
					GlobalData.quickIconInfo.removeFromTeamIconInfoList(tmpTeamTopInfo.id);
				}
			}else
			{
				var message:String;
				if(_quickIconMediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
				{
					message = LanguageManager.getWord("ssztl.scene.acceptRequireTeam");
				}else
				{
					message = LanguageManager.getWord("ssztl.scene.acceptInviteTeam");;
				}
				
				if(_quickIconMediator.sceneModule.groupAlert)
				{
					_quickIconMediator.sceneModule.groupAlert.dispose();
					_quickIconMediator.sceneModule.groupAlert = MTimerAlert.show(15,MAlert.REFUSE,"[" + tmpTeamTopInfo.serverId + "]" + tmpTeamTopInfo.nick  + message,LanguageManager.getAlertTitle(),MAlert.AGREE | MAlert.REFUSE,null,closeHandler);
				}else
				{
					_quickIconMediator.sceneModule.groupAlert = MTimerAlert.show(15,MAlert.REFUSE,"[" + tmpTeamTopInfo.serverId + "]" + tmpTeamTopInfo.nick  + message,LanguageManager.getAlertTitle(),MAlert.AGREE | MAlert.REFUSE,null,closeHandler);
				}
				function closeHandler(evt:CloseEvent):void
				{
					_quickIconMediator.sceneModule.groupAlert = null;
					if(evt.detail == MAlert.AGREE)
					{
						_quickIconMediator.sendTeamAccept(tmpTeamTopInfo.id,true);
						GlobalData.quickIconInfo.removeTeamIconInfoList();
					}
					else
					{
						_quickIconMediator.sendTeamAccept(tmpTeamTopInfo.id,false);
						GlobalData.quickIconInfo.removeFromTeamIconInfoList(tmpTeamTopInfo.id);
					}					
					GlobalAPI.tickManager.addTick(GlobalData.quickIconInfo);
				}
			}
		}
		
		override public function dispose():void
		{			
			if(_teamIconBtn)
			{
				_teamIconBtn.dispose();
				_teamIconBtn = null;
			}
			super.dispose();
		}
	}
}