package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.tradeDirect.TradeDirectInfo;
	
	public class TradeCopperSocketHandler extends BaseSocketHandler
	{
		public function TradeCopperSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_COPPER;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.tradeDirectInfo.setOtherCopper(_data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function sendCopper(copper:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRADE_COPPER);
			pkg.writeInt(copper);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}