package sszt.petpvp.data
{
	import flash.events.EventDispatcher;
	
	import sszt.events.PetPVPModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.petpvp.events.PetPVPInfoEvent;

	public class PetPVPInfo extends EventDispatcher
	{
		public var isInit:Boolean;
		/**
		 * 剩余挑战次数
		 * */
		public var remainingTimes:int;
		/**
		 * 最后一次挑战的时间
		 * */
		public var lastTime:int;
		public var totalTimes:int;
		/**
		 * 领奖状态 
		 * */
		public var awardState:Boolean;
		
		public var myPetsInfo:Array;
		public var rankInfo:Array;
		public var challengeList:Array;
		public var logInfo:Array;
		public var awardList:Array;
		
		public var currMyPetId:Number;
		public var currOpponentPetId:Number;
		
		public function PetPVPInfo()
		{
			myPetsInfo = [];
			rankInfo = [];
			challengeList = [];
			logInfo = [];
			ModuleEventDispatcher.addPetPVPEventListener(PetPVPModuleEvent.DAILY_REWARD_STATE,updateAwardState);
		}
		
		public function updateAll(myPetsInfo:Array,rankInfo:Array,logInfo:Array,awardList:Array,remainingTimes:int,totalTimes:int,lastTime:int,awardState:Boolean):void
		{
			this.isInit = true;
			this.myPetsInfo = myPetsInfo;
			this.rankInfo = rankInfo;
			this.logInfo = logInfo;
			this.awardList = awardList;
			this.remainingTimes = remainingTimes;
			this.totalTimes = totalTimes;
			this.lastTime = lastTime;
			this.awardState = awardState;
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.ALL_UPDATE));
		}
		
		protected function updateAwardState(e:PetPVPModuleEvent):void
		{
			this.awardState = e.data as int;
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.AWARD_STATE_UPDATE));
		}
		
		public function updateLogInfo(info:Array):void
		{
			this.logInfo = info;
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.LOG_INFO_UPDATE));
		}
		
		public function updateRankInfo(rankInfo:Array):void
		{
			this.rankInfo = rankInfo;
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.RANK_INFO_UPDATE));
		}
		
		public function updateMyPetsInfo(myPetsInfo:Array):void
		{
			this.myPetsInfo = myPetsInfo;
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.MY_PETS_INFO_UPDATE));
		}
		
		public function updateChallengeTimes(remainingTimes:int,totalTimes:int,lastTime:int):void
		{
			this.remainingTimes = remainingTimes;
			this.lastTime = lastTime;
			this.totalTimes = totalTimes;
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.CHALLENGE_TIMES_UPDATE));
		}
		
		public function updateResult(result:PetPVPChallengeResultInfo):void
		{
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.RESULT_UPDATE,result));
		}
		
		public function updateChallengeList(petIdFromServer:Number,list:Array):void
		{
			challengeList = list;
			dispatchEvent(new PetPVPInfoEvent(PetPVPInfoEvent.CHALLENGE_INFO_UPDATE,petIdFromServer));
		}
		
		public function getCurrMyPetItemInfo():PetPVPPetItemInfo
		{
			return getMyPetItemInfoById(currMyPetId);
		}
		
		public function getCurrOpponetPetItemInfo():PetPVPPetItemInfo
		{
			return getOpponetPetItemInfoById(currOpponentPetId);
		}
		
		public function getOpponetPetItemInfoById(id:Number):PetPVPPetItemInfo
		{
			var ret:PetPVPPetItemInfo;
			var i:PetPVPPetItemInfo;
			for each(i in challengeList)
			{
				if(i.id == id)
				{
					ret = i;
					break;
				}
			}
			return ret;
		}
		
		public function getMyPetItemInfoById(id:Number):PetPVPPetItemInfo
		{
			var ret:PetPVPPetItemInfo;
			var i:PetPVPPetItemInfo;
			for each(i in myPetsInfo)
			{
				if(i.id == id)
				{
					ret = i;
					break;
				}
			}
			return ret;
		}
	}
}