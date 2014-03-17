package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mounts.MountsModule;
	
	public class MountsGetSkillBookListSocketHandler extends BaseSocketHandler
	{
		public function MountsGetSkillBookListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_GET_SKILL_BOOK_LIST;
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
			if(mountModule.mountsInfo.mountsRefreshSkillBooksInfo)
			{
				mountModule.mountsInfo.mountsRefreshSkillBooksInfo.update(luckyValue, list);
			}
		}
		
		private function get mountModule():MountsModule
		{
			return _handlerData as MountsModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_GET_SKILL_BOOK_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}