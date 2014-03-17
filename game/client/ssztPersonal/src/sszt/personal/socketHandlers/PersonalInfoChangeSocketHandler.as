package sszt.personal.socketHandlers
{
	import flash.filters.GlowFilter;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.personal.PersonalModule;
	
	public class PersonalInfoChangeSocketHandler extends BaseSocketHandler
	{
		public function PersonalInfoChangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERSONAL_INFO_CHANGE;
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
//				QuickTips.show("修改成功！");
				QuickTips.show(LanguageManager.getWord("ssztl.common.changeSuccess"));
			}
			else
			{
//				QuickTips.show("修改失败 !");
				QuickTips.show(LanguageManager.getWord("ssztl.common.changeFail"));
			}
		}
		
		public static function send(argStarId:int,argProvinceId:int,argCityId:int,argMood:String,argIntroduce:String,argHeadIndex:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERSONAL_INFO_CHANGE);
			pkg.writeInt(argStarId);
			pkg.writeInt(argProvinceId);
			pkg.writeInt(argCityId);
			pkg.writeString(argMood);
			pkg.writeString(argIntroduce);
			pkg.writeInt(argHeadIndex);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get module():PersonalModule
		{
			return _handlerData as PersonalModule;
		}
	}
}