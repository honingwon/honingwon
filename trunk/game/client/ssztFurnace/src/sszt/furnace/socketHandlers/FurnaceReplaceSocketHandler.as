package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.FurnaceModule;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceReplaceSocketHandler extends BaseSocketHandler
	{
		public function FurnaceReplaceSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_REPLACE_REBUILD;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId:Number = _data.readNumber();
//			if(result)
//			{
//				QuickTips.show("恭喜！！洗练成功！！！");
//				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipRebuildSuccess"));
//			}
//			else
//			{
//				QuickTips.show("洗练失败了！！");	
//				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipRebuildFail"));
//			}
			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId);
			handComplete();
		}
			   
		public static function sendReplace(petId:Number,argEquipPlace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_REPLACE_REBUILD);
			pkg.writeNumber(petId);
			pkg.writeInt(argEquipPlace);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}