package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class TargetDropItemRemoveSocketHandler extends BaseSocketHandler
	{
		public function TargetDropItemRemoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TARGET_DROPITEM_REMOVE;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.dropItemList.removeItem(_data.readInt());
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}