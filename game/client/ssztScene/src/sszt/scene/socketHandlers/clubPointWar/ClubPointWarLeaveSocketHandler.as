package sszt.scene.socketHandlers.clubPointWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.components.copyGroup.sec.CopyCountDownView;
	
	public class ClubPointWarLeaveSocketHandler extends BaseSocketHandler
	{
		public function ClubPointWarLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_POINT_LEAVE;
		}
		
		override public function handlePackage():void
		{
			GlobalData.copyEnterCountList.isInCopy = false;
			GlobalData.copyEnterCountList.inCopyId = 0;
//			CopyCountDownView.getInstance().dispose();
			sceneModule.sceneInit.monsterListController.clearVoidResponseMouseList();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_POINT_LEAVE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}