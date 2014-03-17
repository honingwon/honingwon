package sszt.scene.socketHandlers.shenMoWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class ShenMoWarResultUpdateSocketHandler extends BaseSocketHandler
	{
		public function ShenMoWarResultUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SHENMO_WARRESULT_UPDATE;
		}
		
		override public function handlePackage():void
		{
			if(sceneModule.shenMoWarInfo.shenMoWarResult)
			{
				sceneModule.shenMoWarInfo.shenMoWarResult.shenWinNum = _data.readShort();
				sceneModule.shenMoWarInfo.shenMoWarResult.moWinNum = _data.readShort();
				sceneModule.shenMoWarInfo.shenMoWarResult.update();
			}
			handComplete();
		}
		
		public static function send(argWarSceneId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SHENMO_WARRESULT_UPDATE);
			pkg.writeNumber(argWarSceneId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}