package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class PlayerActiveNumSocketHandler extends BaseSocketHandler
	{
		public function PlayerActiveNumSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.activeNum = _data.readShort();
			GlobalData.selfPlayer.activeRewardCanGet = _data.readBoolean();
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.UPDATE_ACTIVE_INFO));
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ACTIVE_NUM;
		}
	}
}