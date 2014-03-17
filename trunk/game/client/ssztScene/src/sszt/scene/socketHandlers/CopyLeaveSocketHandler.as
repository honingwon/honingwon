package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.components.copyGroup.sec.CopyCountDownView;
	import sszt.scene.components.copyGroup.sec.CopyTowerCountDownView;
	import sszt.ui.container.MAlert;
	
	public class CopyLeaveSocketHandler extends BaseSocketHandler
	{
		public function CopyLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
		 	return ProtocolType.COPY_LEAVE;	
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt(); //副id
			
			if(GlobalData.copyEnterCountList.isPKCopy()) GlobalData.selfPlayer.pkState = 0;
			GlobalData.copyEnterCountList.isInCopy = false;
			GlobalData.copyEnterCountList.inCopyId = 0;
//			CopyCountDownView.getInstance().dispose();
			CopyTowerCountDownView.getInstance().dispose();
			
			GlobalData.selfPlayer.scenePath = null;
			GlobalData.selfPlayer.scenePathTarget = null;
			GlobalData.selfPlayer.scenePathCallback = null;
			if(sceneModule.sceneInit.playerListController.getSelf())sceneModule.sceneInit.playerListController.getSelf().stopMoving();			
			var mission:int = _data.readShort();
			var awardNum:int = _data.readShort();
			var copper:int, yuanbao:int, exp:int, lilian:int;
			for(var i:int = 0; i < awardNum; i++)
			{
				var type:int = _data.readInt();
				if(type == 4)
					copper = _data.readInt();
				if(type == 2)
					yuanbao = _data.readInt();
				if(type == 5)
					exp = _data.readInt();
				if(type == 6)
					lilian = _data.readInt();
			}
			if(id == 1000000)
			{
				sceneModule.duplicateNormalInfo.closeCountDown();
				GlobalData.pvpInfo.user_pvp_state = 0;
				SetModuleUtils.addPVP1();
			}
			if(MapTemplateList.isMoneyDuplicate(id))
				MAlert.show(LanguageManager.getWord("ssztl.scene.copyQuitInfo",mission,copper,yuanbao),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null);
			else if(MapTemplateList.isPassDuplicate(id))
				MAlert.show(LanguageManager.getWord("ssztl.scene.copyQuitInfo2",mission,exp,lilian),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null);
			else if(MapTemplateList.isGuardDuplicate(id))
				MAlert.show(LanguageManager.getWord("ssztl.scene.copyQuitInfo3",mission,exp,copper),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null);
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_LEAVE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}