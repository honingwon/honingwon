package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	
	public class TradeCancelResponseSocketHandler extends BaseSocketHandler
	{
		public function TradeCancelResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_CANCEL_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			//0主动取消，否则交易失败
			var result:int = _data.readByte();
			sceneModule.sceneInfo.tradeDirectInfo.doCancel(result);
			QuickTips.show(LanguageManager.getWord("ssztl.common.cannelTrade"));
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}