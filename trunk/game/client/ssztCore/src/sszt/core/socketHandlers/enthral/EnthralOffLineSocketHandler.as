package sszt.core.socketHandlers.enthral
{
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.enthral.EAlert;
	import sszt.events.EnthralModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class EnthralOffLineSocketHandler extends BaseSocketHandler
	{
		public function EnthralOffLineSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ENTHRAL_OFF_LINE;
		}
		
		override public function handlePackage():void
		{
			var flag:int = _data.readByte();
			if(GlobalData.enthralType != 1)
			{
				if(flag == 1)
				{
					var alert:MAlert = MAlert.show(LanguageManager.getWord("ssztl.core.downLineLess5"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null,alertHandler,"center",-1,false);
					alert.setEscHandler(null);
				}
				else if(flag == 2)
				{
					if(GlobalData.isEnthralPanel == false)
					{
						GlobalData.isEnthralPanel = true;
						EAlert.show(LanguageManager.getWord("ssztl.core.inUnHealthTime"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK,null,offCloseHandler,"center",-1,false);
					}				
				}
			}
			
			handComplete();
		}
		
		private function alertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoPage(GlobalAPI.pathManager.getOfficalPath(),true);
			}
		}
		private function offCloseHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoPage(GlobalAPI.pathManager.getOfficalPath(),true);
			}
		}		
	}
}