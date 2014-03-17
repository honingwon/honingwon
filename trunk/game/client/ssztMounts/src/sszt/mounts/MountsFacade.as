package sszt.mounts
{
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import sszt.mounts.command.MountsEndCommand;
	import sszt.mounts.command.MountsStartCommand;
	import sszt.mounts.event.MountsMediatorEvent;
	
	public class MountsFacade extends Facade
	{
		private var _key:String;
		
		public function MountsFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		public static function getInstance(key:String):MountsFacade
		{
			if(!(instanceMap[key] is MountsFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new MountsFacade(key); 
			}
			return instanceMap[key];
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(MountsMediatorEvent.MOUNTS_START_COMMAND,MountsStartCommand);
			registerCommand(MountsMediatorEvent.MOUNTS_END_COMMAND,MountsEndCommand);
		}
		
		public function startup(module:MountsModule):void
		{
			sendNotification(MountsMediatorEvent.MOUNTS_START_COMMAND,module);
		}
		
		public function dispose():void
		{
			sendNotification(MountsMediatorEvent.MOUNTS_DISPOSE);
			sendNotification(MountsMediatorEvent.MOUNTS_END_COMMAND);
			removeCommand(MountsMediatorEvent.MOUNTS_START_COMMAND);
			removeCommand(MountsMediatorEvent.MOUNTS_END_COMMAND);
			delete instanceMap[_key];
		}
	}
}