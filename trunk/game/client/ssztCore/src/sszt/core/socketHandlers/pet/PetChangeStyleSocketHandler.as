package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetChangeStyleSocketHandler extends BaseSocketHandler
	{
		public function PetChangeStyleSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_CHANGE_STYLE;
		}
			
		public static function send(petId:Number,itemId:Number,templateId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_CHANGE_STYLE);
			pkg.writeNumber(petId);
			pkg.writeNumber(itemId);
			pkg.writeInt(templateId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}