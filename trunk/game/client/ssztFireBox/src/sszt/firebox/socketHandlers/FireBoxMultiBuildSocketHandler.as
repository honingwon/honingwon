package sszt.firebox.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FireBoxMultiBuildSocketHandler extends BaseSocketHandler
	{
		public function FireBoxMultiBuildSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_MULTI_FIRE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.rebuildSuccess"));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.rebuildFail"));
			}
			
			handComplete();
		}
		
		/**argFormularDataId = 配方Id*/
		public static function sendMultiFire(argFormularDataId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_MULTI_FIRE);
			pkg.writeInt(argFormularDataId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}