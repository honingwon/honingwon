package sszt.core.data.task
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.ArrayUtil;

	/**
	 * 任务状态模版
	 */
	public class TaskStateTemplateInfo
	{
		public var awardCopper:int;
		public var awardExp:int;
		public var awardYuanBao:int;
		public var awardLifeExp:int;
		public var awardBindYuanBao:int;
		public var awardBindCopper:int;
		
		public var contribution:int;   //帮会物资(原帮会贡献)
		public var money:int;          //帮会财富 
		public var active:int;         //帮会繁荣(原帮会活跃)
		public var exploit:int;        //个人功勋 
		
		public var condition:int;
		public var data:Array = new Array();
		public var npc:int;
		/**
		 * 完成任务对白
		 */	
		public var content:Array;
		public var target:String;
		public var canTransfer:Boolean;														//能否传送
//		public var awardList:Vector.<TaskAwardTemplateInfo>;
//		public var finish1Deploys:Vector.<DeployItemInfo>;
//		public var finish2Deploys:Vector.<DeployItemInfo>;
//		public var notFinishDeploys:Vector.<DeployItemInfo>;
		public var awardList:Array;
		public var finish1Deploys:Array;
		public var finish2Deploys:Array;
		public var notFinishDeploys:Array;
		public var awardString:String;
		
		public function TaskStateTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray,taskId:int):void
		{
			awardCopper = data.readInt();
			awardExp = data.readInt();
			awardYuanBao = data.readInt();
			awardLifeExp = data.readInt();
			awardBindYuanBao = data.readInt();
			awardBindCopper = data.readInt();
			
			contribution = data.readInt();
			money = data.readInt();
			active = data.readInt();
			exploit = data.readInt();
			
			condition = data.readInt();
			canTransfer = data.readBoolean();
			var taskData:Array = ArrayUtil.trimStringArray(data.readUTF().split("|"));
			for(var i:int = 0; i < taskData.length; i++)
			{
				this.data.push(taskData[i].split(","));
			}
			target = data.readUTF();
			npc = data.readInt();
			content = ArrayUtil.trimStringArray(data.readUTF().split("||"));
			
			
			
			if(taskId == 524005)
				target = target.replace("{105#"+LanguageManager.getWord("ssztl.common.yeCha")+"#212008###}","{104#"+LanguageManager.getWord("ssztl.common.yeCha")+"#212008###}");
			if(taskId == 524006 || taskId == 524003)
				target = target.replace("{104#"+LanguageManager.getWord("ssztl.common.xiaoyao")+"#2120006###}","{104#"+LanguageManager.getWord("ssztl.common.xiaoyao")+"#212006###}");
			if(taskId == 524007)
				target = target.replace("{107#"+LanguageManager.getWord("ssztl.common.killer")+"#211331###}","{104#"+LanguageManager.getWord("ssztl.common.killer")+"#211331###}");
			if(taskId == 524008)
				target = target.replace("{108#"+LanguageManager.getWord("ssztl.common.zuiHunGui")+"#212101###}","{104#"+LanguageManager.getWord("ssztl.common.zuiHunGui")+"#212101###}");
			if(taskId == 524009)
				target = target.replace("{109#"+LanguageManager.getWord("ssztl.common.heiShanLaoYao")+"#212102###}","{104#"+LanguageManager.getWord("ssztl.common.heiShanLaoYao")+"#212102###}");
			if(taskId == 524010)
				target = target.replace("{110#"+LanguageManager.getWord("ssztl.common.shanZei")+"211201###}","{104#"+LanguageManager.getWord("ssztl.common.shanZei")+"#211201###}");
			
			
			
			var deploy:DeployItemInfo;
			var k:int;
			var notFinish:Array = ArrayUtil.trimStringArray(data.readUTF().split("|"));
			var notFinishLen:int = notFinish.length;
//			notFinishDeploys = new Vector.<DeployItemInfo>();
			notFinishDeploys = [];
			for(k = 0; k < notFinishLen; k++)
			{
				deploy = new DeployItemInfo();
				deploy.parseData(notFinish[k]);
				notFinishDeploys.push(deploy);
			}
			var finish1:Array = ArrayUtil.trimStringArray(data.readUTF().split("|"));
			var finish1Len:int = finish1.length;
//			finish1Deploys = new Vector.<DeployItemInfo>();
			finish1Deploys = [];
			for(k = 0; k < finish1Len; k++)
			{
				deploy = new DeployItemInfo();
				deploy.parseData(finish1[k]);
				finish1Deploys.push(deploy);
			}
			var finish2:Array = ArrayUtil.trimStringArray(data.readUTF().split("|"));
			var finish2Len:int = finish2.length;
//			finish2Deploys = new Vector.<DeployItemInfo>();
			finish2Deploys = [];
			for(k = 0; k < finish2Len; k++)
			{
				deploy = new DeployItemInfo();
				deploy.parseData(finish2[k]);
				finish2Deploys.push(deploy);
			}
			
			awardString = data.readUTF();
			var awardLen:int = data.readInt();
//			awardList = new Vector.<TaskAwardTemplateInfo>();
			awardList = [];
			for(var j:int = 0; j < awardLen; j++)
			{
				var award:TaskAwardTemplateInfo  = new TaskAwardTemplateInfo();
				award.parseData(data);
				awardList.push(award);
			}
		}
		
		/**
		 * 获取个人奖励列表(性别、职业)
		 * 
		 */		
//		public function getSelfAwardList():Vector.<TaskAwardTemplateInfo>
		public function getSelfAwardList():Array
		{
//			var list:Vector.<TaskAwardTemplateInfo> = new Vector.<TaskAwardTemplateInfo>();
			var list:Array = [];
			for each(var info:TaskAwardTemplateInfo in awardList)
			{
				if(info.career == 0 || info.career == GlobalData.selfPlayer.career)
				{
					if(info.sex == 0 || (info.sex == 1 && GlobalData.selfPlayer.sex == true) || (info.sex == 2 && GlobalData.selfPlayer.sex == false))
					{
						list.push(info);
					}
				}
			}
			return list;
		}
		
		/**
		 * 任务怪物ID/收集物品ID
		 * @param index
		 * @return 
		 * 
		 */		
		public function getObjId(index:int):int
		{
			if(condition == TaskConditionType.COLLECT_MONSTER || condition == TaskConditionType.DROP_MONSTER)
				return data[index][2];
			else
				return data[index][0];
		}
		/**
		 * 任务怪物场景ID
		 * @param index
		 * @return 
		 * 
		 */		
		public function getMonsterScene(index:int):int
		{
			if(condition == TaskConditionType.KILLMONSTER || condition == TaskConditionType.COPY_KILLMONSTER || condition == TaskConditionType.HONGMING_KILLMONSTER)
				return MonsterTemplateList.getMonster(data[index][0]).sceneId;
			else if(condition == TaskConditionType.COLLECT_MONSTER || condition == TaskConditionType.DROP_MONSTER)
				return MonsterTemplateList.getMonster(data[index][2]).sceneId;
			return 0;
		}
		/**
		 * 任务怪物坐标
		 * @param index
		 * @return 
		 * 
		 */		
		public function getMonsterPos(index:int):Point
		{
			return new Point(MonsterTemplateList.getMonster(getObjId(index)).centerX,MonsterTemplateList.getMonster(getObjId(index)).centerY);
		}
		
		
		public function getTargetPos(index:int) : Point
		{
			if (TaskConditionType.getIsFindNpc(this.condition))
			{
				return new Point(NpcTemplateList.getNpc(this.getObjId(index)).sceneX, NpcTemplateList.getNpc(this.getObjId(index)).sceneY);
			}
			if (TaskConditionType.getIsCollectItemTask(this.condition))
			{
				return CollectTemplateList.getCollect(this.getObjId(index)).getAPoint();
			}
			if (TaskConditionType.getIsKillMonster(this.condition))
			{
				return MonsterTemplateList.getMonster(this.getObjId(index)).getAPoint();
			}
			return null;
		}
		
	}
}