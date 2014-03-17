
package sszt.pet.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.pet.PetModule;
	
	public class PetGetSkillBookItemSocketHandler extends BaseSocketHandler
	{
		public function PetGetSkillBookItemSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_SKILL_ITEM_GET;
		}
		
		override public function handlePackage():void
		{
			var isSuccessful:Boolean = _data.readBoolean();
			var lucyValue:int = _data.readShort();
			
			//获取技能书成功
			if(isSuccessful && petModule.petsInfo.petRefreshSkillBooksInfo)
			{
				petModule.petsInfo.petRefreshSkillBooksInfo.updateLucyValue(lucyValue);
				petModule.petsInfo.petRefreshSkillBooksInfo.getSkillBookSuccessed();
			}
		}
		
		private function get petModule():PetModule
		{
			return _handlerData as PetModule;
		}
		
		public static function send(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_SKILL_ITEM_GET);
			pkg.writeByte(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}