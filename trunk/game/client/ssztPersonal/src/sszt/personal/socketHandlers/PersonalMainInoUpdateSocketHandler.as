package sszt.personal.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.personal.PersonalMyInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.personal.PersonalModule;
	import sszt.personal.data.PersonalPartInfo;
	
	public class PersonalMainInoUpdateSocketHandler extends BaseSocketHandler
	{
		public function PersonalMainInoUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_MAININFO;
		}
		
		override public function handlePackage():void
		{
			var userId:Number =  _data.readNumber();
			var info:PersonalMyInfo = module.personalInfoList[userId].personaOtherMainInfo;
			info.serverId = _data.readShort();
			info.userId = userId;
			info.nick = _data.readString();
			info.starId = _data.readInt();
			info.provinceId = _data.readInt();
			info.cityId = _data.readInt();
			info.mood = _data.readString();
			info.introduce = _data.readString();
			info.winNum = _data.readInt();
			info.failNum = _data.readInt();
			info.isCanGetRewards = _data.readBoolean();
			info.headIndex = _data.readInt();
			info.oldIndex = info.headIndex;
			info.update();
			handComplete();
		}
		
		public static function send(userId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_MAININFO);
			pkg.writeNumber(userId);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get module():PersonalModule
		{
			return _handlerData as PersonalModule;
		}
	}
}