package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.gift.GetGitAnimation;
	import sszt.scene.components.gift.GiftView;
	
	public class PlayerDairyAwardRemoveSocketHandler extends BaseSocketHandler
	{
		public function PlayerDairyAwardRemoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
//		override public function getCode():int
//		{
//			return ProtocolType.PLAYER_DAILY_AWARD_REMOVE;
//		}
		
		override public function handlePackage():void
		{
			//处理
			GiftView.getInstance().dispose();
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ONLINE_REWARD_PANEL));
			handComplete();
		}
	}
}