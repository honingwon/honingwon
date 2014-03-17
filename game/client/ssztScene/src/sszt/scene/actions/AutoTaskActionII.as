package  sszt.scene.actions
{
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    
    import sszt.constData.LayerIndex;
    import sszt.core.data.GlobalAPI;
    import sszt.core.data.GlobalData;
    import sszt.core.data.deploys.DeployItemInfo;
    import sszt.core.data.npc.NpcTemplateList;
    import sszt.core.data.task.TaskConditionType;
    import sszt.core.data.task.TaskItemInfo;
    import sszt.core.data.task.TaskListUpdateEvent;
    import sszt.core.data.task.TaskStateType;
    import sszt.core.data.task.TaskTemplateInfo;
    import sszt.core.data.task.TaskTemplateList;
    import sszt.events.SceneModuleEvent;
    import sszt.events.TaskModuleEvent;
    import sszt.interfaces.scene.IScene;
    import sszt.interfaces.tick.ITick;
    import sszt.module.ModuleEventDispatcher;
    import sszt.scene.checks.WalkChecker;
    import sszt.scene.mediators.SceneMediator;

    public class AutoTaskActionII extends Object implements ITick
    {
        private var _scene:IScene;
        private var _mediator:SceneMediator;
        private var _checkTime:int;
        private var _clickTime:Number = 0;
        private var _running:Boolean;
        private var _currentTask:TaskItemInfo;
        private var _monsterPonintVec:Array;
        private var _targetPoint:Point;
        private var _endPoint:Point;
        private var _targetId:int;
        private var _targetType:int;
        private var _path:Array;
        private var _currentDeploy:DeployItemInfo;

        public function AutoTaskActionII()
        {
        }

        public function setup(sc:IScene, mediator:SceneMediator) : void
        {
            _scene = sc;
            _mediator = mediator;
            ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.AUTO_TASK_INIT, onAutoTaskInit);
            ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.AUTO_TASK_START, onAutoTaskStart);
            ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.AUTO_TASK_DISPOSE, onAutoTaskDispose);
        }

        private function removeEvents() : void
        {
            _scene.getViewPort().getLayerContainer(LayerIndex.MAPLAYER).removeEventListener(MouseEvent.CLICK, clickHandler);
            ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_CHECKSTATE, onTaskStateUpdate);
            GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.REMOVE_TASK, onTaskRemoveHandler);
            ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.AUTO_TASK_INIT, onAutoTaskInit);
            ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.AUTO_TASK_STOP, onAutoTaskStop);
            ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.AUTO_TASK_DISPOSE, onAutoTaskDispose);
        }

        private function initEvents() : void
        {
            _scene.getViewPort().getLayerContainer(LayerIndex.MAPLAYER).addEventListener(MouseEvent.CLICK, clickHandler, false, -1);
            ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_CHECKSTATE, onTaskStateUpdate);
            GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.REMOVE_TASK, onTaskRemoveHandler);
            ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.AUTO_TASK_STOP, onAutoTaskStop);
        }

        private function onTaskStateUpdate(event:TaskModuleEvent) : void
        {
            testCurrentState();
        }

        protected function onTaskRemoveHandler(event:TaskListUpdateEvent) : void
        {
            var taskTemplate:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(parseInt(event.data.toString()));
            if (taskTemplate && taskTemplate.isAutoTask)
            {
                onAutoTaskDispose(null);
            }
        }

        private function onAutoTaskDispose(event:SceneModuleEvent) : void
        {
            _running = false;
            dispose();
        }

        private function onAutoTaskInit(event:SceneModuleEvent) : void
        {
            var id:int = int(event.data);
            startup(id, false);
//            ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.AUTO_TASK_DISPOSE, this.onAutoTaskDispose);
        }

        private function onAutoTaskStart(event:SceneModuleEvent) : void
        {
            var id:int = int(event.data);
            startup(id, true);
        }

        private function startup(taskId:int, running:Boolean = true) : void
        {
            initEvents();
            _running = running;
            GlobalAPI.tickManager.addTick(this);
            _currentTask = GlobalData.taskInfo.getTaskByTemplateId(taskId);
            testCurrentState();
        }

        private function onAutoTaskStop(event:SceneModuleEvent = null) : void
        {
            _checkTime = 0;
            _running = false;
            GlobalData.selfPlayer.sceneTaskTarget = null;
        }

        private function testCurrentState() : void
        {
            var deployInfo:DeployItemInfo = null;
            var taskTemplateInfo:TaskTemplateInfo = this._currentTask.template;
            var condition:int = taskTemplateInfo.getLastState().condition;
            _currentDeploy = null;
            _monsterPonintVec = null;
            if (_currentTask.taskState == TaskStateType.ACCEPTNOTFINISH)
            {
                if (TaskConditionType.getIsCollectItemTask(condition))
                {
                    if (taskTemplateInfo.getLastState().data[0])
                    {
                        _targetId = taskTemplateInfo.getLastState().data[0][0];
                        _targetType = 2;
                        _targetPoint = taskTemplateInfo.getLastState().getTargetPos(0);
                    }
                }
                else if (TaskConditionType.getIsKillMonster(condition))
                {
                    if (taskTemplateInfo.getLastState().data[0])
                    {
                        _targetId = taskTemplateInfo.getLastState().data[0][0];
                        _targetType = 3;
                        _targetPoint = taskTemplateInfo.getLastState().getTargetPos(0);
                    }
                }
            }
            else if (this._currentTask.taskState == TaskStateType.FINISHNOTSUBMIT)
            {
                _targetId = taskTemplateInfo.getLastState().npc;
                _targetType = 1;
                _targetPoint = new Point(NpcTemplateList.getNpc(this._targetId).sceneX, NpcTemplateList.getNpc(this._targetId).sceneY);
            }
            else
            {
                onAutoTaskDispose(null);
            }
        }

        protected function clickHandler(event:MouseEvent) : void
        {
            _checkTime = 0;
			var t:int = getTimer();
            if (t - _clickTime <= 300)
            {
                _running = false;
            }
            _clickTime =t;
        }

        public function update(times:int, dt:Number = 0.04) : void
        {
            function handler() : void
            {
                if (_targetId == 0)
                {
                    return;
                }
                GlobalData.selfScenePlayerInfo.state.setFindPath(true);
                switch(_targetType)
                {
                    case 1:
                    {
                        _mediator.walkToNpc(_targetId);
                        break;
                    }
                    case 2:
                    {
						WalkChecker.doWalkToCenterCollect(_targetId);
                        break;
                    }
                    case 3:
                    {
                        _mediator.walkToHangup(_targetId);
//						autoTaskPause();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                return;
            }
            ;
            if (this._mediator.sceneInfo.playerList.self && this._mediator.sceneInfo.playerList.self.getIsHangup())
            {
                autoTaskPause();
                return;
            }
//            if (!GlobalData.copyEnterCountList.isInCopy)
//            {
//            }
//            if (!MapTemplateList.isSpaMap(GlobalData.currentMapId))
//            {
//                MapTemplateList.isSpaMap(GlobalData.currentMapId);
//            }
//            if (!MapTemplateList.isVipMap(GlobalData.currentMapId))
//            {
//                MapTemplateList.isVipMap(GlobalData.currentMapId);
//            }
//            if (CopyTemplateList.isWarFieldMap(GlobalData.copyEnterCountList.inCopyId))
//            {
//                this.clear();
//                return;
//            }
            if (_running)
            {
				_checkTime = _checkTime + 1;
                if (_checkTime % 20 == 0)
                {
                    _checkTime = 0;
                    if (!isTargetPoint())
                    {
                        handler();
                    }
                }
            }
            else if (this.isTargetPoint())
            {
                _running = true;
                _checkTime = 0;
            }
        }

        public function autoTaskPause() : void
        {
            onAutoTaskStop(null);
        }

        private function isTargetPoint() : Boolean
        {
            var point:Point = GlobalData.selfPlayer.sceneTaskTarget;
			
            if (_targetPoint && point &&  point.x == _targetPoint.x && point.y == _targetPoint.y)
            {
                return true;
            }
            return false;
        }

        private function clear() : void
        {
            _targetPoint = null;
            _monsterPonintVec = null;
            _targetId = 0;
            _targetType = 0;
        }

        public function dispose() : void
        {
            GlobalAPI.tickManager.removeTick(this);
            removeEvents();
            clear();
        }

    }
}
