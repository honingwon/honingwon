package sszt.common.wareHouse.socket
{
	import sszt.common.wareHouse.WareHouseModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WareHouseBankSocketHandler extends BaseSocketHandler
	{
		public function WareHouseBankSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BANK_UPDATE;
		}
		
		public function get wareHouseModule():WareHouseModule
		{
			return _handlerData as WareHouseModule;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.getStoreMoneySuccess"));
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.getStoreMoneyFail"));
			}
			
			handComplete();
		}
		
		/**
		 * 
		 * @param type 0是存款 ，1是取款
		 * @param copper 金额
		 * 
		 */		
		public static function sendBank(type:int,copper:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BANK_UPDATE);
			pkg.writeInt(type);
			pkg.writeInt(copper);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}