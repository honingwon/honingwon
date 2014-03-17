package sszt.petpvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.petpvp.PetPVPModule;
	
	public class PetPVPChallengeTimesUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetPVPChallengeTimesUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_CHALLENGE_TIMES_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var remainingTimes:int = _data.readInt();
			var totalTimes:int = _data.readInt();
			var lastTime:int = _data.readInt();
			module.petPVPInfo.updateChallengeTimes(remainingTimes,totalTimes,lastTime);
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
		
		//1 times 2 timer
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_PVP_CHALLENGE_TIMES_UPDATE);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}