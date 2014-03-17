package sszt.core.socketHandlers.challenge
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ChallengeEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 请求试炼副本记录信息
	 * @author chendong
	 * 
	 */	
	public class ChallengeInfoSocketHandler extends BaseSocketHandler
	{
		public function ChallengeInfoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CHALLENGE_BOSS_INFO;
		}
		
		/**
		 * 处理服务端返回的数据
		 */
		override public function handlePackage():void
		{
			var num:int = _data.readShort();//当前试炼次数
			if(num > 10) num = 10;
			var starLevelStr:String = _data.readString();
			var starLevelArray:Array = [];
			var length:int = starLevelStr.length;
			var i:int = 0;
			for(; i < length; i++)
			{
				starLevelArray.push(int(starLevelStr.charAt(i)));
			}
			GlobalData.challInfo.num = num;
			GlobalData.challInfo.challInfo = starLevelArray;
			
			ModuleEventDispatcher.dispatchModuleEvent(new ChallengeEvent(ChallengeEvent.CHALLENGE_BOSS_INFO));
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CHALLENGE_BOSS_INFO);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}