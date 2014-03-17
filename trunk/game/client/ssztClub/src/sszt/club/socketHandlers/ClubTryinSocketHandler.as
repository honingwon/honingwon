package sszt.club.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.task.TaskClientSocketHandler;
	import sszt.core.view.tips.GuideTip;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubTryinSocketHandler extends BaseSocketHandler
	{
		public function ClubTryinSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_TRYIN;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(clubId:Number):void
		{
			
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_TRYIN);
			pkg.writeNumber(clubId);
			GlobalAPI.socketManager.send(pkg);
			
			var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551016);
			if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
			{
				TaskClientSocketHandler.send(taskInfo.taskId,0);
				GuideTip.getInstance().hide();
			}
		}
	}
}