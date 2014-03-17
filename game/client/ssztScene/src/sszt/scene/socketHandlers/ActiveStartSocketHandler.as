package sszt.scene.socketHandlers
{
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.ActiveStartEvents;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.ActivityIcon.*;
	
	public class ActiveStartSocketHandler extends BaseSocketHandler
	{
		public function ActiveStartSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{			
			return ProtocolType.ACTIVE_START;
		}
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			//1004答题  
			//1001pvp  
			//1002 京城捉贼
			//1003 惩恶扶伤
			//1005京城巡逻
			//1006帮派突袭
			var activeId:int = _data.readInt();
			var state:int = _data.readInt();
			var continueTime:int = _data.readInt();			
			
			if(activeId == 1001)
			{
				PVPView.getInstance().show(state,continueTime,true);
				
				if(state == 1 && GlobalData.selfPlayer.level >= 35)
				{
					var pvpData:ToPvPData = new ToPvPData();
					pvpData.openPanel = 2;
					SetModuleUtils.addPVP1(pvpData);
				}
				GlobalData.pvpInfo.current_active_id = activeId;
			}
			else if(activeId == 1002)
			{
				ActivityThievesView.getInstance().show(state,continueTime,true);
				if(state == 1)
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,0));
				}
			}
			else if(activeId == 1003)
			{
				ActivityPunishView.getInstance().show(state,continueTime,true);
				if(state == 1)
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,1));
				}
			}			
			else if(activeId == 1004)
			{
				QuizView.getInstance().show(state,continueTime,true);
				
				if(state == 1 && GlobalData.selfPlayer.level >=30)//已经开始，30秒后推送题目
				{
					SetModuleUtils.addQuiz(new ToQuizData(1));
				}
			}
			else if(activeId == 1005)
			{
				ActivityPatrolView.getInstance().show(state,continueTime,true);
				if(state == 1 && GlobalData.selfPlayer.level >= 20)
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,2));
				}
			}
			else if(activeId == 1006)
			{
				ClubActivityRaid.getInstance().show(state,continueTime,true);
				if(state == 1 && GlobalData.selfPlayer.level >= 30 && GlobalData.selfPlayer.clubId != 0)
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,3));
				}
			}
			else if(activeId == 1007)
			{
				AcceptTransportView.getInstance().show(state,continueTime,true);
			}			
			else if(activeId == 1008)
			{
				var activeTime:ActiveStarTimeData;
				activeTime = new ActiveStarTimeData();
				activeTime.activeId = 1008;
				activeTime.time = continueTime; 
				activeTime.continueTime = continueTime;
				activeTime.state = 1;
				GlobalData.activeStartInfo.activeTimeInfo[activeTime.activeId] = activeTime;
				ModuleEventDispatcher.dispatchModuleEvent(new ActiveStartEvents(ActiveStartEvents.ACTIVE_START_UPDATE));

//				ResourceWarView.getInstance().show(state,null,true);
				
				if(state == 1 && GlobalData.selfPlayer.level >=35)//已经开始，弹出引导框
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,4));
				}
			}
			if(activeId == 1009)
			{
				var activeTime1:ActiveStarTimeData;
				activeTime1 = new ActiveStarTimeData();
				activeTime1.activeId = 1009;
				activeTime1.time = continueTime; 
				activeTime1.continueTime = continueTime;
				activeTime1.state = 1;
				GlobalData.activeStartInfo.activeTimeInfo[activeTime1.activeId] = activeTime1;
				ModuleEventDispatcher.dispatchModuleEvent(new ActiveStartEvents(ActiveStartEvents.ACTIVE_START_UPDATE));
				if(state == 1 && GlobalData.selfPlayer.level >= 40)//已经开始，弹出引导框
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,6));
				}
			}
			
			if(activeId == 1011)
			{
				BigBossIconView.getInstance().show(state,null,true);
				if(state == 1 && GlobalData.selfPlayer.level >=35)
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,7));
				}
			}
			
			if(activeId == 1012)
			{
				var activeTime2:ActiveStarTimeData;
				activeTime2 = new ActiveStarTimeData();
				activeTime2.activeId = 1012;
				activeTime2.time = continueTime; 
				activeTime2.continueTime = continueTime;
				activeTime2.state = 1;
				GlobalData.activeStartInfo.activeTimeInfo[1012] = activeTime2;
				GuildPVPIconView.getInstance().show(state,continueTime,true);
				if(state == 1 && GlobalData.selfPlayer.level >=35)
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,8));
				}
			}
			
			if(activeId == 1013)
			{
				var activeTime3:ActiveStarTimeData;
				activeTime3 = new ActiveStarTimeData();
				activeTime3.activeId = 1013;
				activeTime3.time = continueTime; 
				activeTime3.continueTime = continueTime;
				activeTime3.state = 1;
				GlobalData.activeStartInfo.activeTimeInfo[1013] = activeTime3;
//				CityCraftView.getInstance().show(state,continueTime,true);
				if(state == 1 && GlobalData.selfPlayer.level >=35)
				{
					SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,9));
				}
			}
			
			handComplete();
		}
	}
}