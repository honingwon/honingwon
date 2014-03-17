package sszt.scene.socketHandlers.transport
{
	import flash.geom.Point;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.common.UseTransferShoeSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TransportHelpSocketHandler extends BaseSocketHandler
	{
		public function TransportHelpSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRANSPORT_HELP;
		}
		
		override public function handlePackage():void
		{
			var mapId:int = _data.readInt();
			var mapX:int = _data.readInt();
			var mapY:int = _data.readInt();
			var serverId:int = _data.readShort();
			var nick:String = _data.readString();
			if(GlobalData.copyEnterCountList.isInCopy)
			{
				handComplete();
				return;
			}
			if(sceneModule.sceneInfo.mapInfo.isSpaScene()||MapTemplateList.getIsPrison())
			{
				handComplete();
				return;
			}
			if(GlobalData.taskInfo.getTransportTask() != null)
			{
				handComplete();
				return;
			}
			if(MapTemplateList.isAcrossBossMap())
			{
				handComplete();
				return;
			}
//			MTimerAlert.show(10,MAlert.NO,"帮会成员" + nick + "运镖遇到危险向您求救，是否传送过去支援？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,closeHandler);
			MTimerAlert.show(10,MAlert.NO,LanguageManager.getWord("ssztl.scene.cluberTranspertAgainstDanger",nick),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,closeHandler);
			
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					if(!GlobalData.selfPlayer.canfly())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.flyShoeNoEnough"));
						return;
					}
//					sceneModule.facade.sendNotification(SceneMediatorEvent.USE_TRANSFER,{sceneId:mapId,target:new Point(mapX,mapY)});
					doUse();
				}
			}
			function doUse():void
			{
				if(sceneModule.sceneInit.playerListController.getSelf().isSit())
				{
					sceneModule.facade.sendNotification(SceneMediatorEvent.SIT);
				}
				if(sceneModule.sceneInit.playerListController.getSelf().isMoving)
				{
					sceneModule.sceneInit.playerListController.getSelf().stopMoving();
				}
				UseTransferShoeSocketHandler.send(mapId,mapX,mapY);
				
				GlobalData.selfPlayer.scenePath = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathCallback = null;
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRANSPORT_HELP);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}