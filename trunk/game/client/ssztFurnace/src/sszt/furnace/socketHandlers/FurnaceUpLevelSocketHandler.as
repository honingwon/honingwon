package sszt.furnace.socketHandlers
{
	import sszt.constData.CategoryType;
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
	
	public class FurnaceUpLevelSocketHandler extends BaseSocketHandler
	{
		public function FurnaceUpLevelSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_UPLEVEL;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.UPLEVEL_SUCCESS));
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.upgradeSuccess"));
				
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(CategoryType.FIRST_ITEM_UPLEVEL);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
				
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.upgradeFail"));
			}
			handComplete();
		}
		
		public static function send(petId:Number,argEquipPlace1:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_UPLEVEL);
			pkg.writeNumber(petId);
			pkg.writeInt(argEquipPlace1);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}