package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetFeedSocketHandler extends BaseSocketHandler
	{
		
		public function PetFeedSocketHandler(handlerData:Object = null)
		{
			super(handlerData);
		} 
		
		override public function getCode() : int
		{
			return ProtocolType.PET_ENERGY_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var pet:PetItemInfo = GlobalData.petList.getPetById(id);
			pet.energy =_data.readByte();
			pet.updateEnergy();
			
			handComplete();
		}
		
		public static function send(petId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_ENERGY_UPDATE);
			pkg.writeNumber(petId);
			GlobalAPI.socketManager.send(pkg);
		} 
	}
}