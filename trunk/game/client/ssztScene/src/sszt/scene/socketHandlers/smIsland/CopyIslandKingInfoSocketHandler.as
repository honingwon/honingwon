package sszt.scene.socketHandlers.smIsland
{
	import flash.geom.Point;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.data.copyIsland.CIKingInfo;
	import sszt.scene.data.copyIsland.CIKingPosInfo;
	import sszt.scene.data.copyIsland.CIMaininfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	
	public class CopyIslandKingInfoSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandKingInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_KINGINFO;
		}
		
		override public function handlePackage():void
		{
			var kingInfo:CIKingInfo = sceneModule.copyIslandInfo.cIKingInfo;
			var mainInfo:CIMaininfo = sceneModule.copyIslandInfo.cIMainInfo;
			if(!kingInfo || !mainInfo)return;
//			var tmpList:Array = [];
			var tmpPassTime:int = _data.readInt();
//			if(tmpPassTime == 0)return;
			kingInfo.passTime =tmpPassTime;
			kingInfo.mapId = _data.readInt();
			var len:int = _data.readInt();
			sceneModule.sceneInfo.playerList.clearKingList(); //清空前霸主信息
			for(var i:int = 0;i < len;i++)
			{
				var tmpSingleInfo:FigurePlayerInfo = new FigurePlayerInfo();
				tmpSingleInfo.userId = _data.readNumber();
				tmpSingleInfo.nick = _data.readString();
//				PackageUtil.readStyle(tmpSingleInfo,_data);
//				tmpList.push(tmpSingleInfo);
				var tmpInfo:BaseScenePlayerInfo = new BaseScenePlayerInfo(tmpSingleInfo,new CharacterWalkActionII());
				var tmpPosInfo:CIKingPosInfo = kingInfo.getKingPos(mainInfo.stage);
				tmpInfo.warState = 6;
				if(!tmpPosInfo)return;
				tmpInfo.setScenePos(tmpPosInfo.pointList[i].x,tmpPosInfo.pointList[i].y);
				sceneModule.sceneInfo.playerList.addIslandKing(tmpInfo);//逐个增加霸主信息
			}
//			kingInfo.styleList = tmpList;
			kingInfo.updateKingTime();
			handComplete();
		}
		
		public static function send(argStageId:int,argMapId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_KINGINFO);
			pkg.writeInt(argStageId);
			pkg.writeInt(argMapId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}