package sszt.pet.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.pet.PetModule;
	
	public class PetRefreshSkillBooksSocketHandler extends BaseSocketHandler
	{
		public function PetRefreshSkillBooksSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_SKILL_ITEM_REFRESH;
		}
		
		override public function handlePackage():void
		{
			
		}
		
		private function get petModule():sszt.pet.PetModule
		{
			return _handlerData as PetModule;
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_SKILL_ITEM_REFRESH);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}