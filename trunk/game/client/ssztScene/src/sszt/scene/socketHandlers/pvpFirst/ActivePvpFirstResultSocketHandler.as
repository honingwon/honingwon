package sszt.scene.socketHandlers.pvpFirst
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class ActivePvpFirstResultSocketHandler extends BaseSocketHandler
	{
		public function ActivePvpFirstResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_PVP_FIRST_RESULT;
		}
		
		override public function handlePackage():void
		{			
			var id1:int = _data.readInt();
			var id2:int = _data.readInt();
			module.pvpFirstInfo.showResultPanel(id1,id2);
			handComplete();
		}
		
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}