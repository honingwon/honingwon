package sszt.scene
{
	import sszt.scene.commands.SceneEndCommand;
	import sszt.scene.commands.SceneStartCommand;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.mediators.SceneMediator;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class SceneFacade extends Facade
	{
		public static function getInstance(key:String):SceneFacade
		{
			if(!(instanceMap[key] is SceneFacade))
			{
				delete instanceMap[key];
				instanceMap[key] = new SceneFacade(key);
			}
			return instanceMap[key];
		}
		
		private var _key:String;
		public var sceneModule:SceneModule;
		
		public function SceneFacade(key:String)
		{
			_key = key;
			super(key);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(SceneMediatorEvent.SCENE_COMMAND_START,SceneStartCommand);
			registerCommand(SceneMediatorEvent.SCENE_COMMAND_END,SceneEndCommand);
		}
		
		public function startup(module:SceneModule):void
		{
			sceneModule = module;
			sendNotification(SceneMediatorEvent.SCENE_COMMAND_START,module);
			sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_START);
			
			sceneModule.sceneMediator = retrieveMediator(SceneMediator.NAME) as SceneMediator;
		}
		
		public function dispose():void
		{
			sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_DISPOSE);
			sendNotification(SceneMediatorEvent.SCENE_COMMAND_END);
			removeCommand(SceneMediatorEvent.SCENE_COMMAND_START);
			removeCommand(SceneMediatorEvent.SCENE_COMMAND_END);
			delete instanceMap[_key];
			sceneModule = null;
		}
	}
}