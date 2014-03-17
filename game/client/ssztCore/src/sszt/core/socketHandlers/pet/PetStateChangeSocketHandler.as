package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetStateChangeSocketHandler extends BaseSocketHandler
	{
		public function PetStateChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_STATE_CHANGE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readByte();
			for(var i:int = 0; i < len; i++)
			{
				var id:Number = _data.readNumber();
				var pet:PetItemInfo = GlobalData.petList.getPetById(id);
				pet.changeState(_data.readByte());
			}
			handComplete();
		}
		
		public static function send(id:Number,state:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_STATE_CHANGE);
			pkg.writeNumber(id);
			pkg.writeByte(state);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}