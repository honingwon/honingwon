package sszt.challenge.socketHandlers
{
	import sszt.challenge.ChallengeModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	/**
	 * 试炼进入副本返回信息 
	 * @author chendong
	 * 
	 */	
	public class ChallengeEnterSocketHandler extends BaseSocketHandler
	{
		public function ChallengeEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.ENTER_CHALLENGE_BOSS;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var isSuc:Boolean = _data.readBoolean(); //进入副本成功或失败
			var code:int = _data.readInt(); // 服务端返回错误状态
//			if(code == 12401)
//			{
//				QuickTips.show("炼前置关卡限制");
//			}
//			else if(code == 12402)
//			{
//				QuickTips.show("当前所在地图限制");
//			}
//			else if(code == 21)
//			{
//				QuickTips.show("玩家等级不足");
//			}
			handComplete();
		}
		
		/**
		 * 进入试炼副本
		 * @param missionId 试炼序列号id
		 */
		public static function send(missionId:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ENTER_CHALLENGE_BOSS);
			pkg.writeInt(missionId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		public function get challengeModule():ChallengeModule
		{
			return _handlerData as ChallengeModule;
		}
		
	}
}