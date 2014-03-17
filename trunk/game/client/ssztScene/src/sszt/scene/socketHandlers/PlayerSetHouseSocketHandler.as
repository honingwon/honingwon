package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class PlayerSetHouseSocketHandler extends BaseSocketHandler
	{
		public function PlayerSetHouseSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_SET_HOUSE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				player.info.mountAvoid = _data.readBoolean();
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(setHouse:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_SET_HOUSE);
			pkg.writeBoolean(setHouse);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}