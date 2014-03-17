package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class CopyUpdateBatterNumSocketHandler extends BaseSocketHandler
	{
		public function CopyUpdateBatterNumSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_UPDATE_BATTER_NUM;
		}
		
		override public function handlePackage():void
		{
//			trace(_data.readInt());
			sceneModule.duplicateMonyeInfo.updataComboBatter(_data.readInt(),_data.readInt(),_data.readInt());
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}