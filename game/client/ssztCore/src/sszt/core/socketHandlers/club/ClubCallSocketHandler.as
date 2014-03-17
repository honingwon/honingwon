package sszt.core.socketHandlers.club
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
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ClubCallSocketHandler extends BaseSocketHandler
	{
		public function ClubCallSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_CALL;
		}
		
		override public function handlePackage():void
		{
			var mapId:int = _data.readInt();
			var posX:int = _data.readInt();
			var poxY:int = _data.readInt();
			var nick:String = _data.readString();
			if(GlobalData.copyEnterCountList.isInCopy||GlobalData.taskInfo.getTransportTask() != null||MapTemplateList.getIsInSpaMap() ||
				MapTemplateList.getIsInVipMap()||MapTemplateList.isShenMoMap() || MapTemplateList.isAcrossBossMap()||MapTemplateList.getIsPrison())
			{
				return;
			}
			MTimerAlert.show(10,MAlert.NO, LanguageManager.getWord("ssztl.common.clubLeaderCall"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,closeHandler);
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					if(!GlobalData.selfPlayer.canfly())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.flyShoeNoEnough"));
						return;
					}
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:mapId,target:new Point(posX,poxY)}));
				}
			}
			handComplete(); 
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_CALL);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}