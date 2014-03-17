package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetCallSocketHandler extends BaseSocketHandler
	{
		public function PetCallSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_CALL;
		}

		public static function send(itemId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_CALL);
			pkg.writeNumber(itemId);
//			pkg.writeInt(petId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}