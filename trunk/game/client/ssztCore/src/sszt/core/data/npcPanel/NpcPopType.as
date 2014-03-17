package sszt.core.data.npcPanel
{
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;

	public class NpcPopType
	{
		public static function getNpcPopInfo1(npcId:int):NpcPopInfo
		{
			var info:NpcPopInfo = new NpcPopInfo();
			info.npcId = npcId;
			
			info.descript = LanguageManager.getWord("ssztl.core.transportIntroduce");
			
			var deployInfo:DeployItemInfo = new DeployItemInfo();
			deployInfo.descript = LanguageManager.getWord("ssztl.core.clear");
			info.deployList.push(deployInfo);
			return info;
		}
		
		public static function getNpcPopInfo2(npcId:int):NpcPopInfo
		{
			var info:NpcPopInfo = new NpcPopInfo();
			info.npcId = npcId;
			var list:Array = [];
			for each(var template:TaskTemplateInfo in TaskTemplateList.getTemplateList())
			{
				if(template.condition == TaskConditionType.TRANSPORT && template.getCanAccept())
				{
					var deploy:DeployItemInfo = new DeployItemInfo();
					deploy.type = DeployEventType.TASK;
					deploy.descript = template.acceptContent[0];
					deploy.param1 = 1;
					deploy.param2 = template.taskId;
					info.deployList.push(deploy);
					list.push(deploy.descript + LanguageManager.getWord("ssztl.common.copperValue",template.needCopper));
				}
			}
			
			info.descript = LanguageManager.getWord("ssztl.core.transportDetail",list[0],list[1],list[2],list[3]);
			
			return info;
		}
		
		public static function getPopInfo(type:int,npcId:int):NpcPopInfo
		{
			switch(type)
			{
				case 1: return getNpcPopInfo1(npcId);
				case 2: return getNpcPopInfo2(npcId);
			}
			return null;
		}
	}
}