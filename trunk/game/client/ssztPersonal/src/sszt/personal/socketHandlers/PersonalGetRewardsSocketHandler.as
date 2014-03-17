package sszt.personal.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PersonalGetRewardsSocketHandler extends BaseSocketHandler
	{
		public function PersonalGetRewardsSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_REWARDS;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
//				QuickTips.show("领取成功！");
				QuickTips.show(LanguageManager.getWord("ssztl.common.getSuccess"));
			}
			else
			{
//				QuickTips.show("领取失败！");
				QuickTips.show(LanguageManager.getWord("ssztl.common.getFail"));
			}
		}
		
		public static function sendRewards():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_REWARDS);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}