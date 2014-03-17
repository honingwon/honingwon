package sszt.scene.socketHandlers.smIsland
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	
	public class CopyIslandShowRewardSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandShowRewardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_SHOWREWARD;
		}
		
		override public function handlePackage():void
		{
			var stage:int = _data.readInt();
			var exp:int = _data.readInt();
			var lifeExp:int = _data.readInt();
//			MAlert.show("尊敬的玩家，恭喜您通过了神魔岛"+stage+"层，获得了"+exp+"经验与"+lifeExp+"历练值。","提示",MAlert.OK);
			MAlert.show(LanguageManager.getWord("ssztl.scene.overShenMoIslandFloorAward",stage,exp,lifeExp),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_SHOWREWARD);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}