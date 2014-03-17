package sszt.core.socketHandlers.personal.dynamicInfo
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.personal.PersonalDynamicType;
	import sszt.core.data.personal.item.PersonalDynamicItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PersonalFriendTaskShareSocketHandler extends BaseSocketHandler
	{
		public function PersonalFriendTaskShareSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_FRIEND_TASK_SHARE;
		}
		
		override public function handlePackage():void
		{
			var tmpItemInfo:PersonalDynamicItemInfo = new PersonalDynamicItemInfo();
			tmpItemInfo.typeId = PersonalDynamicType.FRIEND_TASK_SHARE;
			tmpItemInfo.userId = _data.readNumber();
			tmpItemInfo.name = _data.readString();
			tmpItemInfo.parm1 = _data.readInt();
			tmpItemInfo.parm5 = _data.readString();
			GlobalData.personalInfo.personalFriendInfo.addToList(tmpItemInfo);
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_FRIEND_TASK_SHARE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}