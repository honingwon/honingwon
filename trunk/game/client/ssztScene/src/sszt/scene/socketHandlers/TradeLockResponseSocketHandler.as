package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class TradeLockResponseSocketHandler extends BaseSocketHandler
	{
		public function TradeLockResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_LOCK_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.tradeDirectInfo.setOtherLock(true);
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}