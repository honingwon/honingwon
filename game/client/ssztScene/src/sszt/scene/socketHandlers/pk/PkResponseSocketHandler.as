package sszt.scene.socketHandlers.pk
{
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	
	public class PkResponseSocketHandler extends BaseSocketHandler
	{
		public function PkResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PK_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			var serverId:int = _data.readShort();
			var id:Number = _data.readNumber();
			var nick:String = _data.readString();
			if(module.pkInviteAlert == null)
			{
				module.pkInviteAlert = MTimerAlert.show(5,MAlert.REFUSE,"[" + serverId + "]" + nick + LanguageManager.getWord("ssztl.scene.surePk"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.AGREE|MAlert.REFUSE,null,alertCloseHandler);
			}
			function alertCloseHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.AGREE)
				{
					if(GlobalData.copyEnterCountList.isInCopy)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.beInCopy"));
						return;
					}
					PkResponseSocketHandler.send(id,true);
					GlobalData.selfPlayer.scenePath = null;
					GlobalData.selfPlayer.scenePathTarget = null;
					GlobalData.selfPlayer.scenePathCallback = null;
					module.sceneInit.playerListController.getSelf().stopMoving();
				}else
				{
					PkResponseSocketHandler.send(id,false);
				}
				module.pkInviteAlert = null;
			}
			handComplete();
		}
		
		private function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(id:Number,value:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PK_RESPONSE);
			pkg.writeNumber(id);
			if(value) pkg.writeInt(1);
			else pkg.writeInt(0);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}