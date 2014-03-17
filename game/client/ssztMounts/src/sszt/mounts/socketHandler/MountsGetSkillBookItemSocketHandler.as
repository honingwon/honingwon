package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mounts.MountsModule;
	
	public class MountsGetSkillBookItemSocketHandler extends BaseSocketHandler
	{
		public function MountsGetSkillBookItemSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_SKILL_ITEM_GET;
		}
		
		override public function handlePackage():void
		{
			var isSuccessful:Boolean = _data.readBoolean();
			var lucyValue:int = _data.readShort();
			
			//获取技能书成功
			if(isSuccessful && mountModule.mountsInfo.mountsRefreshSkillBooksInfo)
			{
				mountModule.mountsInfo.mountsRefreshSkillBooksInfo.updateLucyValue(lucyValue);
				mountModule.mountsInfo.mountsRefreshSkillBooksInfo.getSkillBookSuccessed();
			}
		}
		
		private function get mountModule():MountsModule
		{
			return _handlerData as MountsModule;
		}
		
		public static function send(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_SKILL_ITEM_GET);
			pkg.writeByte(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}