package sszt.activity.socketHandlers
{
	import sszt.activity.ActivityModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.activity.WelfareTemplateInfoList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PlayerActivyCollectSocketHandler extends BaseSocketHandler
	{
		public function PlayerActivyCollectSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_ACTIVY_COLLECT;
		}
		
		override public function handlePackage():void
		{
			var id:int = _data.readInt();
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.activity.getGiftSuccess"));
				if(module.codePanel) module.codePanel.dispose();
				module.activityInfo.changeState(id,true);
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.activity.activationNoError"));
			}
			handComplete();
		}
		
		private function get module():ActivityModule
		{
			return _handlerData as ActivityModule;
		}
		
		public static function send(id:int,code:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PLAYER_ACTIVY_COLLECT);
			pkg.writeInt(id);
			pkg.writeString(code);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}