package sszt.core.socketHandlers.enthral
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.enthral.EnthralPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.EnthralModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class EnthralSubmitSocketHandler extends BaseSocketHandler
	{
		public function EnthralSubmitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ENTHRAL_SUBMIT;
		}
		
		override public function handlePackage():void
		{
			var value:Boolean = _data.readBoolean();
			if(value)
			{
				var type:int = _data.readByte();
				if(type == 1)
				{
					MAlert.show(LanguageManager.getWord("ssztl.core.passEnthral"),LanguageManager.getWord("ssztl.common.alertTitle"));
				}else if(type == 2)
				{
					MAlert.show(LanguageManager.getWord("ssztl.core.noAchieve18"),LanguageManager.getWord("ssztl.common.alertTitle"));
				}
				GlobalData.isEnthral = true;
				ModuleEventDispatcher.dispatchEnthralEvent(new EnthralModuleEvent(EnthralModuleEvent.REMOVE_ENTHRAL_ICON));
				
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.nameMsgError"));
				EnthralPanel.getInstance().show();
			}
			
			handComplete();
		}
		
		public static function sendSubmit(name:String,id:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ENTHRAL_SUBMIT);
			pkg.writeString(name);
			pkg.writeString(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}