package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetSealSkillSocketHandler extends BaseSocketHandler
	{
		public function PetSealSkillSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_SEAL_SKILL;
		}
		
		public static function send(petId:Number,groupId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_SEAL_SKILL);
			pkg.writeNumber(petId);
			pkg.writeInt(groupId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}