package sszt.personal.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.personal.PersonalModule;
	
	public class PersonalLuckyListUpdateSocketHandler extends BaseSocketHandler
	{
		public function PersonalLuckyListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_LUCKY_LISTINFO;
		}
		override public function handlePackage():void
		{
			var tmpList:Array = [];
			var len:int = _data.readInt();
			for(var i:int = 0;i <len;i++)
			{
				tmpList.push(_data.readInt());
			}
			module.personalInfoList[GlobalData.selfPlayer.userId].personalPartLuckyInfo.luckyTemplateIdList = tmpList;
			module.personalInfoList[GlobalData.selfPlayer.userId].personalPartLuckyInfo.updateLuckyList();
			handComplete()
		}
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_LUCKY_LISTINFO);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get module():PersonalModule
		{
			return _handlerData as PersonalModule;
		}
	}
}