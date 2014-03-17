package sszt.swordsman.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.SwordsmanMediaEvents;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.swordsman.SwordsmanModule;
	
	/**
	 * 发布江湖令任务 
	 * @author chendong
	 * 
	 */	
	public class TaskPublishSocketHandler extends BaseSocketHandler
	{
		public function TaskPublishSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TOKEN_TASK_PUBLISH;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
//			ModuleEventDispatcher.dispatchModuleEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.UPDATE_PUBLISH));
			QuickTips.show(LanguageManager.getWord("ssztl.swordsMan.releaseSwordsmanSuc"));
		}
		
		public function get swordsmanModule():SwordsmanModule
		{
			return _handlerData as SwordsmanModule;
		}
		
		/**
		 *  
		 * @param type 1:绿，2：蓝，3：紫，4：橙
		 */		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TOKEN_TASK_PUBLISH);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}