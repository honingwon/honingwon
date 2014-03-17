package sszt.petpvp.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	
	public class PetPVPChallengeInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetPVPChallengeInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_CHALLENGE_INFO_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var list:Array = [];
			var petIdFromServer:Number = _data.readNumber();
			var len:int = _data.readByte();
			var challengePetItemInfo:PetPVPPetItemInfo;
			for(var i:int = 0; i < len; i++)
			{
				challengePetItemInfo = new PetPVPPetItemInfo();
				challengePetItemInfo.parseData(_data);
				list.push(challengePetItemInfo);
			}
			
			if(list.length > 0)
			{
				module.petPVPInfo.updateChallengeList(petIdFromServer,list);
			}
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
		
		public static function send(petId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_PVP_CHALLENGE_INFO_UPDATE);
			pkg.writeNumber(petId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}