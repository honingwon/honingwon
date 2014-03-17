package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.constData.ClubCampCallType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.camp.ClubCampCallTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.club.camp.ClubCampEnterSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class ClubCampCallSocketHandler extends BaseSocketHandler
	{
		public function ClubCampCallSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var isSuccessful:Boolean  = _data.readBoolean();
			var errorCode:int = _data.readInt();
			if(isSuccessful)
			{
				QuickTips.show('操作成功');
			}
			else
			{
				switch(errorCode)
				{
					case 41 :
						MAlert.show('必须在帮会营地中。是否进入帮会营地？' ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
						break;
					case 51 :
						QuickTips.show('权限不足。');
						break;
					case 61 :
						QuickTips.show('帮会财富不足。');
						break;
					case 62 :
						QuickTips.show('帮会等级不够。');
						break;
					case 21095 :
						QuickTips.show('无法开启，请过一段时间之后再试。');
						break;
					case 21096 :
						QuickTips.show('剩余次数为0。');
						break;
				}
			}
			
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					ClubCampEnterSocketHandler.send();
				}
			}
//			var id:int = _data.readInt();
//			var type:int;
//			if(ClubCampCallTemplateList.getBoss(id))
//			{
//				type = ClubCampCallType.BOSS
//			}
//			else
//			{
//				type = ClubCampCallType.COLLECTION
//			}
//			
//			if(isSuccessful)
//			{
//				if(type == ClubCampCallType.BOSS)
//				{
//					clubModule.clubCampInfo.lastCalledClubBossId = id;
//				}
//				else if(type == ClubCampCallType.COLLECTION)
//				{
//					clubModule.clubCampInfo.lastCalledClubCollectionId = id;
//				}
//					
//			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_SUMMON;
		}
		
		public function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_SUMMON);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}