package sszt.core.socketHandlers.role
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.titles.TitleNameEvents;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class RoleNameSaveSocketHandler extends BaseSocketHandler
	{
		public function RoleNameSaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var result:Boolean = _data.readBoolean();
			if(result)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.saveSuccess"));
				
				GlobalData.selfPlayer.updateRoleTitle(_data.readInt(),_data.readBoolean());
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.saveFail"));	
			}
			handComplete();
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_CHOOSE_TITLE;
		}
		
		public static function sendSave(argTitleId:int,argIsHide:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_CHOOSE_TITLE);
			pkg.writeInt(argTitleId);
			pkg.writeBoolean(argIsHide);
			GlobalAPI.socketManager.send(pkg);
		}
			
	}
}