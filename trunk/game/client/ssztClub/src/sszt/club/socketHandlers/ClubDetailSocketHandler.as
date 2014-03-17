package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.club.datas.deviceInfo.ClubDeviceInfo;
	import sszt.club.events.ClubShopLevelUpdateEvent;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.ClubLevelTemplate;
	import sszt.core.data.club.ClubLevelTemplateList;
	import sszt.core.data.club.memberInfo.ClubMemberInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ClubDetailSocketHandler extends BaseSocketHandler
	{
		public function ClubDetailSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_DETAIL;
		}
		
		override public function handlePackage():void
		{
			if(clubModule.clubInfo.clubDetailInfo == null)
			{
				clubModule.clubInfo.initDetailInfo();
			}
//			if(clubModule.clubInfo.clubMemberInfo == null)
//			{
//				clubModule.clubInfo.initMemeberInfo();
//			}
			if(clubModule.clubInfo.deviceInfo == null)
			{
				clubModule.clubInfo.initClubDeviceInfo();
			}
			if(clubModule.clubInfo.clubDetailInfo)
			{
				var info:ClubDetailInfo = clubModule.clubInfo.clubDetailInfo;
				var info1:ClubMemberInfo = GlobalData.clubMemberInfo;
				var info2:ClubDeviceInfo = clubModule.clubInfo.deviceInfo;
				info.clubName = _data.readString();
				_data.readNumber();
				info.masterName = _data.readString();
				info.masterType = _data.readByte();
//				info.viceMasterServerId = _data.readShort();
//				info.viceMasterName = _data.readString();
//				info.viceMasterType = _data.readByte();
				var clubLevel:int = _data.readByte();
				if(clubLevel != info1.clubLevel)
				{
					var temp:ClubLevelTemplate = ClubLevelTemplateList.getTemplate(clubLevel);
					info1.totalHonor = temp.hornor;
					info1.totalViceMaster = temp.viceMaster;
					info1.totalMember = temp.total;
					info1.clubLevel = clubLevel;
					info.totalCount = temp.total;
				}
				info.clubLevel = clubLevel;
				info2.furnaceLevel = _data.readByte();
				GlobalData.selfPlayer.clubFurnaceLevel = info2.furnaceLevel;
				info2.shopLevel = _data.readByte();
				
				info.clubRank = _data.readInt();
				info.currentCount = _data.readInt();
				info.clubRich = _data.readInt();
				info.maintainFee = _data.readInt();
//				info.totalCount = _data.readInt();
				
//				info.clubRich = _data.readInt();
//				info.mainTainFee = _data.readInt();
//				info.Q_group = _data.readString();
//				info.YY_group = _data.readString();
				info.notice = _data.readString();
				
//				if(info.viceMasterName != "") info1.currentMaster = 1;
//				else info1.currentMaster = 0;
				
				if(GlobalData.selfPlayer.nick == info.masterName) GlobalData.selfPlayer.clubDuty = ClubDutyType.MASTER;
				info.update();
				info2.update();
			}	
			ModuleEventDispatcher.dispatchModuleEvent(new ClubShopLevelUpdateEvent(ClubShopLevelUpdateEvent.UPDATE_SHOP_LEVEL));
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(clubId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_DETAIL);
			pkg.writeNumber(clubId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}