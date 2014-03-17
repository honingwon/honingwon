package sszt.scene.socketHandlers
{
	import flash.geom.Point;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.utils.PathUtils;
	
	public class PlayerMoveSocketHandler extends BaseSocketHandler
	{		
		public function PlayerMoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_MOVE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			if(id == GlobalData.selfPlayer.userId )return;
			var player:BaseScenePlayerInfo = sceneModule.sceneInfo.playerList.getPlayer(id);
			if(player)
			{
				var pathIndex:int = _data.readShort();
				var len:int = _data.readShort();
				var path:Array = [];
				for(var i:int = 0; i < len; i++)
				{
					path.push(new Point(_data.readShort(),_data.readShort()));
				}
//				if(pathIndex >= 10000)path.length = 0;
//				else
//				{
//					path = path.slice(pathIndex + 1);
//					path.unshift(new Point(player.sceneX,player.sceneY));
//				}
//				player.setPath(path,null,0,true);
				player.setPath(path);
			}
			if(sceneModule.sceneInfo.playerList.isSitParner(id))
			{
				sceneModule.sceneInfo.playerList.clearDoubleSit();
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send(path:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_MOVE);
			pkg.writeNumber(GlobalData.selfPlayer.userId);
			var target:Point = path[path.length - 1];
			var len:int = path.length;
			pkg.writeShort(len);
			for(var i:int = 0; i < len; i++)
			{
				pkg.writeShort(path[i].x);
				pkg.writeShort(path[i].y);
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}