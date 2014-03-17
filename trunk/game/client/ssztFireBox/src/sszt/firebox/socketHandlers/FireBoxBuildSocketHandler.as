package sszt.firebox.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.firebox.events.FireBoxModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class FireBoxBuildSocketHandler extends BaseSocketHandler
	{
		public function FireBoxBuildSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_FIRE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.rebuildSuccess"));
				ModuleEventDispatcher.dispatchModuleEvent(new FireBoxModuleEvent(FireBoxModuleEvent.MIN_BTN_UPDATE));
				
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.rebuildFail"));
			}
			
			handComplete();
		}
//		/**argFormularDataId = 配方Id,argType = 1单个合成  2批量合成**/
//		public static function sendFire(argFormularDataId:int,argType:int):void
//		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_FIRE);
//			pkg.writeInt(argFormularDataId);
//			pkg.writeInt(argType);
//			GlobalAPI.socketManager.send(pkg);
//		}		
		/**argFormularDataId = 配方Id*/
		public static function sendFire(argFormularDataId:int, composeNum:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_FIRE);
			pkg.writeInt(argFormularDataId);
			pkg.writeInt(composeNum);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}