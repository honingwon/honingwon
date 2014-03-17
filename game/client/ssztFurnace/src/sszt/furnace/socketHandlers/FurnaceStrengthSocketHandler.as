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
	
	public class FurnaceStrengthSocketHandler extends BaseSocketHandler
	{
		public function FurnaceStrengthSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_STRENG;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId:Number = _data.readNumber();
			if(result)
			{
//				QuickTips.show("恭喜！！强化成功！！！");
//				QuickTips.show(LanguageManager.getWord("ssztl.furnace.strengthSuccess"));
				furnaceModule.furnaceInfo.strengthFailCount = 0;
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.STRENGTH_SUCCESS));
				
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551002);
				if(taskInfo != null && taskInfo.isExist == true && taskInfo.isFinish == false)
				{
					TaskClientSocketHandler.send(taskInfo.taskId,0);
					GuideTip.getInstance().hide();
				}
				
				
			}
			else
			{
//				QuickTips.show("强化失败!!");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.strengthFail"));
				furnaceModule.furnaceInfo.strengthFailCount++;
			}
			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId);
			
			handComplete();
		}
		
		public static function sendStrength(argEquipPlace:int,argStonePlace:int,argProtectBagPlace:int,aKey:int,petId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_STRENG);
			pkg.writeInt(argEquipPlace);
			pkg.writeInt(argStonePlace);
			pkg.writeInt(argProtectBagPlace);
			pkg.writeByte(aKey);
			pkg.writeNumber(petId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}