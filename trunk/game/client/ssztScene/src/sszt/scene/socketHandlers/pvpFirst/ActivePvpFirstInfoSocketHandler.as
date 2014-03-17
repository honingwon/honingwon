package sszt.scene.socketHandlers.pvpFirst
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class ActivePvpFirstInfoSocketHandler extends BaseSocketHandler
	{
		public function ActivePvpFirstInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_PVP_FIRST_INFO;
		}
		
		override public function handlePackage():void
		{
			var time:int = _data.readInt();
			var id:int = _data.readNumber();
			var name:String = _data.readString();
			module.pvpFirstInfo.updatePvpFirstInfo(time,name);
			handComplete();
			
		}
		public function get module():SceneModule
		{
			return _handlerData as SceneModule;
		}
		public static function send() : void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_PVP_FIRST_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}