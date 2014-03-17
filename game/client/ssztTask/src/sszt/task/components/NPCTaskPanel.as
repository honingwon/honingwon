package sszt.task.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateType;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.task.components.items.NpcTaskAcceptView;
	import sszt.task.components.items.NpcTaskSubmitView;
	import sszt.task.mediators.TaskMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MNPCPanel;
	import sszt.ui.container.MScrollPanel;
	
	public class NPCTaskPanel extends MNPCPanel
	{
		public static const CONTENT_RECT:Rectangle = new Rectangle(159,16,364,171);
		
		private var _mediator:TaskMediator;
		private var _data:Object;
		private var _taskId:int;
		private var _npcInfo:NpcTemplateInfo;
		
		private var _content:MScrollPanel;
		private var _npcAvatar:Bitmap;
		private var _picPath:String;
		
		/**
		 * @param obj 包含任务ID和NPC ID数据
		 */
		public function NPCTaskPanel(mediator:TaskMediator, data:Object)
		{
			_data = data;
			_mediator = mediator;
			
			_taskId = _data.taskId;
			_npcInfo = NpcTemplateList.getNpc(_data.npcId);
			
			super(_npcInfo.name);
			
			createAvatar();
			
			setTaskId();
		}
		
		private function createAvatar():void
		{
			_npcAvatar = new Bitmap();
			_npcAvatar.x = -51;
			_npcAvatar.y = -54;
			_imageLayout.addChild(_npcAvatar);
			
			_picPath = GlobalAPI.pathManager.getSceneNpcAvatarPath(_npcInfo.iconPath);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.CHANGE_SCENE);
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_npcAvatar.bitmapData = data;
		}		
		
		public function setTaskId():void
		{
			//在已接受任务中查找
			var task:TaskItemInfo = GlobalData.taskInfo.getTaskExist(_taskId);
			if(_content)
			{
				_content.dispose();
				_content = null;
			}
			//任务未接受，显示接受信息
			if(task == null )
			{
				_content = initTaskAccept(TaskTemplateList.getTaskTemplate(_taskId)) as MScrollPanel;
			}
			//任务已接受，显示提交信息
			else
			{
				if(task.taskState == TaskStateType.FINISHNOTSUBMIT || task.taskState == TaskStateType.ACCEPTNOTFINISH )
				{
					_content = initTaskSubmit(task) as MScrollPanel;
				}
				else if (task.getCanAccept() )
				{
					_content = initTaskAccept(TaskTemplateList.getTaskTemplate(_taskId)) as MScrollPanel;
				}
					
			}
			_content.move(CONTENT_RECT.x, CONTENT_RECT.y);
			addChild(_content);
			
			GlobalData.selfScenePlayerInfo.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
		}
		
		private function initTaskSubmit(info:TaskItemInfo):NpcTaskSubmitView
		{
			return new NpcTaskSubmitView(info,_mediator);
		}
		
		private function initTaskAccept(info:TaskTemplateInfo):NpcTaskAcceptView
		{
			return new NpcTaskAcceptView(info,_mediator);
		}
		
		private function selfMoveHandler(e:BaseSceneObjInfoUpdateEvent):void
		{
			var selfInfo:BaseSceneObjInfo = e.currentTarget as BaseSceneObjInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				_mediator.closeNpcTaskPanel();
		}
		
		override public function dispose():void
		{
			super.dispose();
			GlobalData.selfScenePlayerInfo.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			_picPath = null;
			_npcAvatar = null;
			if(_content)
			{
				_content.dispose();
				_content = null;
			}
			_mediator = null;
		}
	}
}