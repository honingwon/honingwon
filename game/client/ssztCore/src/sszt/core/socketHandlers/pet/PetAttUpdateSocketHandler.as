package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	
	public class PetAttUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetAttUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_ATT_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var pet:PetItemInfo = GlobalData.petList.getPetById(id);
			pet.updateStyle(_data.readInt());
			pet.diamond = _data.readByte();
			pet.star = _data.readByte();
			pet.stairs = _data.readByte();
			pet.grow = _data.readByte();
			pet.growExp =_data.readInt();
			pet.quality = _data.readByte();
			pet.qualityExp =_data.readInt();
			
			PackageUtil.parsePetProperty(pet,_data);
			pet.update();
			
			handComplete();
		}
	}
}