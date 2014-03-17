package sszt.core.socketHandlers.role
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.prompt.TitleGuidePanel;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class FirstRoleTitleSocketHandler extends BaseSocketHandler
	{
		public function FirstRoleTitleSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_FIRST_TITLE;
		}
		
		override public function handlePackage():void
		{
			var len:int;
			var id:int = _data.readInt();
			
			TitleGuidePanel.getInstance().show(id);
			
//			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.FIRST_ROLE_TITLE));
			
			
		}
	}
}