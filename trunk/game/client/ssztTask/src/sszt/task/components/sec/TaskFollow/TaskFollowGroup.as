package sszt.task.components.sec.TaskFollow
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskAccordionData;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskItemInfoUpdateEvent;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.utils.AssetUtil;
	import sszt.task.components.sec.items.TaskFollowItem;
	import sszt.task.events.TaskInnerEvent;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	
	public class TaskFollowGroup extends MSprite
	{
		//type 0为可接任务，1为已接任务
		private var _type:int;
		private var _title:String;
		private var _infoList:Array;
		//private var _btn:MSelectButton;
		private var _addIcon:MCacheAssetBtn2;
		private var _reduceIcon:MCacheAssetBtn2;
		private var _selected:Boolean;
		private var _currentHeight:int;
		private var _list:Array;
		private var _titleField:MAssetLabel;
		private var _taskType:int;
		private var _groupUpdate:Function;
		
		private static var _showBtnAsset:MovieClip;
		
		/*
		private static function getShowBtnAsset():MovieClip
		{
			if(!_showBtnAsset)
			{
				_showBtnAsset = AssetUtil.getAsset("mhsm.task.FollowPanelShowBtnAsset") as MovieClip;
				if(!_showBtnAsset)
				{
					_showBtnAsset = new MovieClip();
					_showBtnAsset.graphics.beginFill(0,0);
					_showBtnAsset.graphics.drawRect(0,0,1,1);
					_showBtnAsset.graphics.endFill();
				}
			}
			return _showBtnAsset;
		}
		*/
		
		public function TaskFollowGroup(type:int,data:TaskAccordionData,groupUpdate:Function = null)
		{
			_type = type;
			_taskType = data.type;
			_title = data.title;
			_infoList = data.data;
			_groupUpdate = groupUpdate;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			this.mouseEnabled = false;
			
			//_btn = new MSelectButton(getShowBtnAsset());
			//addChild(_btn);
			
			_addIcon = new MCacheAssetBtn2(10);
			_addIcon.visible = true;			
			addChild(_addIcon);
			_reduceIcon = new MCacheAssetBtn2(11);
			_reduceIcon.visible = false;
			addChild(_reduceIcon);
			_addIcon.y = _reduceIcon.y = -1;
			
			_currentHeight = 0;
			_titleField = new MAssetLabel(_title,MAssetLabel.LABEL_TYPE1);
			_titleField.move(20,0);
			addChild(_titleField);
			_currentHeight += 18;
			
			_list = [];
			var item:TaskFollowItem;
			if(_type == 0)
			{
				var addTransport:Boolean = false;
				for each(var info:TaskTemplateInfo in _infoList)
				{
					if(info.condition == TaskConditionType.TRANSPORT)
					{
						if(addTransport)continue;
						else addTransport = true;
					}
					item = new TaskFollowItem();
					item.info = info;
					item.addEventListener(TaskInnerEvent.TASK_FOLLOWITEM_UPDATE,followUpdateHandler);
					item.addEventListener(TaskInnerEvent.TASK_GROUP_UPDATE,taskGroupUpdateHandler);
					item.y = _currentHeight;
					addChild(item);
					_currentHeight += item.height;
					_list.push(item);
				}
			}
			else
			{
				for each(var info2:Object in _infoList)
				{
					if((info2 is TaskItemInfo) && GlobalData.taskInfo.taskStateChecker.checkStateComplete(TaskItemInfo(info2).getCurrentState(),TaskItemInfo(info2).requireCount) == true)
					{
						item = new TaskFollowItem();
						item.itemInfo = info2 as TaskItemInfo;
						item.addEventListener(TaskInnerEvent.TASK_FOLLOWITEM_UPDATE,followUpdateHandler);
						item.addEventListener(TaskInnerEvent.TASK_GROUP_UPDATE,taskGroupUpdateHandler);
						item.y = _currentHeight;
						addChild(item);
						_currentHeight += item.height;
						_list.push(item);
					}
				}
				for each(var info3:Object in _infoList)
				{
					if((info3 is TaskItemInfo) && GlobalData.taskInfo.taskStateChecker.checkStateComplete(TaskItemInfo(info3).getCurrentState(),TaskItemInfo(info3).requireCount) == false)
					{
						item = new TaskFollowItem();
						item.itemInfo = TaskItemInfo(info3);
						item.addEventListener(TaskInnerEvent.TASK_FOLLOWITEM_UPDATE,followUpdateHandler);
						item.addEventListener(TaskInnerEvent.TASK_GROUP_UPDATE,taskGroupUpdateHandler);
						item.y = _currentHeight;
						addChild(item);
						_currentHeight += item.height;
						_list.push(item);
					}
				}
				
				for each(var info4:Object in _infoList)
				{
					if(info4 is TaskTemplateInfo)
					{
						item = new TaskFollowItem();
						item.info = info4 as TaskTemplateInfo;
						item.y = _currentHeight;
						addChild(item);
						_currentHeight += item.height;
						_list.push(item);
					}
				}
			}
			
			selected = true;
		}
		
		private function initEvent():void
		{
			//_btn.addEventListener(MouseEvent.CLICK,selectedBtnClickHandler);
			_addIcon.addEventListener(MouseEvent.CLICK,selectedBtnClickHandler);
			_reduceIcon.addEventListener(MouseEvent.CLICK,selectedBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			//_btn.removeEventListener(MouseEvent.CLICK,selectedBtnClickHandler);
			_addIcon.removeEventListener(MouseEvent.CLICK,selectedBtnClickHandler);
			_reduceIcon.removeEventListener(MouseEvent.CLICK,selectedBtnClickHandler);
		}
		
		private function selectedBtnClickHandler(e:MouseEvent):void
		{
			selected = !selected;
			dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_FOLLOW_UPDATE));
		}
		
		private function followUpdateHandler(e:TaskInnerEvent):void
		{
			_currentHeight = 18;
			for each(var item:TaskFollowItem in _list)
			{
				item.y = _currentHeight;
				_currentHeight += item.height;
			}
			dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_FOLLOW_UPDATE));
		}
		
		private function taskGroupUpdateHandler(e:TaskInnerEvent):void
		{
			if(_groupUpdate != null)
			{
				_groupUpdate();
			}
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			for each(var item:TaskFollowItem in _list)
			{
				item.visible = _selected;
			}
			//_btn.selected = _selected;
			//_btn.drawNow();
			_addIcon.visible = !_selected;
			_reduceIcon.visible = _selected;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get taskType():int
		{
			return _taskType;
		}
		
		override public function get height():Number
		{
			if(selected)return _currentHeight;
			else return 20;
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_addIcon)
			{
				_addIcon.dispose();
				_addIcon = null;
			}
			if(_reduceIcon)
			{
				_reduceIcon.dispose();
				_reduceIcon = null;
			}
			for each(var item:TaskFollowItem in _list)
			{
				item.removeEventListener(TaskInnerEvent.TASK_FOLLOWITEM_UPDATE,followUpdateHandler);
				item.removeEventListener(TaskInnerEvent.TASK_GROUP_UPDATE,taskGroupUpdateHandler);
				item.dispose();
			}
			_list = null;
			_infoList = null;
			super.dispose();
		}
	}
}