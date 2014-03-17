package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class CopyPickUpMoneySocketHandler extends BaseSocketHandler
	{
		public function CopyPickUpMoneySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_PICKUP_MONEY_AMOUNT;
		}
		
		override public function handlePackage():void
		{
			sceneModule.duplicateMonyeInfo.updatePickUpMoney(_data.readInt(), _data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}



