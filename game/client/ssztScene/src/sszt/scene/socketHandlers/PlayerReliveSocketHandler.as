package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class PlayerReliveSocketHandler extends BaseSocketHandler
	{
		public function PlayerReliveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_RELIVE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			var player:BaseRoleInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				player.currentHp = _data.readInt();
				player.currentMp = _data.readInt();
				player.state.setCommon(true);
				if(sceneModule.sceneInfo.teamData.getPlayer(id) != null)
				{
					sceneModule.sceneInfo.teamData.getPlayer(id).currentHp = player.currentHp;
					sceneModule.sceneInfo.teamData.getPlayer(id).currentMp = player.currentMp;
				}
			}
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		/**
		 * 
		 * @param type 1:回城复活，2：原地计时复活(60s)，3：原地健康复活 ,4 :原地计算复活(15s)
		 * 
		 */		
		public static function sendRelive(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_RELIVE);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}