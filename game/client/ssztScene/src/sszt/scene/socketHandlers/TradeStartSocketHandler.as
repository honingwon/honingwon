package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TradeStartSocketHandler extends BaseSocketHandler
	{
		public function TradeStartSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_START;
		}
		
		override public function handlePackage():void
		{
//			sceneModule.facade.sendNotification(SceneMediatorEvent.SHOW_TRADEDIRECT,{id:_data.readNumber(),nick:_data.readString(),serverId:_data.readShort()});
			sceneModule.facade.sendNotification(SceneMediatorEvent.SHOW_TRADEDIRECT,{id:_data.readNumber(),nick:_data.readString()});
			SetModuleUtils.addBag(); //打开背包面板
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}