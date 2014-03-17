package sszt.personal.mediators
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.personal.PersonalDynamicType;
	import sszt.core.data.personal.PersonalInfo;
	import sszt.core.data.personal.item.PersonalDynamicItemInfo;
	import sszt.personal.PersonalModule;
	import sszt.personal.components.PersonalChangeHeadPanel;
	import sszt.personal.components.PersonalLuckyWheelPanel;
	import sszt.personal.components.PersonalMainPanel;
	import sszt.personal.data.PersonalPartInfo;
	import sszt.personal.events.PersonalMediatorEvents;
	import sszt.personal.socketHandlers.PersonalGetRewardsSocketHandler;
	import sszt.personal.socketHandlers.PersonalInfoChangeSocketHandler;
	import sszt.personal.socketHandlers.PersonalLuckyListUpdateSocketHandler;
	import sszt.personal.socketHandlers.PersonalLuckySelectUpdateSocketHandler;
	import sszt.personal.socketHandlers.PersonalMainInoUpdateSocketHandler;
	import sszt.personal.socketHandlers.PersonalRandomSocketHandler;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PersonalMediator extends Mediator
	{
		public static const NAME:String = "personalMediator";
		public function PersonalMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
							PersonalMediatorEvents.PERSONAL_MEDIATOR_START,
							PersonalMediatorEvents.PERSONAL_MEDIATOR_DISPOSE
							];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case PersonalMediatorEvents.PERSONAL_MEDIATOR_START:
					showPersonalMainPanel(notification.getBody() as Number);
					break;
				case PersonalMediatorEvents.PERSONAL_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		public function showPersonalMainPanel(argPlayerId:Number):void
		{
			if(personalModule.personalMainPanelList[argPlayerId] == null)
			{
				personalModule.personalMainPanelList[argPlayerId] = new PersonalMainPanel(this,argPlayerId);
				GlobalAPI.layerManager.addPanel(personalModule.personalMainPanelList[argPlayerId]);
				personalModule.personalMainPanelList[argPlayerId].addEventListener(Event.CLOSE,closeMainPanelHandler);
			}
			else
			{
				personalModule.personalMainPanelList[argPlayerId].dispose();
				personalModule.personalMainPanelList[argPlayerId] = null;
			}
		}
		
		private function closeMainPanelHandler(e:Event):void
		{
			var personalMainPanel:PersonalMainPanel = e.currentTarget as PersonalMainPanel;
			if(personalModule.personalMainPanelList[personalMainPanel.playerId])
			{
				if(personalModule.personalChangeHeadPanel)
				{
					personalModule.personalChangeHeadPanel.dispose();
				}
				if(personalModule.personalLuckyWheelPanel)
				{
					personalModule.personalLuckyWheelPanel.dispose();
				}
				personalModule.personalMainPanelList[personalMainPanel.playerId].removeEventListener(Event.CLOSE,closeMainPanelHandler);
				delete personalModule.personalInfoList[personalMainPanel.playerId];
				personalModule.personalMainPanelList[personalMainPanel.playerId] = null;
			}
		}
		
		public function showChangeHeadPanel():void
		{
			if(personalModule.personalChangeHeadPanel == null)
			{
				personalModule.personalChangeHeadPanel = new PersonalChangeHeadPanel(this);
				GlobalAPI.layerManager.addPanel(personalModule.personalChangeHeadPanel);
				personalModule.personalChangeHeadPanel.addEventListener(Event.CLOSE,closeChangeHeadPanelHandler);
			}
		}
		
		private function closeChangeHeadPanelHandler(e:Event):void
		{
			if(personalModule.personalChangeHeadPanel)
			{
				personalModule.personalChangeHeadPanel.removeEventListener(Event.CLOSE,closeChangeHeadPanelHandler);
				personalModule.personalChangeHeadPanel = null;
			}
		}
		
		public function showPersonalLuckyWheelPanel(argUserId:Number):void
		{
			if(personalModule.personalLuckyWheelPanel == null)
			{
				personalModule.personalLuckyWheelPanel = new PersonalLuckyWheelPanel(this,argUserId);
				GlobalAPI.layerManager.addPanel(personalModule.personalLuckyWheelPanel);
				personalModule.personalLuckyWheelPanel.addEventListener(Event.CLOSE,closePersonalLuckyWheelPanel);
			}
			else
			{
				if(GlobalAPI.layerManager.getTopPanel() != personalModule.personalLuckyWheelPanel)
				{
					personalModule.personalLuckyWheelPanel.setToTop();
				}
				else
				{
					personalModule.personalLuckyWheelPanel.dispose();
				}
			}
		}
		private function closePersonalLuckyWheelPanel(e:Event):void
		{
			if(personalModule.personalLuckyWheelPanel)
			{
				personalModule.personalLuckyWheelPanel.removeEventListener(Event.CLOSE,closePersonalLuckyWheelPanel);
				personalModule.personalLuckyWheelPanel = null;
			}
		}
		
		
		public function sendMainInfo(argPlayerId:Number):void
		{
			PersonalMainInoUpdateSocketHandler.send(argPlayerId);
			
//			personalInfo.personalMyInfo.star = "狮子座";
//			personalInfo.personalMyInfo.province = "广东省";
//			personalInfo.personalMyInfo.city = "广州";
//			personalInfo.personalMyInfo.mood = "很好啊！";
//			personalInfo.personalMyInfo.introduce = "你妹啊！";
//			personalInfo.personalMyInfo.winNum = 100;
//			personalInfo.personalMyInfo.failNum = 200;
//			personalInfo.personalMyInfo.isHasGetRewards = false;
//			personalInfo.personalMyInfo.update();
		}
		
		public function sendChangeInfo(argStarId:int,argProvinceId:int,argCityId:int,argMood:String,argIntroduce:String,argHeadIndex:int):void
		{
			PersonalInfoChangeSocketHandler.send(argStarId,argProvinceId,argCityId,argMood,argIntroduce,argHeadIndex);
		}
		
		public function sendRewards():void
		{
			PersonalGetRewardsSocketHandler.sendRewards();
		}
		
		public function sendRandom():void
		{
			PersonalRandomSocketHandler.send();
			
//			for(var i:int = 0;i < 50;i++)
//			{
//				var tmpItemInfo:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
//				tmpItemInfo.typeId = PersonalDynamicType.FRIEND_UPGRADE;
//				tmpItemInfo.userId = 100001;
//				tmpItemInfo.name = "你妹啊！"
//				tmpItemInfo.parm1 = 60;
//				GlobalData.personalInfo.personalFriendInfo.addToList(tmpItemInfo);
//			}
//			
//			var tmpItemInfo1:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
//			tmpItemInfo1.typeId = PersonalDynamicType.FRIEND_DEAD;
//			tmpItemInfo1.userId = 10003;
//			tmpItemInfo1.name = "卧槽";
//			tmpItemInfo1.parm1 = 10009;
//			tmpItemInfo1.parm5 = "昵玛";
//			tmpItemInfo1.parm2 = 50001;
//			tmpItemInfo1.parm3 = 100;
//			tmpItemInfo1.parm4 = 100;
//			personalModule.personalInfo.personalFriendInfo.addToList(tmpItemInfo1);
//			
//			var tmpItemInfo2:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
//			tmpItemInfo2.typeId = PersonalDynamicType.FRIEND_TASK_SHARE;
//			tmpItemInfo2.userId = 10006;
//			tmpItemInfo2.name = "我勒个去啊"
//			tmpItemInfo2.parm1 = 456;
//			tmpItemInfo2.parm5 = "饿狼傻X";
//			personalModule.personalInfo.personalFriendInfo.addToList(tmpItemInfo2);
//			
//			
//			var tmpItemInfo3:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
//			tmpItemInfo3.typeId = PersonalDynamicType.CLUB_UPGRADE;
//			tmpItemInfo3.parm1 = 100;
//			personalModule.personalInfo.personalClubInfo.addToList(tmpItemInfo3);
//			
//			var tmpItemInfo4:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
//			tmpItemInfo4.typeId = PersonalDynamicType.CLUBTASK_SHARE;
//			tmpItemInfo4.userId = 98544;
//			tmpItemInfo4.name = "哈哈哈!!";
//			tmpItemInfo4.parm1 = 9885;
//			personalModule.personalInfo.personalClubInfo.addToList(tmpItemInfo4);
//			
//			var tmpItemInfo5:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
//			tmpItemInfo5.typeId = PersonalDynamicType.CLUBMATE_UPGRADE;
//			tmpItemInfo5.userId = 456789;
//			tmpItemInfo5.name = "看见了的房间你妹啦";
//			tmpItemInfo5.parm1 = 123;
//			personalModule.personalInfo.personalClubInfo.addToList(tmpItemInfo5);
//			
//			var tmpItemInfo6:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
//			tmpItemInfo6.typeId = PersonalDynamicType.CLUBMATE_DEAD;
//			tmpItemInfo6.userId = 5664;
//			tmpItemInfo6.name = "其配偶";
//			tmpItemInfo6.parm1 = 698;
//			tmpItemInfo6.parm5 = "草草草";
//			tmpItemInfo6.parm2 = 987;
//			tmpItemInfo6.parm3 = 620;
//			tmpItemInfo6.parm4 = 510;
//			personalModule.personalInfo.personalClubInfo.addToList(tmpItemInfo6);
		}
		
		public function sendLuckyList():void
		{
			PersonalLuckyListUpdateSocketHandler.send();
			
//			var tmpList:Array = [];
//			tmpList.push(101001);
//			tmpList.push(101002);
//			tmpList.push(101003);
//			tmpList.push(101004);
//			tmpList.push(101005);
//			tmpList.push(101006);
//			tmpList.push(101007);
//			tmpList.push(101008);
//			personalPartInfo.personalPartLuckyInfo.luckyTemplateIdList = tmpList;
//			personalPartInfo.personalPartLuckyInfo.updateLuckyList();
			
		}
		public function sendLuckySelect():void
		{
			PersonalLuckySelectUpdateSocketHandler.send();
			
//			personalPartInfo.personalPartLuckyInfo.selectTemplateId = 101006;
//			personalPartInfo.personalPartLuckyInfo.updateSelect();
		}
		
		public function get personalModule():PersonalModule
		{
			return viewComponent as PersonalModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}