package sszt.petpvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.petpvp.data.PetPVPChallengeResultInfo;
	
	public class PetPVPStartChallengingWithClearCDSocketHandler extends BaseSocketHandler
	{
		public function PetPVPStartChallengingWithClearCDSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_START_CHALLENGING_WITH_CLEAR_CD;
		}
		
		public static function send(petId:Number,opponentPetId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_PVP_START_CHALLENGING_WITH_CLEAR_CD);
			pkg.writeNumber(petId);
			pkg.writeNumber(opponentPetId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}