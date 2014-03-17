package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetReleaseSocketHandler extends BaseSocketHandler
	{
		public function PetReleaseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_RELEASE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			
			GlobalData.petList.removePet(id);
			handComplete();
		}
		
		public static function send(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_RELEASE);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}