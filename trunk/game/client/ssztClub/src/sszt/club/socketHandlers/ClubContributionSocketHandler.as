package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.memberInfo.ClubMemberItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ClubContributionSocketHandler extends BaseSocketHandler
	{
		public function ClubContributionSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_CONTRIBUTION;
		}
		
		override public function handlePackage():void
		{
//			if(_data.readBoolean())
//			{
			var rich:int = _data.readInt();
			var userId:Number = _data.readNumber();
			var totalExploit:int = _data.readInt();
			var currentExploit:int = _data.readInt();
			
			if(clubModule.clubInfo.clubDetailInfo)
			{
				var info:ClubDetailInfo = clubModule.clubInfo.clubDetailInfo;
//				info.clubRich = rich;
				updateRich(rich,info);
				info.update();
			}
				
			GlobalData.selfPlayer.updateExploit(totalExploit,currentExploit);
			
				var itemInfo:ClubMemberItemInfo = GlobalData.clubMemberInfo.getClubMember(userId);
				if(itemInfo)
				{
					itemInfo.totalExploit = totalExploit;
					itemInfo.currentExploit = currentExploit;
					itemInfo.update();
				}
			
			handComplete();
		}
		
		
		private function updateRich(value:int,info:ClubDetailInfo):void
		{
			if(info.clubRich == value)return;
			var old:int = info.clubRich;
			info.clubRich = value >= 0 ? value : 0;
			var temp:int  = info.clubRich - old;
			if(temp <= 0)return;
			var message:String = LanguageManager.getWord("ssztl.common.gainClubExploit",temp);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.ADD_EVENTLIST,message));
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		/**argContributeType  1为铜币   2为元宝**/
		public static function send(argContributeType:int,argCount:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_CONTRIBUTION);
			pkg.writeInt(argContributeType);
			if(argContributeType == 1)
			{
				pkg.writeInt(argCount/2000);
			}
			else
			{
				pkg.writeInt(argCount);	
			}
			GlobalAPI.socketManager.send(pkg);
		}
	}
}