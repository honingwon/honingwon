package sszt.mergeServer
{
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.mergeServer.command.MergeServerEndCommand;
	import sszt.mergeServer.command.MergeServerStartCommand;
	import sszt.mergeServer.event.MergeServerMediatorEvent;
	
	public class MergeServerFacade extends Facade
	{
		public static function getInstance(key:String):MergeServerFacade
		{
			if(!(instanceMap[key] is MergeServerFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new MergeServerFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		
		public function MergeServerFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(MergeServerMediatorEvent.MERGE_SERVER_COMMAND_START,MergeServerStartCommand);
			registerCommand(MergeServerMediatorEvent.MERGE_SERVER_COMMAND_END,MergeServerEndCommand);
		}
		
		public function startup(module:MergeServerModule,data:Object):void
		{
			sendNotification(MergeServerMediatorEvent.MERGE_SERVER_COMMAND_START,module);
		}
		
		public function dispose():void
		{
			sendNotification(MergeServerMediatorEvent.MERGE_SERVER_DISPOSE);
			sendNotification(MergeServerMediatorEvent.MERGE_SERVER_COMMAND_END);
			removeCommand(MergeServerMediatorEvent.MERGE_SERVER_COMMAND_END);
			removeCommand(MergeServerMediatorEvent.MERGE_SERVER_COMMAND_START);
			instanceMap[_key] = null;
		}
	}
}