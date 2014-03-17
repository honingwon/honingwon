package sszt.consign.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ConsignAddYuanBaoHandler extends BaseSocketHandler
	{
		public function ConsignAddYuanBaoHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.consignSuccess"));
			}
//			else
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.consignFail"));
//			}
			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_YUANBAO_ADD;
		}
		
		
		public static function sendAddYuanBaoConsign(coinType:int, count:int, price:int, time:int,isSendChat:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_YUANBAO_ADD);
			pkg.writeInt(coinType);
			pkg.writeInt(count);
			pkg.writeInt(price);
			pkg.writeInt(time);
//			pkg.writeByte(isSendChat);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}