package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.ui.container.MAlert;
	
	public class PVPEndSocketHandler extends BaseSocketHandler
	{
		public function PVPEndSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{			
			return ProtocolType.PVP_END;
		}
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			var activeId:int = _data.readInt();
			var result:int = _data.readInt(); // 0:平局，1：胜利，2：失败
			var num:int = _data.readShort();
//			var award:Array = [];
			var count1:int = 0;
			var count2:int = 0;
			for(var i:int = 0; i < num; i++)
			{
				_data.readShort();
				if(i == 0)
					count1 = _data.readInt();  // 功勋
				else if(i == 1)
					count2 = _data.readInt();  // 奖励
			}
//			if(result == 1)
//			{
//				MAlert.show("获得功勋："+count1+"人品奖励"+count2,"胜利",MAlert.OK,null,null);
//			}
//			else if(result == 0)
//			{
//				MAlert.show("获得功勋："+count1+"人品奖励"+count2,"平局",MAlert.OK,null,null);
//			}
//			else if(result == 2)
//				MAlert.show("获得功勋："+count1+"人品奖励"+count2,"失败",MAlert.OK,null,null);
			GlobalData.pvpInfo.user_pvp_state = 0;//战斗结束退出pvp		
			var pvpData:ToPvPData = new ToPvPData();
			pvpData.openPanel = 1;
			pvpData.result = result;
			pvpData.count1 = count1;
			pvpData.count2 = count2;
			SetModuleUtils.addPVP1(pvpData);
			sceneModule.duplicateNormalInfo.stopCountDown();
//			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_PVP_RESULT_PANEL,{result:result,count1:count1,count2:count2}));
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}