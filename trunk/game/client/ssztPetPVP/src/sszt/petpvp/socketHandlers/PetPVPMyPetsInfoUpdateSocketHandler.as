package sszt.petpvp.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	
	public class PetPVPMyPetsInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetPVPMyPetsInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_MY_PET_INFO;
		}
		
		override public function handlePackage():void
		{
			var i:int;
			
			var myPetsInfo:Array = [];
			var myPetsLen:int = _data.readByte();
			var myPetItemInfo:PetPVPPetItemInfo;
			for(i = 0; i < myPetsLen; i++)
			{
				myPetItemInfo = new PetPVPPetItemInfo();
				myPetItemInfo.parseData(_data);
				myPetsInfo.push(myPetItemInfo);
			}
			
			module.petPVPInfo.updateMyPetsInfo(myPetsInfo);
			
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
		
	}
}