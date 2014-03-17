package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubLotterySocketHandler extends BaseSocketHandler
	{
		public function ClubLotterySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_PRAYER;
		}
		
		override public function handlePackage():void
		{
			var successful:Boolean = _data.readBoolean();
			var other:int = _data.readInt();
			if(successful)
			{
				clubModule.clubInfo.clubLotteryInfo.updateItemTemplateId(other);
				
				ClubLotteryGetTimesSocketHandler.send();
			}
			else
			{
				if(other == 63) 
					QuickTips.show(LanguageManager.getWord('ssztl.club.exploitNotEnoughForWheel'));
				else if(other == 64)
					QuickTips.show('祈福次数达到上限');
				else
					QuickTips.show('发生未知错误');

			}
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_PRAYER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}