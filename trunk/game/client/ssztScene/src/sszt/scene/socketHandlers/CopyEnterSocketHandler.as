package sszt.scene.socketHandlers
{
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.components.copyGroup.sec.CopyCountDownView;
	import sszt.scene.components.copyGroup.sec.CopyTowerCountDownView;
	import sszt.scene.components.duplicate.CountDownPanel;
	import sszt.scene.components.duplicate.HangupCuePanel;
	import sszt.scene.components.pk.PkCountDownAction;
	import sszt.scene.data.duplicate.DuplicateMoneyInfo;
	import sszt.ui.container.MAlert;
	
	public class CopyEnterSocketHandler extends BaseSocketHandler
	{
		public function CopyEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ENTER;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			if(id == -1)
			{
				GlobalAPI.waitingLoading.hide();
			}
			else
			{
				GlobalData.copyEnterCountList.isInCopy = true;
				GlobalData.copyEnterCountList.inCopyId = id;
				setDuplicateInfo(id);
//				var time:int = CopyTemplateList.getCopy(id).countTime;
//				if(time > 0) CopyCountDownView.getInstance().show(time);
				if(GlobalData.copyEnterCountList.isPKCopy())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.readyForWar"));
					GlobalData.copyEnterCountList.pkEnterTime = getTimer();
					PkCountDownAction.getInstance().show();
				}
			}
			if(GlobalData.selfPlayer.level <= 40 && !MapTemplateList.isGuildMap() && !MapTemplateList.isPvPMap())//新手进入副本后挂机提示
			{
				var hangupCuePanel:HangupCuePanel = new HangupCuePanel(null);
				GlobalAPI.layerManager.getPopLayer().addChild(hangupCuePanel);
			}
			if(MapTemplateList.isPvPMap())
			{
				var coutDownPanle:CountDownPanel = new CountDownPanel(sceneModule.sceneMediator);
				GlobalAPI.layerManager.getPopLayer().addChild(coutDownPanle);
			}
			handComplete();
		}
		//进入副本前判断副本类型再处理
		private function setDuplicateInfo(id:int):void
		{
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(id);
			var time:int = copy.countTime;
			
			switch(copy.type)
			{
				case 1:
				case 6:
//					sceneModule.duplicateNormalInfo.setDuplicateInfo(copy);
					break;
				case 3:
					sceneModule.duplicateGuardInfo.setDuplicateInfo();
					break;
				case 4:
					//sceneModule.duplicatePassInfo.setDuplicateInfo(GlobalData.currentMapId);
					//在场景切换的时候被调用说要这里不需要
					break;
				case 7:
					sceneModule.duplicateMonyeInfo.leftTime = time;
					break;
				default:
					//if(time > 0) CopyCountDownView.getInstance().show(time);
					break;
			}
			
		}
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		public static function send(id:int):void
		{
			if(GlobalData.enthralState == 4)
			{
				MAlert.show(LanguageManager.getWord("ssztl.cors.enthralNotice4"),
							LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null,null);
				return;
			}
			GlobalAPI.waitingLoading.showLogin(LanguageManager.getWord("ssztl.scene.waittingForCopy"));
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ENTER);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}