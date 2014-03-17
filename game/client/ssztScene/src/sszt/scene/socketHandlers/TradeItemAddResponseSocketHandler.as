package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.scene.SceneModule;
	
	public class TradeItemAddResponseSocketHandler extends BaseSocketHandler
	{
		public function TradeItemAddResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_ITEM_ADD_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			var item:ItemInfo = new ItemInfo();
			PackageUtil.readItem(item,_data);
			sceneModule.sceneInfo.tradeDirectInfo.addOtherItem(item);
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}