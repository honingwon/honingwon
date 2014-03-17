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
	
	public class PetNameUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetNameUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_NAME_UPDATE;
		}
		
		override public function handlePackage():void
		{
			_data.readByte();
			var id:Number = _data.readNumber();
			var pet:PetItemInfo = GlobalData.petList.getPetById(id);
			.0
			var name:String = _data.readUTF();
			if(pet)
			{
				pet.reName(name);
			}
			QuickTips.show(LanguageManager.getWord('ssztl.pet.renameSuccess'));
			
			handComplete();
		}
		
		public static function send(id:Number,nick:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_NAME_UPDATE);
			pkg.writeNumber(id);
			pkg.writeString(nick);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}