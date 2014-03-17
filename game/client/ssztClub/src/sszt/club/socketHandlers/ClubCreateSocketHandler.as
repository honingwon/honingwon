package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.events.ClubMediatorEvent;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.module.changeInfos.ToClubData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.task.TaskClientSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubCreateSocketHandler extends BaseSocketHandler
	{
		public function ClubCreateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_CREATE;
		}
		
		override public function handlePackage():void
		{
			//创建成功,返回人物身上需要的数据,跟加入帮会成功返回一样
			GlobalData.selfPlayer.clubId = _data.readNumber();
			GlobalData.selfPlayer.camp = _data.readByte();
			GlobalData.selfPlayer.clubDuty = _data.readByte();
			GlobalData.selfPlayer.clubName = _data.readString();
			GlobalData.selfPlayer.clubLevel = 1;
			GlobalData.taskInfo.updateJoinClubTask();
			
			clubModule.clubId = GlobalData.selfPlayer.clubId;
//			clubModule.clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBMAIN,GlobalData.selfPlayer.clubId);
			clubModule.clubFacade.sendNotification(ClubMediatorEvent.SHOW_CLUBMAIN,new ToClubData(3,GlobalData.selfPlayer.clubId));
			
			handComplete();
		}
		
		public static function send(name:String,declear:String,type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_CREATE);
			pkg.writeInt(type);
			pkg.writeString(name);
			pkg.writeString(declear);
			GlobalAPI.socketManager.send(pkg);
			
			var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551016);
			if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
			{
				TaskClientSocketHandler.send(taskInfo.taskId,0);
				GuideTip.getInstance().hide();
			}
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
	}
}