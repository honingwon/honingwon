package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class UpdateSelfExpSocketHandler extends BaseSocketHandler
	{
		public function UpdateSelfExpSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.UPDATE_SELF_EXP;
		}
		
		override public function handlePackage():void
		{
			GlobalData.selfPlayer.updateExp(_data.readNumber());
			GlobalData.selfPlayer.updateLifeExp(_data.readInt());
			var petId:Number = _data.readNumber();
			if(petId != 0)
			{
				var pet:PetItemInfo = GlobalData.petList.getPetById(petId);
				pet.exp = _data.readNumber();
				pet.updateExp();
			}
			handComplete();
		}
	}
}