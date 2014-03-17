package sszt.core.socketHandlers.petPVP
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.PetPVPModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class PetPVPGetDailyRewardSocketHandler extends BaseSocketHandler
	{
		public function PetPVPGetDailyRewardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_GET_DAILY_REWARD;
		}
		
		override public function handlePackage():void
		{
			var awardState:int = _data.readByte();
			ModuleEventDispatcher.dispatchPetPVPEvent(new PetPVPModuleEvent(PetPVPModuleEvent.DAILY_REWARD_STATE,awardState));
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_PVP_GET_DAILY_REWARD);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}