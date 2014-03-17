package sszt.core.socketHandlers.personal.dynamicInfo
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.personal.PersonalDynamicType;
	import sszt.core.data.personal.item.PersonalDynamicItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PersonalFriendDeadSocketHandler extends BaseSocketHandler
	{
		public function PersonalFriendDeadSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_FRIEND_DEAD;
		}
		
		override public function handlePackage():void
		{
			var tmpItemInfo:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
			tmpItemInfo.typeId = PersonalDynamicType.FRIEND_DEAD;
			tmpItemInfo.userId = _data.readNumber();
			tmpItemInfo.name = _data.readString();
			tmpItemInfo.parm1 = _data.readNumber();
			tmpItemInfo.parm5 = _data.readString();
			tmpItemInfo.parm2 = _data.readInt();
			tmpItemInfo.parm3 = _data.readInt();
			tmpItemInfo.parm4 = _data.readInt();
			GlobalData.personalInfo.personalFriendInfo.addToList(tmpItemInfo);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_FRIEND_DEAD);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}