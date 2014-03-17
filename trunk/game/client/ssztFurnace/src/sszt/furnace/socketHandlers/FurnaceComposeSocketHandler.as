package sszt.furnace.socketHandlers
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
	import sszt.furnace.FurnaceModule;
	import sszt.furnace.events.FuranceEvent;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceComposeSocketHandler extends BaseSocketHandler
	{
		public function FurnaceComposeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_COMPOSE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.COMPOSE_SUCCESS));
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.composeSuccess"));
				
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551014);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
				
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.composeFail"));
			}
			//请空中间面板
			furnaceModule.furnaceInfo.clearMiddlePanel();
			
			handComplete();
		}
		
//		public static function sendCompose(argProtectBagPlace:int,argStonePlaceVector:Vector.<int>):void
		public static function sendCompose(argStoneId:int, argComposeNum:int, argUseBind:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_COMPOSE);
			pkg.writeInt(argStoneId);
			pkg.writeInt(argComposeNum);
			pkg.writeBoolean(argUseBind);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}