package sszt.mounts.socketHandler
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
	
	public class MountsGrowUpdateSocketHandler extends BaseSocketHandler
	{
		public function MountsGrowUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_GROW_UPDATE;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsGrowSuccess"));
				
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551013);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsGrowFail"));
			}
			handComplete();
		}
		
		public static function send(mountsId:Number, useFu:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_GROW_UPDATE);
			pkg.writeNumber(mountsId);
			pkg.writeBoolean(useFu);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}