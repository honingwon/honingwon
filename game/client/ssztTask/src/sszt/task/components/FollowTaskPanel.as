package sszt.task.components
{
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskListUpdateEvent;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.data.task.TaskType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.task.components.sec.TaskFollow.TaskFollowGroup;
	import sszt.task.events.TaskInnerEvent;
	import sszt.task.mediators.TaskMediator;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	
	import ssztui.task.FollowPanelBgAsset;
	import ssztui.task.FollowPanelHideAsset;
	import ssztui.task.FollowPanelShowAsset;
	import ssztui.task.FollowPanelTitleDragAsset;
	
	public class FollowTaskPanel extends MSprite
	{
		public static const DEFAULT_WIDTH:int = 267;
		public static const DEFAULT_HEIGHT:int = 200;
		public static const DEFAULT_X:int = CommonConfig.GAME_WIDTH - DEFAULT_WIDTH;
		public static const DEFAULT_Y:int = 190;
		
		private var _mediator:TaskMediator;
		
		private var _labels:Array;
		private var _btns:Array;
		private var _list:Array;
		private var _isBigSize:Boolean;
		private var _currentHeight:int;
		private var _listSelecteds:Dictionary;
		private var _acceptSelecteds:Dictionary;
		
		private var _container:Sprite;
		private var _container2:Sprite;
		private var _bg:Bitmap;
		private var _dragBtn:MAssetButton1;
//		private var _dragBtnAsset:Bitmap;
		private var _minimizeBtn:MAssetButton1;
		private var _maximizeBtn:MAssetButton1;
		private var _showTaskMainPanelBtn:MCacheTabBtn1;
		private var _listView:MScrollPanel;
		private var _currentBtn:MCacheTabBtn1;
//		private var _resetBtn:MBitmapButton;
//		private var _setsizeBtn:MSelectButton;
		
		public function FollowTaskPanel(mediator:TaskMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			//面板紧靠界面右边界
			x = DEFAULT_X;
			y = DEFAULT_Y;
			
			_isBigSize = false;
			mouseEnabled = false;
			
			_container = new Sprite();
			addChild(_container);
			_container2 = new Sprite();
			addChild(_container2);
			_container.mouseEnabled = _container2.mouseEnabled = false;
			_container2.visible = false;
			
			_bg = new Bitmap(new FollowPanelBgAsset);
			_bg.width = 267;
			_bg.x = _bg.y = 0;
			_container.addChild(_bg);
			
			_dragBtn = new MAssetButton1(new FollowPanelTitleDragAsset() as MovieClip);
//			_dragBtnAsset = new Bitmap(new FollowPanelTitleDragAsset);
//			_dragBtn.addChild(_dragBtnAsset);
			_dragBtn.move(1,1);
			_dragBtn.buttonMode = true;
			_dragBtn.tabEnabled = false;
			_container.addChild(_dragBtn);
			
			_minimizeBtn = new MAssetButton1(FollowPanelHideAsset);
			_minimizeBtn.move(244,1);
			_container.addChild(_minimizeBtn);
			
			_maximizeBtn = new MAssetButton1(FollowPanelShowAsset);
			_maximizeBtn.move(244,1);
			_container2.addChild(_maximizeBtn);
			
			_labels = [LanguageManager.getWord("ssztl.task.taskFollow"), LanguageManager.getWord("ssztl.task.acceptableTask")];
			var poses:Array = [new Point(73, 1),new Point(158, 1)];
			_btns = [];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(1, 1, _labels[i]);
				btn.width = 86;
				btn.move(poses[i].x,poses[i].y);
				_container.addChild(btn);
				_btns.push(btn);
			}
			_currentBtn = _btns[0];
			_currentBtn.selected = true;
			
			_showTaskMainPanelBtn = new MCacheTabBtn1(1,0,LanguageManager.getWord("ssztl.common.all"));
			_showTaskMainPanelBtn.width = 50;
			_showTaskMainPanelBtn.move(23, 1);
			_container.addChild(_showTaskMainPanelBtn);
			
			_list = new Array(TaskType.getTaskTypes().length);
			_listView = new MScrollPanel();
			_listView.mouseEnabled = _listView.getContainer().mouseEnabled = false;
			_listView.move(4,28);
			_listView.setSize(262,170);
			_listView.horizontalScrollPolicy = "off";
			_listView.verticalScrollPolicy = "auto";
			_listView.update();
			_container.addChild(_listView);
			_currentHeight = 0;
			
			for(var j:int = 0; j < TaskType.getTaskTypes().length; j++)
			{
				if(_listSelecteds == null)_listSelecteds = new Dictionary();
				_listSelecteds[TaskType.getTaskTypes()[j]] = true;
				if(_acceptSelecteds == null)_acceptSelecteds = new Dictionary();
				_acceptSelecteds[TaskType.getTaskTypes()[j]] = true;
			}
			
			createItems();
			
			setGuideTipHandler(null);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,tabBtnClickHandler);
			}
			_dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,dragBtnDownHandler);
//			_setsizeBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
//			_resetBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_minimizeBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_maximizeBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_showTaskMainPanelBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_dragBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
//			_setsizeBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
//			_resetBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_minimizeBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_maximizeBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_showTaskMainPanelBtn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_dragBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
//			_setsizeBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
//			_resetBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			_minimizeBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			_maximizeBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			_showTaskMainPanelBtn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.MOUSE_UP,dragStopHandler);
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.ADD_TASK,addTaskHandler);
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.REMOVE_TASK,removeTaskHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_FINISH,updateListHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ADD,taskAddHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.UPDATE_CLUB_TASK,updateListHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,updateListHandler);
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_STATE_UPDATE,updateListHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,tabBtnClickHandler);
			}
			_dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,dragBtnDownHandler);
//			_setsizeBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
//			_resetBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_minimizeBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_maximizeBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_dragBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
//			_setsizeBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
//			_resetBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_minimizeBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_maximizeBtn.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			_dragBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
//			_setsizeBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
//			_resetBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			_minimizeBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			_maximizeBtn.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.MOUSE_UP,dragStopHandler);
			GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.ADD_TASK,addTaskHandler);
			GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.REMOVE_TASK,removeTaskHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_FINISH,updateListHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ADD,taskAddHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.UPDATE_CLUB_TASK,updateListHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,updateListHandler);
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_STATE_UPDATE,updateListHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPGRADE,upgradeHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			if(_container.visible == true)
			{
				x = CommonConfig.GAME_WIDTH - DEFAULT_WIDTH;
				if(GlobalData.guideTipInfo != null)
				{
					var info:DeployItemInfo = GlobalData.guideTipInfo;
					if(info.param1 == GuideTipDeployType.ACCEPT_TASK_BTN)
					{
						GuideTip.getInstance().show(info.descript,info.param2,new Point(CommonConfig.GAME_WIDTH - info.param3,info.param4),GlobalAPI.layerManager.getTipLayer().addChild);
					}
				}
				
				if(CommonConfig.GAME_HEIGHT < 600)_isBigSize = false;
				else _isBigSize = true;
//				_setsizeBtn.selected = _isBigSize;
				if(_isBigSize)
				{
//					_shape.graphics.clear();
//					_shape.graphics.beginFill(0,0.6);
//					_shape.graphics.drawRect(0,0,200,250);
//					_shape.graphics.endFill();
//					_listView.setSize(218,237);
					_listView.update();
//					_setsizeBtn.y = 267;
				}
				else
				{
//					_shape.graphics.clear();
//					_shape.graphics.beginFill(0,0.6);
//					_shape.graphics.drawRect(0,0,200,141);
//					_shape.graphics.endFill();
//					_listView.setSize(218,130);
					_listView.update();
//					_setsizeBtn.y = 161;
				}
			}
			else if(_container2.visible == true)
			{
				x = CommonConfig.GAME_WIDTH - DEFAULT_WIDTH;
			}
		}
		
		private function tabBtnClickHandler(e:MouseEvent):void
		{
			if(_currentBtn == (e.currentTarget as MCacheTabBtn1))return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
			if(index == 1 && GlobalData.guideTipInfo && GlobalData.guideTipInfo.param1 == GuideTipDeployType.ACCEPT_TASK_BTN)
			{
				GuideTip.getInstance().hide();
			}
		}
		
		public function setIndex(index:int):void
		{
			if(_currentBtn)_currentBtn.selected = false;
			_currentBtn = _btns[index];
			_currentBtn.selected = true;
			createItems();
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.TASK_FOLLOW));
		}
		
		private function dragBtnDownHandler(e:MouseEvent):void
		{
			this.startDrag(false,new Rectangle(0,0,CommonConfig.GAME_WIDTH - DEFAULT_WIDTH, CommonConfig.GAME_HEIGHT - this.height));
		}
		
		private function dragStopHandler(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			switch(e.currentTarget)
			{
//				case _resetBtn:
//					this.x = CommonConfig.GAME_WIDTH - 230;
//					this.y = 216;
//					break;
				case _minimizeBtn:
					hide();
					break;
				case _maximizeBtn:
					show();
					break;
//				case _setsizeBtn:
//					_isBigSize = !_isBigSize;
//					_setsizeBtn.selected = _isBigSize;
//					if(_isBigSize)
//					{
//						_shape.graphics.clear();
//						_shape.graphics.beginFill(0,0.6);
//						_shape.graphics.drawRect(0,0,200,250);
//						_shape.graphics.endFill();
//						_listView.setSize(218,237);
//						_listView.update();
//						_setsizeBtn.y = 267;
//					}
//					else
//					{
//						_shape.graphics.clear();
//						_shape.graphics.beginFill(0,0.6);
//						_shape.graphics.drawRect(0,0,200,141);
//						_shape.graphics.endFill();
//						_listView.setSize(218,130);
//						_listView.update();
//						_setsizeBtn.y = 161;
//					}
//					break;
				case _showTaskMainPanelBtn:
					_mediator.showMainPanel();
					break;
			}
		}
		
		private function btnOverHandler(e:MouseEvent):void
		{
			var str:String;
			switch(e.currentTarget)
			{
//				case _setsizeBtn:
//					str = _isBigSize ? LanguageManager.getWord("ssztl.task.followTaskTip1") : LanguageManager.getWord("ssztl.task.followTaskTip2") ;
//					break;
//				case _resetBtn:
//					str = LanguageManager.getWord("ssztl.task.followTaskTip3");
//					break;
				case _minimizeBtn:
					str = LanguageManager.getWord("ssztl.task.followTaskTip4");
					break;
				case _maximizeBtn:
					str = LanguageManager.getWord("ssztl.task.followTaskTip5");
					break;
				case _dragBtn:
					str = LanguageManager.getWord("ssztl.task.followTaskTip6");
					break;
				case _showTaskMainPanelBtn:
					str = LanguageManager.getWord("ssztl.task.followTaskTip7");
			}
			TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function btnOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function addTaskHandler(e:TaskListUpdateEvent):void
		{
			var task:TaskItemInfo = e.data as TaskItemInfo;
			_listSelecteds[task.template.type] = true;
			updateList();
		}
		
		private function removeTaskHandler(e:TaskListUpdateEvent):void
		{
			updateList();
		}
		
		private function taskAddHandler(e:TaskModuleEvent):void
		{
			var taskId:int = e.data as int;
			var task:TaskTemplateInfo = TaskTemplateList.getTaskTemplate(taskId);
			_listSelecteds[task.type] = true;
			updateList();
		}
		
		private function updateListHandler(e:TaskModuleEvent):void
		{
			updateList();
		}
		
		private function updateList():void
		{
			var itemList:Array = GlobalData.taskInfo.getNoSubmitTasksByType();
			var p:Boolean;
			for(var i:int = 0; i < itemList.length; i++)
			{
				if(itemList[i].data.length > 0)p = true;
			}
			//如果已接任务为空，那么跳到可接任务追踪。
			if(p)setIndex(0);
			else setIndex(1);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.DATA))
			{
				clearItems();
				
				var group:TaskFollowGroup;
				switch(_btns.indexOf(_currentBtn))
				{
					case 0:
						var itemList:Array = GlobalData.taskInfo.getNoSubmitTasksByType();
						for(var i:int = 0; i < itemList.length; i++)
						{
							if(itemList[i].data.length > 0)
							{
								group = new TaskFollowGroup(1,itemList[i],taskGroupUpdate);
								group.addEventListener(TaskInnerEvent.TASK_FOLLOW_UPDATE,taskFollowUpdateHandler);
								_listView.getContainer().addChild(group);
								_list[i] = group;
								group.selected = _listSelecteds[itemList[i].type];
								group.y = _currentHeight;
								_currentHeight += group.height;
							}
						}
						break;
					case 1:
						var addTransport:Boolean = false;
						var acceptList:Array = GlobalData.taskInfo.taskStateChecker.getTaskVisible();
						for(var j:int = 0; j < acceptList.length; j++)
						{
							if(acceptList[j].data.length > 0)
							{
								group = new TaskFollowGroup(0,acceptList[j]);
								group.addEventListener(TaskInnerEvent.TASK_FOLLOW_UPDATE,taskFollowUpdateHandler);
								_listView.getContainer().addChild(group);
								_list[j] = group;
								group.selected = _acceptSelecteds[acceptList[j].type];
								group.y = _currentHeight;
								_currentHeight += group.height;
							}
						}
						break;
				}
				_listView.getContainer().height = _currentHeight;
				_listView.update();
			}
			
			super.draw();
		}
		
		private function createItems():void
		{
			invalidate(InvalidationType.DATA);
		}
		
		private function taskGroupUpdate():void
		{
			createItems();
		}
		
		private function taskFollowUpdateHandler(e:TaskInnerEvent):void
		{
			_currentHeight = 0;
			for(var i:int = 0; i < _list.length; i++)
			{
				if(_list[i])
				{
					if(_currentBtn == _btns[0])_listSelecteds[_list[i].taskType] = _list[i].selected;
					else _acceptSelecteds[_list[i].taskType] = _list[i].selected;
					_list[i].y = _currentHeight;
					_currentHeight += _list[i].height;
				}
			}
			_listView.getContainer().height = _currentHeight;
			_listView.update();
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.TASK_FOLLOW)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),_listView.addChild);
			}
			if(info.param1 == GuideTipDeployType.ACCEPT_TASK_BTN)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(CommonConfig.GAME_WIDTH - info.param3,info.param4),GlobalAPI.layerManager.getTipLayer().addChild);
			}
		}
		
		private function upgradeHandler(e:CommonModuleEvent):void
		{
			createItems();
		}
		
		private function clearItems():void
		{
			for(var i:int = 0; i < _listView.getContainer().numChildren; i++)
			{
				_listView.getContainer().removeChildAt(0);
			}
			_listView.getContainer().height = 0;
			_currentHeight = 0;
			for each(var group:TaskFollowGroup in _list)
			{
				if(group)
				{
					group.dispose();
				}
			}
			_list = new Array(TaskType.getTaskTypes().length);
		}
		
		public function show():void
		{
			_container.visible = true;
			_container2.visible = false;
		}
		
		public function hide():void
		{
			x = DEFAULT_X;
			y = DEFAULT_Y;
			_container.visible = false;
			_container2.visible = true;
		}
		
		override public function get width():Number
		{
			return _container.width;
		}
		
		override public function get height():Number
		{
			return _container.height;
		}
		
		override public function dispose():void
		{
			removeEvent();
			clearItems();
			if(_listView)
			{
				_listView.dispose();
				_listView = null;
			}
			if(_minimizeBtn)
			{
				_minimizeBtn.dispose();
				_minimizeBtn = null;
			}
			if(_maximizeBtn)
			{
				_maximizeBtn.dispose();
				_maximizeBtn = null;
			}
			if(_showTaskMainPanelBtn)
			{
				_showTaskMainPanelBtn.dispose();
				_showTaskMainPanelBtn = null;
			}
			if(_btns)
			{
				for each(var btn:MCacheTabBtn1 in _btns)
				{
					btn.dispose();
				}
			}
			_btns = null;
			_container = null;
			_container2 = null;
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			_currentBtn = null;
			_labels = null;
			if(_dragBtn)
			{
				_dragBtn = null;
			}
			_listSelecteds = null;
			_acceptSelecteds = null;
			_mediator = null;
			super.dispose();
		}
		
	}
}