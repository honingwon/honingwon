package sszt.scene.socketHandlers.smIsland
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.copyIsland.CIKingInfo;
	import sszt.scene.data.copyIsland.CIMaininfo;
	
	public class CopyIslandMainInfoSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandMainInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_MAININFO;
		}
		
		override public function handlePackage():void
		{
			var tmpInfo:CIMaininfo = sceneModule.copyIslandInfo.cIMainInfo;
			if(!tmpInfo)return;
			tmpInfo.stage = _data.readInt();
			tmpInfo.leftTime = _data.readInt();
			tmpInfo.singleExp = _data.readInt();
			tmpInfo.singleLifeExp = _data.readInt();
			tmpInfo.allExp = _data.readInt();
			tmpInfo.allLifeExp = _data.readInt();
			tmpInfo.nextMapId = _data.readInt();
			if(tmpInfo.stage > tmpInfo.maxStage)
			{
				tmpInfo.update();
				tmpInfo.maxStage = tmpInfo.stage;
			}
			if(CIKingInfo.kingStageList.indexOf(tmpInfo.stage) != -1)
			{
				CopyIslandKingInfoSocketHandler.send(tmpInfo.stage,GlobalData.currentMapId);
			}
			tmpInfo.updateTime();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_MAININFO);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}