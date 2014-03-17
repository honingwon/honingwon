package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.dropItem.DropItemInfo;
	
	public class TargetDropItemUpdateSocketHandler extends BaseSocketHandler
	{
		public function TargetDropItemUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TARGET_DROPITEM_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var item:DropItemInfo = sceneModule.sceneInfo.dropItemList.getItem(_data.readInt());
			if(item)
				item.state = _data.readByte();
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}