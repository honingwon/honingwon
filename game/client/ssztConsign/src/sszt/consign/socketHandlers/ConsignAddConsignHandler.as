package sszt.consign.socketHandlers
{
	import sszt.ui.container.MAlert;
	
	import sszt.consign.ConsignModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ConsignAddConsignHandler extends BaseSocketHandler
	{
		public function ConsignAddConsignHandler(handlerData:Object=null)
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
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.consignFail"));
			}
			
			handComplete();
		}
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_ADD;
		}
		
		public static function sendAddConsign(argPlace:int,argPriceType:int,argPrice:int,argTime:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_ADD);
			pkg.writeInt(argPlace);
			pkg.writeInt(argPriceType);
			pkg.writeInt(argPrice);
			pkg.writeInt(argTime);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function getConsignModule():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
	}
}