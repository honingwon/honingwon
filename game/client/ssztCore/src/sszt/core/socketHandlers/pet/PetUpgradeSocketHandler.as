package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetUpgradeSocketHandler extends BaseSocketHandler
	{
		public function PetUpgradeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var level:int = _data.readByte();
			var pet:PetItemInfo = GlobalData.petList.getPetById(id);
			if(pet)
			{
				pet.level = level;
				pet.upgrade();
			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_UPGRADE;
		}
	}
}