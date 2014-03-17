package sszt.scene.socketHandlers.perWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.personalWar.PerWarMainItemInfo;
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarSceneItemInfo;

	/**
	 * 
	 * 神魔乱斗场荣誉战场列表更新
	 * 
	 */	
	public class PerWarSceneListUpdateSocketHandler extends BaseSocketHandler
	{
		public function PerWarSceneListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERWAR_WARLIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var result1:Array = [];
			var result2:Array = [];
			for(var i:int = 0;i < len;i++)
			{
				var tmpItemInfo:PerWarMainItemInfo = new PerWarMainItemInfo();
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
			sceneModule.perWarInfo.perWarMainInfo.warSceneItemInfoDiList = result1;
//			sceneModule.shenMoWarInfo.shenMoWarHonorInfo.warSceneItemInfoGaoList = result2;
			sceneModule.perWarInfo.perWarMainInfo.updateList();
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERWAR_WARLIST_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}