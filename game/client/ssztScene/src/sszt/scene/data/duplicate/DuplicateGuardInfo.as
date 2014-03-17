package sszt.scene.data.duplicate
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.events.SceneDuplicateGuardUpdateEvent;
	
	public class DuplicateGuardInfo extends EventDispatcher
	{
		public var exp:int;
		public var bindCopper:int;
		public var missionNum:int;
		public var nextComeTime:int;
		
		public var spValue:int;		
		public var skillList:Array;
				
		public function DuplicateGuardInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function setDuplicateInfo():void
		{			
		}
		
		public function updateAward(texp:int,bCopper:int):void
		{
			exp += texp;
			bindCopper += bCopper;
			dispatchEvent(new SceneDuplicateGuardUpdateEvent(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_UPDATE_AWARD));
		}
		
		public function updateMission(id:int,time:int):void
		{
			missionNum = id;	
			nextComeTime = time;
			dispatchEvent(new SceneDuplicateGuardUpdateEvent(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_UPDATE_MISSION));
		}	
		public function updateCanOpenNextMonster():void
		{	
			dispatchEvent(new SceneDuplicateGuardUpdateEvent(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_CAN_OPEN_NEXT_MONSTER));
		}
		
		public function clearData():void
		{
			exp = 0;
			bindCopper = 0;
			missionNum = 0;
			spValue = 0;
			skillList = [];
		}
	}
}