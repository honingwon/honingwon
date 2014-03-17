package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class TradeAcceptResponseSocketHandler extends BaseSocketHandler
	{
		public function TradeAcceptResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TRADE_ACCEPT_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
//			s >> c:
//			int:1 通知对方同意交易请求
//				1 => 同意且成功
			var result:int = _data.readByte();
			var id:int = 0;
			
			switch(result)
			{
				case 1:
					id = _data.readNumber();  //接受方玩家id
					(_handlerData as SceneModule).facade.sendNotification(SceneMediatorEvent.SHOW_TRADEDIRECT,{id:id,nick:_data.readString()}); //打开交易面板
					SetModuleUtils.addBag(); //打开背包面板
					break;
			}
			
			handComplete();
		}
		
	}
}