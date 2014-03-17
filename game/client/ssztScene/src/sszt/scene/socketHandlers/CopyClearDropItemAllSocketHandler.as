package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class CopyClearDropItemAllSocketHandler extends BaseSocketHandler
	{
		public function CopyClearDropItemAllSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_CLEAR_DROPITEM_ALL;
		}
		
		override public function handlePackage():void
		{
			sceneModule.sceneInfo.dropItemList.removeItemAll();
			sceneModule.duplicateMonyeInfo.updateComboTickState();
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}
	
	

