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
	 * 接受江湖令任务 
	 * @author chendong
	 * 
	 */	
	public class TaskAcceptSocketHandler extends BaseSocketHandler
	{
		public function TaskAcceptSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.TOKEN_TASK_ACCEPT;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			if(_data.readBoolean())
			{
				//接受江湖令成功
				ModuleEventDispatcher.dispatchModuleEvent(new SwordsmanMediaEvents(SwordsmanMediaEvents.TOKEN_TASK_ACCEPT));
				QuickTips.show(LanguageManager.getWord("ssztl.swordsMan.getSwordsmanSuc"));
			}
			else
			{
				//失败
				QuickTips.show(LanguageManager.getWord("ssztl.swordsMan.youHaveNoComplateSwordsman"));
			}
			handComplete();
		}
		
		public function get swordsmanModule():SwordsmanModule
		{
			return _handlerData as SwordsmanModule;
		}
		
		/**
		 *  
		 * @param type 1:绿，2：蓝，3：紫，4：橙
		 */		
		public static function sendType(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TOKEN_TASK_ACCEPT);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}