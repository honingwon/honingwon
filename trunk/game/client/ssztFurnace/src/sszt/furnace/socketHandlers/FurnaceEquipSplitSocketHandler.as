package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceEquipSplitSocketHandler extends BaseSocketHandler
	{
		public function FurnaceEquipSplitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_EQUIP_SPLIT;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipSplitSuccess"));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.equipSplitFail"));
			}
			
			handComplete();
		}
		
		public static function sendEquipSplit(argEquipPlace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_EQUIP_SPLIT);
			pkg.writeInt(argEquipPlace);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}