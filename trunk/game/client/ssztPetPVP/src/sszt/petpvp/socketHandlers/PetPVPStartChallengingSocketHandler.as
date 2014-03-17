package sszt.petpvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.data.PetPVPChallengeResultInfo;
	
	public class PetPVPStartChallengingSocketHandler extends BaseSocketHandler
	{
		public function PetPVPStartChallengingSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_START_CHALLENGING;
		}
		
		override public function handlePackage():void
		{
			var result:PetPVPChallengeResultInfo = new PetPVPChallengeResultInfo();
			result.petId = _data.readNumber();
			result.petReplaceID = _data.readInt();
			result.petFight = _data.readInt();
			result.petNick = _data.readUTF()
			result.opponetPetId = _data.readNumber();			
			result.opponetPetReplaceID = _data.readInt();
			result.opponetPetFight = _data.readInt();
			result.opponetPetNick = _data.readUTF()
			result.isWinning = _data.readBoolean();
			result.copper = _data.readInt();
			result.exp = _data.readInt();
			result.itemTemplateId = _data.readInt();
			result.myPetSkills = [];
			result.oppoentPetSkills = [];
			var len:int = _data.readByte();
			for (var i:int = 0;i<len;i++)
			{
				var skill:int = _data.readInt();
				result.myPetSkills.push(skill);
			}
			len = _data.readByte();
			for (i = 0;i<len;i++)
			{
				skill = _data.readInt();
				result.oppoentPetSkills.push(skill);
			}
			module.petPVPInfo.updateResult(result);	
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
		
		public static function send(petId:Number,opponentPetId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_PVP_START_CHALLENGING);
			pkg.writeNumber(petId);
			pkg.writeNumber(opponentPetId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}