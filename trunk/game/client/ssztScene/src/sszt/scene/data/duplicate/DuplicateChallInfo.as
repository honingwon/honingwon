package sszt.scene.data.duplicate
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.copy.duplicate.DuplicatMissionInfo;
	import sszt.core.data.copy.duplicate.DuplicateMissionList;
	import sszt.scene.events.SceneDuplicatePassUpdateEvent;
	
	public class DuplicateChallInfo extends EventDispatcher
	{
		public var duplicateName:String;
		public var leftTime:int;
		public var mapId:int;
		public var leftMonsterNum:int;
		public var passState:Boolean;
		public var missionInfo:DuplicatMissionInfo;
		
		public function DuplicateChallInfo(target:IEventDispatcher=null)
		{
			super(target);
			passState = false;
		}
		
		public function setDuplicateInfo(id:int):void
		{
			mapId = id;
			missionInfo = DuplicateMissionList.getDuplicateMission(id);
			duplicateName = missionInfo.name;
			leftTime = missionInfo.needTime;
			leftMonsterNum = missionInfo.monsterNum;
			if(leftMonsterNum == 0)
				passState = true;
			else
				passState = false;
		}
		public function updateAward():void
		{
			passState = true;
			dispatchEvent(new SceneDuplicatePassUpdateEvent(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_AWARD));
		}
		public function updateMonsterNum(id:int, monsterId:int):void
		{
			if(id == mapId)
			{
				leftMonsterNum = leftMonsterNum - 1;
				dispatchEvent(new SceneDuplicatePassUpdateEvent(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_MONSTER));
			}
		}
		
		public function clearData():void
		{
			duplicateName = "";
			mapId = 0;
			missionInfo = null;
			leftMonsterNum = 0;
			leftTime = 0;
		}
	}
}