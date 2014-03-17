package sszt.scene.socketHandlers.smIsland.beforeEnter
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.components.copyGroup.sec.CopyCountDownView;
	import sszt.scene.components.copyGroup.sec.CopyTowerCountDownView;
	import sszt.scene.components.pk.PkCountDownAction;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class CopyIslandEneterSokcetHandler extends BaseSocketHandler
	{
		public function CopyIslandEneterSokcetHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_ENTER;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			if(id == -1)
			{
				GlobalAPI.waitingLoading.hide();
			}
			else
			{
				GlobalData.copyEnterCountList.isInCopy = true;
				GlobalData.copyEnterCountList.inCopyId = id;
//				var time:int = CopyTemplateList.getCopy(id).countTime;
//				if(time > 0) CopyCountDownView.getInstance().show(time);
			}
			handComplete();
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_ENTER);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}