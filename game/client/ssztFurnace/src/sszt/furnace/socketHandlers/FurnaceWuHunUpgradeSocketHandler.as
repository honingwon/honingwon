package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.FurnaceModule;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceWuHunUpgradeSocketHandler extends BaseSocketHandler
	{
		public function FurnaceWuHunUpgradeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_WUHUN_UPGRADE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			var tmpItemId:Number = _data.readNumber();
			if(result)
			{
				//				QuickTips.show("恭喜！！！武魂升级成功！");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.wuHunUpgradeSuccess"));
			}
			else
			{
				//				QuickTips.show("武魂升级失败!!");
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.wuHunUpgradeFail"));
			}
			furnaceModule.furnaceInfo.putAgainHandler(tmpItemId);
			handComplete();
		}
		
		public static function send(argEquipPlace:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_WUHUN_UPGRADE);
			pkg.writeInt(argEquipPlace);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
		
		
	}
}