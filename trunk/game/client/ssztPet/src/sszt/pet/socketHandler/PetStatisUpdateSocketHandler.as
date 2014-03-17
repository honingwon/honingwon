package sszt.pet.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.task.TaskClientSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetStatisUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetStatisUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_STAIRS_UPDATE;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551012);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
				
				QuickTips.show(LanguageManager.getWord("ssztl.pet.petStatisSuccess"));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsStatisFail"));
			}
			
			
			handComplete();
		}
		
		public static function send(petId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_STAIRS_UPDATE);
			pkg.writeNumber(petId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}