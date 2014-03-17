package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.mounts.MountsModule;
	
	public class MountsRefreshSkillBooksSocketHandler extends BaseSocketHandler
	{
		public function MountsRefreshSkillBooksSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_SKILL_ITEM_REFRESH;
		}
		
		override public function handlePackage():void
		{
			
		}
		
		private function get mountModule():MountsModule
		{
			return _handlerData as MountsModule;
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_SKILL_ITEM_REFRESH);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}