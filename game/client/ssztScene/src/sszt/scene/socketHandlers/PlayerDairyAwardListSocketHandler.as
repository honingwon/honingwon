package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.dailyAward.DailyAwardTemplateList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	
	public class PlayerDairyAwardListSocketHandler extends BaseSocketHandler
	{
		public function PlayerDairyAwardListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_DAILY_AWARD_LIST;
		}
		
		private function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
		
		override public function handlePackage():void
		{
			var code:String = _data.readUTF();//0可领取1已领取 2不可领取
			var seconds:int = _data.readInt();
			
			var list:Array = [];
			var len:int = code.length;
			var i:int;
			var needSeconds:int;
			var state:int;
			var canGet:Boolean;
			for(i=0;i<code.length;i++)
			{
				needSeconds = DailyAwardTemplateList.getTemplate(i+1).needSeconds;
				state = int(code.charAt(i));
				if(state == 0 && seconds < needSeconds)
				{
					state = 2;
				}
				if(state==0)
				{
					canGet = true;
				}
				list.push(state);
			}
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ONLINE_REWARD_CAN_GET,canGet));
			sceneModule.onlineRewardInfo.update(list,seconds);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_DAILY_AWARD_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}