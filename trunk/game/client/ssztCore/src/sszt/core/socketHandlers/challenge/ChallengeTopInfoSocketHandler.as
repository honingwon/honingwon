package sszt.core.socketHandlers.challenge
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ChallengeEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 获取试炼副本霸主信息
	 * @author chendong
	 * 
	 */	
	public class ChallengeTopInfoSocketHandler extends BaseSocketHandler
	{
		public function ChallengeTopInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.CHALLENGE_TOP_INFO;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var pazhuName:String = _data.readUTF().split(",")[0].toString(); //霸主名次
			var timeNum:int = _data.readInt(); // 话费时间
			ModuleEventDispatcher.dispatchModuleEvent(new ChallengeEvent(ChallengeEvent.CHALLENGE_TOP_INFO,{pazhuName:pazhuName,timeNum:timeNum}));
			handComplete();
		}
		
		/**
		 * 进入试炼副本
		 * @param missionId 试炼序列号id
		 * @param duplicateId 关联副本关卡id
		 */
		public static function send(missionId:int,duplicateId:int=8200801):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CHALLENGE_TOP_INFO);
			pkg.writeInt(duplicateId);
			pkg.writeInt(missionId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}