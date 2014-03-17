package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetRemoveSkillSocketHandler extends BaseSocketHandler
	{
		public function PetRemoveSkillSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_REMOVE_SKILL;
		}
		
		public static function send(petId:Number,groupId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_REMOVE_SKILL);
			pkg.writeNumber(petId);
			pkg.writeInt(groupId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}