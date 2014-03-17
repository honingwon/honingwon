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
	
	public class FurnaceRebuildSocketHandler extends BaseSocketHandler
	{
		public function FurnaceRebuildSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_REBUILD;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId:Number = _data.readNumber();
			if(result)
			{
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.REBUILD_SUCCESS));
				furnaceModule.furnaceInfo.putAgainHandler(tmpItemId);
				
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551006);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
				
//				QuickTips.show("恭喜！！洗练成功！！！");
//				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipRebuildSuccess"));
			}
			else
			{
//				QuickTips.show("洗练失败了！！");	
//				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipRebuildFail"));
			}
			
			handComplete();
		}
		
	    public static function sendRebuild(petId:Number,argEquipPlace:int,argStonePlace:int,lockList:Array,argLuckBagPlace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_REBUILD);
			pkg.writeNumber(petId);
			pkg.writeInt(argEquipPlace);
			pkg.writeInt(argStonePlace);
			var length:int = lockList.length;
			pkg.writeShort(length);
			for each(var i:int in lockList)
			{
				pkg.writeInt(i);
			}
			pkg.writeInt(argLuckBagPlace);
			GlobalAPI.socketManager.send(pkg);
		}
//		public static function sendReplace(argEquipPlace:int):void
//		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_REPLACE_REBUILD);
//			pkg.writeInt(argEquipPlace);
//			GlobalAPI.socketManager.send(pkg);
//		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}