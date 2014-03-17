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
	
	public class PetXisuiUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetXisuiUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_XISUI_UPDATE;
		}
		
		override public function handlePackage():void
		{
			QuickTips.show(LanguageManager.getWord('ssztl.pet.xisuiOk'));
			handComplete();
		}
		
		public static function send(petId:Number,typeCode:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_XISUI_UPDATE);
			pkg.writeNumber(petId);
			pkg.writeByte(typeCode);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}