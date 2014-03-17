package sszt.scene.socketHandlers.duplicate
{
	import mx.events.ModuleEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class CopyPassSocketHandler extends BaseSocketHandler
	{
		public function CopyPassSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		override public function getCode():int
		{
			return ProtocolType.COPY_PASS;
		}
		
		override public function handlePackage():void
		{
			var mapId:int = _data.readInt();
			var copyType:int = _data.readInt();
			var passState:int = _data.readInt();
			if(MapTemplateList.isPassDuplicate(mapId))
				sceneModule.duplicatePassInfo.updateAward();
			if(passState == 1)//副本通关
			{
				MAlert.show(LanguageManager.getWord("ssztl.scene.copyPass"),"", MAlert.OK|MAlert.CANCEL, null,leveCopy);
			}
			
			var task:TaskItemInfo = GlobalData.taskInfo.getTask(551009);
			if(task && !task.isFinish && mapId == 4200604)
			{
//				MAlert.show(LanguageManager.getWord("ssztl.scene.copyTaskFinish"),"", MAlert.OK|MAlert.CANCEL, null,leveCopy);
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.DUPLICATE_TASK_PROMPT));
			}
			
			handComplete();
		}
		private function leveCopy(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				CopyLeaveSocketHandler.send();
			}
		}
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}