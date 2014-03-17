package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class TradeRequestSocketHandler extends BaseSocketHandler
	{
		public function TradeRequestSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_REQUEST;
		}
		
		override public function handlePackage():void
		{
			//1:成功，0：失败
			var result:int = _data.readByte();
			if(result == 1)
			{
				
			}
			else if(result == 3)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.selfPackageFull"));
			}
			else if(result == 4)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.otherPackageFull"));
			}
			handComplete();
		}
		
		public static function sendTrade(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRADE_REQUEST);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}