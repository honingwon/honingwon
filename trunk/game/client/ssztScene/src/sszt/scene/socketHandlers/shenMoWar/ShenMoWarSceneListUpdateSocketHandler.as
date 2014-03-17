package sszt.scene.socketHandlers.shenMoWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarSceneItemInfo;

	/**
	 * 
	 * 神魔乱斗场荣誉战场列表更新
	 * 
	 */	
	public class ShenMoWarSceneListUpdateSocketHandler extends BaseSocketHandler
	{
		public function ShenMoWarSceneListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SHENMO_WARLIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var result1:Array = [];
			var result2:Array = [];
			for(var i:int = 0;i < len;i++)
			{
				var tmpItemInfo:ShenMoWarSceneItemInfo = new ShenMoWarSceneItemInfo();
//				tmpItemInfo.listId = _data.readNumber();
//				tmpItemInfo.currentPepNum = _data.readByte();
//				tmpItemInfo.minLevel = _data.readByte();
//				tmpItemInfo.maxLevel = _data.readByte();
//				tmpItemInfo.maxPepNum = 200;
				
				tmpItemInfo.listId = _data.readNumber();
				tmpItemInfo.maxPepNum = _data.readShort();
				tmpItemInfo.currentPepNum = _data.readShort();
				tmpItemInfo.minLevel = _data.readByte();
				tmpItemInfo.maxLevel = _data.readByte();
				result1.push(tmpItemInfo);
			}
			sceneModule.shenMoWarInfo.shenMoWarHonorInfo.warSceneItemInfoDiList = result1;
//			sceneModule.shenMoWarInfo.shenMoWarHonorInfo.warSceneItemInfoGaoList = result2;
			sceneModule.shenMoWarInfo.shenMoWarHonorInfo.updateList();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SHENMO_WARLIST_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}