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
	import sszt.ui.container.MAlert;
	
	public class FurnaceEnchaseSocketHandler extends BaseSocketHandler
	{
		public function FurnaceEnchaseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_ENCHASE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId:Number = _data.readNumber();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.enchaseSuccess"));
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.ENCHASE_SUCCESS));
				
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551015);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
				
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.enchaseFail"));
			}
			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId);
			
			handComplete();
		}
		
		public static function sendEnchase(equipPlace:int,stonePlace:int,enchasePlace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_ENCHASE);
			pkg.writeInt(equipPlace);
			pkg.writeInt(stonePlace);
			pkg.writeInt(enchasePlace);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}