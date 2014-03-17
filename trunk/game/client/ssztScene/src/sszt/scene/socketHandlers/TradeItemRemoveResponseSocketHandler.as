package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class TradeItemRemoveResponseSocketHandler extends BaseSocketHandler
	{
		public function TradeItemRemoveResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_ITEM_REMOVE_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.tradeDirectInfo.removeOtherItem(_data.readNumber());
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}