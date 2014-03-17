package sszt.scene.data.roles
{
	import flash.events.Event;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.MapElementInfo;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	
	public class NpcRoleInfo extends BaseRoleInfo
	{
		public static const UPDTAE_STATE:String = "updateState";
		
		public var template:NpcTemplateInfo;
		/**
		 * NPC任务状态 0:没有任务
		 * 		      1:有任务可提交
		 * 		      2:有任务可接
		 * 		      3:有任务没完成
		 */		
		private var _taskState:int;
		public function get taskState():int
		{
			return _taskState;
		}
		public function set taskState(value:int):void
		{
			if(_taskState == value)return;
			_taskState = value;
			dispatchEvent(new Event(UPDTAE_STATE));
		}
		
		public function NpcRoleInfo(info:NpcTemplateInfo)
		{
			template = info;
			super(null);
		}
		
		override public function get sceneX():Number
		{
			return template.sceneX;
		}
		
		override public function get sceneY():Number
		{
			return template.sceneY;
		}
		
		public function getScene():int
		{
			return template.sceneId;
		}
		
		override public function getObjId():Number
		{
			return template.templateId;
		}
		override public function getObjType():int
		{
			return MapElementType.NPC;
		}
		
		override public function getName():String
		{
			return template.name;
		}
		
		public function checkNotSubmitTask():void
		{
//			var notSubmit:Vector.<Vector.<TaskItemInfo>> = GlobalData.taskInfo.getTaskNoSubmitByNpcId(template.templateId);
			var notSubmit:Array = GlobalData.taskInfo.getTaskNoSubmitByNpcId(template.templateId);
			if(notSubmit[0].length > 0)taskState = 1;
			else if(notSubmit[1].length > 0)
			{
				if(checkCanAcceptTask())taskState = 3;
			}
			else taskState = 0;
		}
		
		public function checkCanAcceptTask():Boolean
		{
//			var canAccepts:Vector.<TaskTemplateInfo> = TaskTemplateList.getCanAcceptTaskByNpcId(template.templateId);
			var canAccepts:Array = TaskTemplateList.getCanAcceptTaskByNpcId(template.templateId);
			if(canAccepts.length > 0)
			{
				taskState = 2;
				return false;
			}
			taskState = 0;
			return true;
		}
	}
}