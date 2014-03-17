package sszt.scene.socketHandlers.smIsland.beforeEnter
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.data.copyIsland.beforeEnter.CIBeforeItemInfo;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class CopyIslandLeaderEnterSocketHandler extends BaseSocketHandler
	{
		public function CopyIslandLeaderEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.COPY_ISLAND_LEADER_ENTER;
		}
		
		override public function handlePackage():void
		{
			if(GlobalData.copyEnterCountList.isInCopy || MapTemplateList.isAcrossBossMap() || MapTemplateList.isClubMap() ||
				MapTemplateList.isClubWarMap() || MapTemplateList.isPerWarMap() || MapTemplateList.isShenMoMap() ||
				MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsPrison() || MapTemplateList.isPerWarMap() ||
				MapTemplateList.isShenMoMap() || MapTemplateList.getIsInSpaMap() || MapTemplateList.getIsInVipMap() || 
				MapTemplateList.isShenMoIsland())return;
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				var copyId:int = _data.readInt();
				var tmpList:Array = [];
				var leaderName:String = _data.readString();
				var len:int = _data.readInt();
				for(var i:int = 0;i < len;i++)
				{
					var tmpInfo:CIBeforeItemInfo = new CIBeforeItemInfo();
					tmpInfo.name = _data.readUTF();
					if(leaderName == tmpInfo.name)
					{
						tmpInfo.tag = 1;
					}
					tmpList.push(tmpInfo);
				}
				sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCOPYISLAND,copyId);
				sceneModule.copyIslandInfo.cIBeforeInfo.resultList = tmpList;
				sceneModule.copyIslandInfo.cIBeforeInfo.init();
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.notEnterConditionNotMatch"));
				return;
			}
			handComplete();
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.COPY_ISLAND_LEADER_ENTER);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}