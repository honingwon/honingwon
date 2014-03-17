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
	
	public class FurnaceRemoveSocketHandler extends BaseSocketHandler
	{
		public function FurnaceRemoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_REMOVE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId:Number = _data.readNumber();
			if(result)
			{
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.REMOVE_SUCCESS));
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipRemoveSuccess"));
				
			}
			else
			{
//				QuickTips.show("摘取失败!!");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipRemoveFail"));
			}
			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId);
			handComplete();
		}
		
		public static function sendRemove(argEquipPlace:int,argRemoveBagPlace:int,argStonePlace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_REMOVE);
			pkg.writeInt(argEquipPlace);
			pkg.writeInt(argRemoveBagPlace);
			pkg.writeInt(argStonePlace);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}