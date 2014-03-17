package sszt.scene.socketHandlers.perWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.components.shenMoWar.shenMoIcon.ShenMoIconView;
	
	public class PerWarLeaveSocketHandler extends BaseSocketHandler
	{
		public function PerWarLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERWAR_LEAVE_WAR;
		}
		
		override public function handlePackage():void
		{
//			var tmptime:int = _data.readInt();
//			sceneModule.shenMoWarIcon.show(tmptime);
			GlobalData.copyEnterCountList.isInCopy = false;
			GlobalData.copyEnterCountList.inCopyId = 0;
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERWAR_LEAVE_WAR);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}