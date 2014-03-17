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
	
	public class ConsignBuyHandler extends BaseSocketHandler
	{
		public function ConsignBuyHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			
			var result:int = _data.readByte();
			var listId:Number = _data.readNumber();
			switch(result)
			{
				case 0: 
					QuickTips.show(LanguageManager.getWord("ssztl.common.buyFail"));
					break;
				case 1: 
					QuickTips.show(LanguageManager.getWord("ssztl.common.buySuccess"));
					consignModule.consignInfo.removeFromSearchItemList(listId);
					break;
					break;
				case 2: 
					QuickTips.show(LanguageManager.getWord("ssztl.common.bagFull"));
					break;
				case 3: 
					QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnough"));
					break;
				case 4: 
					QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
					break;
				case 5: 
					QuickTips.show(LanguageManager.getWord("ssztl.consign.consignItemUnExsit"));
					break;
				case 6: 
					QuickTips.show(LanguageManager.getWord("ssztl.consign.itemDataError"));
					break;
				case 7: 
					QuickTips.show(LanguageManager.getWord("ssztl.consign.buySelfConsign"));
					break;
			}
			
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONSIGN_BUY;
		}
		
		public static function sendBuy(argListId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONSIGN_BUY);
			pkg.writeNumber(argListId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get consignModule():ConsignModule
		{
			return _handlerData as ConsignModule;
		}
			
	}
}