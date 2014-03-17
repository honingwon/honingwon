package sszt.consign.socket
{
	import sszt.consign.ConsignModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BillDeleteSocketHandler extends BaseSocketHandler
	{
		public function BillDeleteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
//			return ProtocolType.CONSIGN_BILL_DELETE;
			return 0;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				var tmpListId:Number = _data.readNumber();
				module.goldConsignInfo.removeItem(tmpListId);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.consign.repealFail"));
			}
			
		}
		
		public function get module():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
		
		public static function sendBill(argListId:Number):void
		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_BILL_DELETE);
//			pkg.writeInt(argListId);
//			GlobalAPI.socketManager.send(pkg);
		}
	}
}