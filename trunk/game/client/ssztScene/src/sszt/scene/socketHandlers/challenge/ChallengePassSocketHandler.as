package sszt.scene.socketHandlers.challenge
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class ChallengePassSocketHandler extends BaseSocketHandler
	{
		public function ChallengePassSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.CHALLENGE_BOSS_PASS;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var missionId:int = _data.readInt(); //试炼关卡序号
			var star:int = _data.readInt(); // 0,1,2 评星等级
			var passTime:int = _data.readInt(); // 过关所花时间 秒
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_CHALLENGE_PANEL,{missionId:missionId,star:star,passTime:passTime}))
			handComplete();
		}
	}
}