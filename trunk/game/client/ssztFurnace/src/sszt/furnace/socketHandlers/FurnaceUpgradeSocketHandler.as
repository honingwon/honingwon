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
	
	public class FurnaceUpgradeSocketHandler extends BaseSocketHandler
	{
		public function FurnaceUpgradeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_UPGRADE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551005);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
				
				
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.UPGRADE_SUCCESS));
//				QuickTips.show("恭喜！！！神佑成功！");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipUpgradeSuccess"));
			}
			else
			{
//				QuickTips.show("神佑失败!!");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipUpgradeFail"));
			}
			handComplete();
		}
		
		public static function send(petId:Number,argEquipPlace1:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_UPGRADE);
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