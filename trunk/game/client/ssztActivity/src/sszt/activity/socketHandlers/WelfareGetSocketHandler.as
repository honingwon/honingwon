package sszt.activity.socketHandlers
{
	import sszt.activity.ActivityModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.WelfareTemplateInfoList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WelfareGetSocketHandler extends BaseSocketHandler
	{
		public function WelfareGetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			module.activityInfo.changeState(id,_data.readBoolean());
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_WELF_SEARCH;
		}
		
		private function get module():ActivityModule
		{
			return _handlerData as ActivityModule;
		}
		
		public static function sendGetWelfare(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_WELF_SEARCH);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}