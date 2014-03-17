package sszt.consign.socket
{
	import sszt.consign.ConsignModule;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GoldDealSockectHandler extends BaseSocketHandler
	{
		public function GoldDealSockectHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return	ProtocolType.CONSIGN_YUANBAO_DEAL;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
//				var tmpListId:Number = _data.readNumber();
//				consignModule.goldConsignInfo.removeItem(tmpListId);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.tradeFail"));
			}
			
		}
		
		public static function sendDeal(argListId:Number,argGoldNum:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_YUANBAO_DEAL);
			pkg.writeNumber(argListId);
			pkg.writeInt(argGoldNum);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get consignModule():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
		
	}
}