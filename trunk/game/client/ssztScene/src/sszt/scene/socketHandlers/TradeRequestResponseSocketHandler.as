package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.quickIcon.iconInfo.TradeIconInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TradeRequestResponseSocketHandler extends BaseSocketHandler
	{
		public function TradeRequestResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_REQUEST_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			GlobalData.quickIconInfo.addToTradeList(new TradeIconInfo(_data.readNumber(),_data.readString()));
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}