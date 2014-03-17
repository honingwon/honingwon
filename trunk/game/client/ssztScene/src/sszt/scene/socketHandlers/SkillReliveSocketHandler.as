package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.scene.SceneModule;
	import sszt.scene.events.SceneMediatorEvent;
	
	public class SkillReliveSocketHandler extends BaseSocketHandler
	{
		public function SkillReliveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SKILL_RELIVE;
		}
		
		override public function handlePackage():void
		{
			var nick:String = _data.readString();
			sceneModule.facade.sendNotification(SceneMediatorEvent.SHOW_RELIVE_MALERT,nick);
			
			handComplete();
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.SKILL_RELIVE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}