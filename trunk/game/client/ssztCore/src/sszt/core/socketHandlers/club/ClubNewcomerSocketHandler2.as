package sszt.core.socketHandlers.club
{
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	
	public class ClubNewcomerSocketHandler2 extends BaseSocketHandler
	{
		public function ClubNewcomerSocketHandler2(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_NEWCOMER2;
		}
		
		override public function handlePackage():void
		{
			QuickTips.show(LanguageManager.getWord('ssztl.common.operateSuccess'));
			handComplete();
		}
	}
}