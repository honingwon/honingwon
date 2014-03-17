package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	
	public class DefenceListSocketHandler extends BaseSocketHandler
	{
		public function DefenceListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.DEFENCE_LIST;
		}
		
		override public function handlePackage():void
		{
			var exist:Boolean = _data.readBoolean();
			var userId:Number = _data.readNumber();
			if(exist)sceneModule.sceneInfo.attackList.addPlayer(userId);
			else sceneModule.sceneInfo.attackList.removePlayer(userId);
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}