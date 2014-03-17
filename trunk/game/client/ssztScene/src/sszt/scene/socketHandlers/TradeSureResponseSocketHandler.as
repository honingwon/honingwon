package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class TradeSureResponseSocketHandler extends BaseSocketHandler
	{
		public function TradeSureResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_SURE_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.tradeDirectInfo.setOtherSure(true);
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}