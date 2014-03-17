package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class PlayerFollowSocketHandler extends BaseSocketHandler
	{
		public function PlayerFollowSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_FOLLOW;
		}
		
		override public function handlePackage():void
		{
//			var id:Number = _data.readNumber();
//			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
//			if(player)
//			{
//				sceneModule.sceneInfo.playerList.self.setFollower(player);
//			}
//			else
//			{
//				//提示玩家不在附近。。。
//			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_FOLLOW);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}