package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetQualityUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetQualityUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_QUALITY_UPDATE;
		}
		
		override public function handlePackage():void
		{
//			if(_data.readBoolean())
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsQualitySuccess"));
//			}
//			else
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.mounts.mountsQualityFail"));
//			}
			var id:Number = _data.readNumber();
			var pet:PetItemInfo = GlobalData.petList.getPetById(id);
			pet.qualityExp =  _data.readInt();
			pet.updateQualityExp();
			handComplete();
		}
		
		public static function send(petId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_QUALITY_UPDATE);
			pkg.writeNumber(petId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}