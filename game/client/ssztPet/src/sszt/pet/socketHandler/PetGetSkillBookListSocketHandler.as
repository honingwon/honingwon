package sszt.pet.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.pet.PetModule;
	
	public class PetGetSkillBookListSocketHandler extends BaseSocketHandler
	{
		public function PetGetSkillBookListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_GET_SKILL_BOOK_LIST;
		}
		
		override public function handlePackage():void
		{
			var luckyValue:int = _data.readShort();
			var len:int = _data.readByte();
			var list:Array = new Array(len);
			for(var i:int = 0; i < len; i++)
			{
				var bookItemInfo:ItemInfo = new ItemInfo();
				bookItemInfo.place = _data.readInt();
				bookItemInfo.templateId = _data.readInt();
				bookItemInfo.isBind = _data.readBoolean();
				list[i] = bookItemInfo;
			}
			if(petModule.petsInfo.petRefreshSkillBooksInfo)
			{
				petModule.petsInfo.petRefreshSkillBooksInfo.update(luckyValue, list);
			}
		}
		
		private function get petModule():PetModule
		{
			return _handlerData as PetModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_GET_SKILL_BOOK_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}