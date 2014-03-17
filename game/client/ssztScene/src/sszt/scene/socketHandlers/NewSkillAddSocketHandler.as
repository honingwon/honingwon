package sszt.scene.socketHandlers
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class NewSkillAddSocketHandler extends BaseSocketHandler
	{
		public function NewSkillAddSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.NEW_SKILL_ADD;
		}
		
		override public function handlePackage():void
		{
			var skillId:int = _data.readInt();
			sceneModule.sceneInfo.hangupData.newSkillAdd(skillId);
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}