package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ClubModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class ClubWarRequestResponseSocketHandler extends BaseSocketHandler
	{
		public function ClubWarRequestResponseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_WAR_REQUEST_RESPONSE;
		}
		
		override public function handlePackage():void
		{
			ModuleEventDispatcher.dispatchClubEvent(new ClubModuleEvent(ClubModuleEvent.SHOW_CLUB_WAR_REQUEST));
			handComplete();
		}
		
	}
}