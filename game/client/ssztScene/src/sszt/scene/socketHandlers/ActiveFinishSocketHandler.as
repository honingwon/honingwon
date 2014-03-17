package sszt.scene.socketHandlers
{
	import flash.utils.setTimeout;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ActiveStartEvents;
	import sszt.events.QuizModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.ActivityIcon.*;
	import sszt.ui.container.MAlert;
	
	public class ActiveFinishSocketHandler extends BaseSocketHandler
	{
		public function ActiveFinishSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{			
			return ProtocolType.ACTIVE_FINISH;
		}


		override public function handlePackage():void
		{
			//1004答题  1001pvp  1002刷怪 1003刷怪
			var activeId:int = _data.readInt();
			ModuleEventDispatcher.dispatchModuleEvent(new ActiveStartEvents(ActiveStartEvents.ACTIVE_FINISH, activeId));
			if(activeId == 1001)
			{
				PVPView.getInstance().hide(true);
				if(GlobalData.pvpInfo.current_active_id == activeId)
					GlobalData.pvpInfo.current_active_id = 0;
			}
			
			if(activeId == 1002)
				ActivityThievesView.getInstance().dispose();
			if(activeId == 1003)
				ActivityPunishView.getInstance().dispose();
			if(activeId == 1005)
				ActivityPatrolView.getInstance().dispose();
			if(activeId == 1006)
				ClubActivityRaid.getInstance().dispose();
			if(activeId == 1007)
				AcceptTransportView.getInstance().dispose();
			if(activeId == 1011)
				BigBossIconView.getInstance().dispose();
			if(activeId == 1012)
				GuildPVPIconView.getInstance().dispose();
			if(activeId == 1013)
				CityCraftView.getInstance().dispose();
			if(activeId == 1008)
			{
				ResourceWarView.getInstance().hide(true);
				
				var activityInfo:ActiveStarTimeData = GlobalData.activeStartInfo.activeTimeInfo['1008']
				if(activityInfo)
				{
					activityInfo.state = 0;
				}
			}
			if(activeId == 1009)
			{
				PvpFirstView.getInstance().hide(true);				
				var activityInfo1:ActiveStarTimeData = GlobalData.activeStartInfo.activeTimeInfo['1009']
				if(activityInfo1)
				{
					activityInfo1.state = 0;
				}
			}
				
			if(activeId == 1004)
			{
				if(MapTemplateList.isIsOrNot())
				{
					var exp:int = GlobalData.quizInfo.totalExpAward;
					var bindYuanbao:int = GlobalData.quizInfo.totalBindYuanbao;
					var totalRight:int = GlobalData.quizInfo.totalRight;
					var totalWrong:int = GlobalData.quizInfo.totalWrong;
					var message:String = LanguageManager.getWord('ssztl.quiz.result',totalRight,totalWrong,exp,bindYuanbao);
					MAlert.show(message,LanguageManager.getWord('ssztl.common.alertTitle'));
				}
				
				setTimeout(timeOut,3000);
				function timeOut():void
				{
					//答题活动结束
					ModuleEventDispatcher.dispatchQuizEvent(new QuizModuleEvent(QuizModuleEvent.QUIZ_END));
				}
				
				//图标移除
				QuizView.getInstance().dispose();
				
				GlobalData.quizInfo.hasBegun = false;
				
			}
			handComplete();
		}
	}
}