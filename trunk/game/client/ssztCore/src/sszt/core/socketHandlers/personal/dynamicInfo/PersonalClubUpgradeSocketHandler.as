package sszt.core.socketHandlers.personal.dynamicInfo
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.personal.PersonalDynamicType;
	import sszt.core.data.personal.item.PersonalDynamicItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PersonalClubUpgradeSocketHandler extends BaseSocketHandler
	{
		public function PersonalClubUpgradeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_CLUB_UPGRADE;
		}
		
		override public function handlePackage():void
		{
			var tmpItemInfo:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
			tmpItemInfo.typeId = PersonalDynamicType.CLUB_UPGRADE;
			tmpItemInfo.parm1 = _data.readInt();
			GlobalData.personalInfo.personalClubInfo.addToList(tmpItemInfo);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_CLUB_UPGRADE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}