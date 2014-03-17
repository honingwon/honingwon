package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.iconInfo.ClubIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class ClubIconBtn extends BaseIconBtn
	{
		private var _clubIconBtn:MBitmapButton;
		public function ClubIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipClub");
		}
		
		override protected function initView():void
		{
			super.initView();
			_clubIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconClubAsset") as BitmapData);
			addChild(_clubIconBtn);
		}
		
		override protected  function btnClickHandler(e:MouseEvent):void
		{
			var tmpClubTopInfo:ClubIconInfo;
			GlobalAPI.tickManager.removeTick(GlobalData.quickIconInfo);
			if(GlobalData.quickIconInfo.clubIconInfoList.length > 0)
			{
				tmpClubTopInfo = GlobalData.quickIconInfo.clubIconInfoList[0];
			}
			else
			{
				return;
			}
			if(GlobalData.clubInviteAlert)
			{
				GlobalData.clubInviteAlert.dispose();
			}
			GlobalData.clubInviteAlert = MTimerAlert.show(15,MAlert.REFUSE,LanguageManager.getWord("ssztl.common.isSureJionClub","[" + tmpClubTopInfo.serverId + "]" + tmpClubTopInfo.nick,tmpClubTopInfo.nick),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE | MAlert.REFUSE,null,closeHandler);
			
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.AGREE)
				{
					_quickIconMediator.sendClubAccept(tmpClubTopInfo.clubId,true);
				}
				else
				{
					_quickIconMediator.sendClubAccept(tmpClubTopInfo.clubId,false);
				}
				GlobalData.clubInviteAlert = null;
				GlobalData.quickIconInfo.removeFromClubIconInfoList(tmpClubTopInfo.clubId);
				GlobalAPI.tickManager.addTick(GlobalData.quickIconInfo);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_clubIconBtn)
			{
				_clubIconBtn.dispose();
				_clubIconBtn = null;
			}
		}
	}
}