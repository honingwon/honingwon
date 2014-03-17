package sszt.rank
{
	import flash.sampler.DeleteObjectSample;
	
	import sszt.rank.command.RankCommandEnd;
	import sszt.rank.command.RankCommandStart;
	import sszt.rank.events.RankEvent;
	import sszt.rank.events.RankMediatorEvents;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class RankFacade extends Facade
	{
		private var _key:String;
		public function RankFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):RankFacade
		{
			if(!(instanceMap[key] is RankFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new RankFacade(key);
			}
			return instanceMap[key];
		}
		
		public function setup(rankModule:RankModule):void
		{
			sendNotification(RankMediatorEvents.RANK_COMMAND_START, rankModule);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(RankMediatorEvents.RANK_COMMAND_START, RankCommandStart);
			registerCommand(RankMediatorEvents.RANK_COMMAND_END, RankCommandEnd);
		}
		
		public function dispose():void
		{
			sendNotification(RankMediatorEvents.RANK_MEDIATOR_DISPOSE);
			sendNotification(RankMediatorEvents.RANK_COMMAND_END);
			removeCommand(RankMediatorEvents.RANK_COMMAND_START);
			removeCommand(RankMediatorEvents.RANK_COMMAND_END);
			delete instanceMap[_key];
		}
	}
}