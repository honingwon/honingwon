package sszt.scene.socketHandlers.smIsland.beforeEnter
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CopyIslandTeamerEnterSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandTeamerEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_TEAMER_ENTER;
		}
		
		override public function handlePackage():void
		{
			var tmpType:int = _data.readInt();
			var tmpName:String = _data.readString();
//			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.isAcrossBossMap() || MapTemplateList.isClubMap() ||
//				MapTemplateList.isClubWarMap() || MapTemplateList.isPerWarMap() || MapTemplateList.isShenMoMap() ||
//				MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsPrison() || MapTemplateList.isPerWarMap() ||
//				MapTemplateList.isShenMoMap() || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap() || 
//				MapTemplateList.isShenMoIsland())return;
			if(!sceneModule || !sceneModule.copyIslandInfo || !sceneModule.copyIslandInfo.cIBeforeInfo)return;
			sceneModule.copyIslandInfo.cIBeforeInfo.updateItemInfo(tmpName,tmpType);
			handComplete();
		}
		
		public static function send(argType:int,argCopyId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_TEAMER_ENTER);
			pkg.writeInt(argType);
			pkg.writeInt(argCopyId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}