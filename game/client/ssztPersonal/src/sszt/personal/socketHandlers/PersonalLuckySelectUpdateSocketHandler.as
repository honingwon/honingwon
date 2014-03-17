package sszt.personal.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.personal.PersonalModule;
	
	public class PersonalLuckySelectUpdateSocketHandler extends BaseSocketHandler
	{
		public function PersonalLuckySelectUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_LUCKY_SELECTINFO;
		}
		override public function handlePackage():void
		{
			module.personalInfoList[GlobalData.selfPlayer.userId].personalPartLuckyInfo.selectTemplateId = _data.readInt();
			module.personalInfoList[GlobalData.selfPlayer.userId].personalPartLuckyInfo.updateSelect();
			handComplete()
		}
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_LUCKY_SELECTINFO);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get module():PersonalModule
		{
			return _handlerData as PersonalModule;
		}
	}
}