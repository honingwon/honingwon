package sszt.petpvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.petpvp.PetPVPModule;
	
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
			var awardState:Boolean = _data.readBoolean();
			if(module)
			{
//				module.petPVPInfo.updateAwardState(awardState);
			}
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_PVP_GET_DAILY_REWARD);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}