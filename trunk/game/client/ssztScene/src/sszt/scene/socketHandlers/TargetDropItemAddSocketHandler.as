package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.data.dropItem.DropItemInfo;
	
	public class TargetDropItemAddSocketHandler extends BaseSocketHandler
	{
		public function TargetDropItemAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TARGET_DROPITEM_ADD;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var item:DropItemInfo = new DropItemInfo();
				item.id = _data.readInt();
				item.templateId = _data.readInt();
				item.dropOwnerId = _data.readNumber();
				item.setScenePos(_data.readInt(),_data.readInt());
				item.state = _data.readByte();
				sceneModule.sceneInfo.dropItemList.addItem(item);
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}