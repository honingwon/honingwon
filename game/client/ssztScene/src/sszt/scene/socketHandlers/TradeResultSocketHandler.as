package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.SceneModule;
	
	public class TradeResultSocketHandler extends BaseSocketHandler
	{
		public function TradeResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_RESULT;
		}
		
		override public function handlePackage():void
		{
			if(_data.readByte() == 1)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.tradeSuccess"));
				sceneModule.sceneInfo.tradeDirectInfo.doComplete();
			}
			else
			{
				sceneModule.sceneInfo.tradeDirectInfo.doCancel(0);
			}
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}