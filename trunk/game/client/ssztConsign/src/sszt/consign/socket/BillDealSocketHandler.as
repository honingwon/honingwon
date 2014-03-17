package sszt.consign.socket
{
	import sszt.consign.ConsignModule;
	import sszt.consign.data.GoldConsignItem;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BillDealSocketHandler extends BaseSocketHandler
	{
		public function BillDealSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_MY_YUANBAO_DEAL;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
//				var tmpConsignItemInfo:GoldConsignItem = new GoldConsignItem(_data.readNumber(),_data.readInt(),_data.readInt(),_data.readInt());
//				module.goldConsignInfo.addItem(tmpConsignItemInfo);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.consignFail"));
			}
		}
		
		public function get module():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
		
		public static function sendBillDeal(argNum:int,argPrice:int,argType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_MY_YUANBAO_DEAL);
			pkg.writeInt(argNum);
			pkg.writeInt(argPrice);
			pkg.writeInt(argType);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}