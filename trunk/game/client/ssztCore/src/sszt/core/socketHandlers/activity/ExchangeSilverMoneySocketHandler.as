package sszt.core.socketHandlers.activity
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ExchangeSilverMoneySocketHandler extends BaseSocketHandler
	{
		public function ExchangeSilverMoneySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EXCHANGE_SILVER_MONEY;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.exchangeSilverMoneyState = _data.readByte();
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_EXCHANGE_VIEW));
			handComplete();
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EXCHANGE_SILVER_MONEY);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}