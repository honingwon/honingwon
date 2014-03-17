package sszt.petpvp.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	
	public class PetPVPRankInfoUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetPVPRankInfoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_PVP_RANK_INFO;
		}
		
		override public function handlePackage():void
		{
			var i:int;
			var rankInfo:Array = [];
			var rankInfoLen:int = _data.readByte();
			var rankItemInfo:PetPVPPetItemInfo;
			for(i = 0; i < rankInfoLen; i++)
			{
				rankItemInfo = new PetPVPPetItemInfo();
				rankItemInfo.parseData(_data);
				rankInfo.push(rankItemInfo);
			}
			module.petPVPInfo.updateRankInfo(rankInfo);
			handComplete();
		}
		
		public function get module():PetPVPModule
		{
			return _handlerData as PetPVPModule;
		}
	}
}