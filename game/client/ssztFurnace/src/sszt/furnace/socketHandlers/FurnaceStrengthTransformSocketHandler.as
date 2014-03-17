package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.FurnaceModule;
	import sszt.furnace.events.FuranceEvent;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceStrengthTransformSocketHandler extends BaseSocketHandler
	{
		public function FurnaceStrengthTransformSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_STRENGTH_TRANSFORM;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId1:Number = _data.readNumber();
			var tmpItemId2:Number = _data.readNumber();
			if(result)
			{
//				QuickTips.show("恭喜！！转移成功！！！");
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.TRANSFORM_SUCCESS));
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipTransferSuccess"));
			}
			else
			{
//				QuickTips.show("转移失败!!");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipTransferFail"));
			}
//			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId2);
//			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId1);
			handComplete();
		}
		
		public static function sendTransform(argEquipPlace1:int,argEquipPlace2:int,opType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_STRENGTH_TRANSFORM);
			pkg.writeInt(opType);
			pkg.writeInt(argEquipPlace1);
			pkg.writeInt(argEquipPlace2);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}