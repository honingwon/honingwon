package sszt.task.components.sec.items
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskEntrustItemInfo;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskListUpdateEvent;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.DateUtil;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.task.events.TaskInnerEvent;
	import mhsm.ui.DownBtnAsset;
	import mhsm.ui.UpBtnAsset;
	
	public class TaskEntrustItem extends MSprite implements ITick,IDoubleClick
	{
		private var _info:TaskEntrustItemInfo;
		private var _template:TaskTemplateInfo;
		private var _bg:IMovieWrapper;
		private var _title:TextField,_exp:TextField,_lifeExp:TextField,_copper:TextField,_time:TextField,_need:TextField;
		private var _isEntrusting:MAssetLabel;
		private var _countField:TextField;
//		private var _combobox:ComboBox;
		private var _count:int;
		private var _checkBox:CheckBox;
		private var _selected:Boolean;
		private var _upBtn:MBitmapButton,_downBtn:MBitmapButton;
		private var _doubleClickHandler:Function;
		private var _updateTime:Number;
		
		public function TaskEntrustItem(info:TaskEntrustItemInfo,doubleClickHandler:Function)
		{
			_info = info;
			_template = TaskTemplateList.getTaskTemplate(_info.taskId);
			_doubleClickHandler = doubleClickHandler;
			_updateTime = getTimer();
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(122,0,65,19))
			]);
			addChild(_bg as DisplayObject);
			
//			_combobox = new ComboBox();
//			_combobox.move(482,0);
//			_combobox.setSize(68,20);
//			_combobox.dataProvider = new DataProvider([{label:"铜币",value:0},{label:"元宝",value:1}]);
//			_combobox.selectedItem = _combobox.dataProvider.getItemAt(0);
//			addChild(_combobox);
			
			_title = new TextField();
			_title.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_title.width = 88;
			_title.x = 15;
			_title.y = 2;
			_title.text = _template.title;
			_title.mouseEnabled = _title.mouseWheelEnabled = false;
			addChild(_title);
			_exp = new TextField();
			_exp.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_exp.width = 58;
			_exp.x = 200;
			_exp.y = 2;
			_exp.mouseEnabled = _exp.mouseWheelEnabled = false;
			addChild(_exp);
			_lifeExp = new TextField();
			_lifeExp.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_lifeExp.width = 58;
			_lifeExp.x = 272;
			_lifeExp.y = 2;
			_lifeExp.mouseEnabled = _lifeExp.mouseWheelEnabled = false;
			addChild(_lifeExp);
			_copper = new TextField();
			_copper.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_copper.width = 58;
			_copper.x = 337;
			_copper.y = 2;
			_copper.mouseEnabled = _copper.mouseWheelEnabled = false;
			addChild(_copper);
			_time = new TextField();
			_time.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_time.width = 60;
			_time.x = 403;
			_time.y = 2;
			_time.mouseEnabled = _time.mouseWheelEnabled = false;
			addChild(_time);
//			var needMoney:int = _combobox.selectedItem.value == 1 ? _template.entrustYuanbao : _template.entrustCopper;
			_need = new TextField();
			_need.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_need.width = 58;
			_need.x = 472;
			_need.y = 2;
			_need.mouseEnabled = _need.mouseWheelEnabled = false;
			addChild(_need);
			
//			_isEntrusting = new MAssetLabel("委托中",MAssetLabel.LABELTYPE12);
			_isEntrusting = new MAssetLabel(LanguageManager.getWord("ssztl.task.entrusting"),MAssetLabel.LABELTYPE12);
			_isEntrusting.move(537,2);
			addChild(_isEntrusting);
			
			_selected = true;
			_checkBox = new CheckBox();
			_checkBox.move(540,10);
			addChild(_checkBox);
			_checkBox.selected = _selected;
			
			_countField = new TextField();
			_countField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_countField.width = 25;
			_countField.height = 18;
			_countField.x = 145;
			_countField.y = 2;
			_countField.restrict = "0123456789";
			_countField.maxChars = 2;
			_countField.type = TextFieldType.INPUT;
			addChild(_countField);
			
			_upBtn = new MBitmapButton(new UpBtnAsset());
			_upBtn.move(167,1);
			addChild(_upBtn);
			_downBtn = new MBitmapButton(new DownBtnAsset());
			_downBtn.move(167,9);
			addChild(_downBtn);
			
			if(_info.isEntrusting)_count = _info.entrustCount;
			else _count = _info.dayLeftCount;
			updateInfo();
			updateTaskState();
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,taskInfoUpdateHandler);
			GlobalData.taskInfo.addEventListener(TaskListUpdateEvent.ADD_TASK,addTaskHandler);
			_countField.addEventListener(Event.CHANGE,countFieldChangeHandler);
			_upBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
//			_combobox.addEventListener(Event.CHANGE,comboBoxChangeHandler);
			_checkBox.addEventListener(Event.CHANGE,checkBoxChangeHandler);
			_countField.addEventListener(MouseEvent.CLICK,clickHandler);
//			_combobox.addEventListener(MouseEvent.CLICK,clickHandler);
			_checkBox.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ENTRUST_UPDATE,taskInfoUpdateHandler);
			GlobalData.taskInfo.removeEventListener(TaskListUpdateEvent.ADD_TASK,addTaskHandler);
			_countField.removeEventListener(Event.CHANGE,countFieldChangeHandler);
			_upBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
//			_combobox.removeEventListener(Event.CHANGE,comboBoxChangeHandler);
			_checkBox.removeEventListener(Event.CHANGE,checkBoxChangeHandler);
			_countField.removeEventListener(MouseEvent.CLICK,clickHandler);
//			_combobox.removeEventListener(MouseEvent.CLICK,clickHandler);
			_checkBox.removeEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function addTaskHandler(e:TaskListUpdateEvent):void
		{
			var task:TaskItemInfo = e.data as TaskItemInfo;
			if(_info.taskId == task.taskId)
			{
				_info.isEntrusting = task.isEntrusting;
				_info.dayLeftCount = task.dayLeftCount;
				_info.entrustCount = task.entrustCount;
				_info.entrustEndTime = task.entrustEndTime;
				updateTaskState();
			}
		}
		
		private function taskInfoUpdateHandler(e:TaskModuleEvent):void
		{
			var taskId:int = e.data as int;
			var task:TaskItemInfo = GlobalData.taskInfo.getTask(taskId);
			if(_info.taskId == taskId && task != null)
			{
				_info.isEntrusting = task.isEntrusting;
				_info.dayLeftCount = task.dayLeftCount;
				_info.entrustCount = task.entrustCount;
				_info.entrustEndTime = task.entrustEndTime;
				updateTaskState();
				if(_info.isEntrusting == false && _info.dayLeftCount < 1)
					dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_ENTRUST_REMOVE));
			}
		}
		
		private function updateTaskState():void
		{
			if(_info.isEntrusting)
			{
				this.mouseEnabled = this.mouseChildren = false;
				_isEntrusting.visible = true;
				_checkBox.visible = false;
				GlobalAPI.tickManager.addTick(this);
			}
			else
			{
				this.mouseEnabled = this.mouseChildren = true;
				_isEntrusting.visible = false;
				_checkBox.visible = true;
				GlobalAPI.tickManager.removeTick(this);
				
				_count = _info.dayLeftCount;
				updateInfo();
			}
			dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE));
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
		}
		
		private function countFieldChangeHandler(e:Event):void
		{
			_count = int(_countField.text);
			if(_count < 1)_count = 1;
			else if(_count > _info.dayLeftCount)_count = _info.dayLeftCount;
			updateInfo();
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			e.stopImmediatePropagation();
			_count = int(_countField.text);
			switch(e.currentTarget)
			{
				case _upBtn:
					if(_count < _info.dayLeftCount)_count++;
					break;
				case _downBtn:
					if(_count > 1)_count--;
					break;
			}
			updateInfo();
		}
		
//		private function comboBoxChangeHandler(e:Event):void
//		{
//			updateInfo();
//		}
		
		private function checkBoxChangeHandler(e:Event):void
		{
			_selected = _checkBox.selected;
			dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE));
		}
		
		private function updateInfo():void
		{
			_countField.text = String(_count);
			var exp:int = 0;
			var lifeExp:int = 0;
			var copper:int = 0;
			for(var i:int = 0; i < _template.states.length; i++)
			{
				exp += _template.states[i].awardExp;
				lifeExp += _template.states[i].awardLifeExp;
				copper += _template.states[i].awardBindCopper;
			}
			_exp.text = String(exp * _count);
			_lifeExp.text = String(lifeExp * _count);
			_copper.text = String(copper * _count);
			var hour:int,second:int,minute:int;
			if(_info.isEntrusting)
			{
				var countDown:CountDownInfo = DateUtil.getCountDownByHour(GlobalData.systemDate.getSystemDate().getTime(),_info.entrustEndTime.getTime());
				hour = countDown.hours >= 0 ? countDown.hours : 0;
				second = countDown.seconds >= 0 ? countDown.seconds : 0;
				minute = countDown.minutes >= 0 ? countDown.minutes : 0;
			}
			else
			{
				hour = Math.floor(_template.entrustTime * _count / 1000 / 3600);
				second = _template.entrustTime * _count / 1000 % 60;
				minute = Math.floor(_template.entrustTime * _count / 1000 / 60) - hour * 60;
			}
			_time.text = (hour < 10 ? "0"+hour : hour) + ":" + (minute < 10 ? "0"+minute : minute) + ":" + (second < 10 ? "0"+second : second);
//			var needMoney:int = _combobox.selectedItem.value == 1 ? _template.entrustYuanbao : _template.entrustCopper;
//			_need.text = _template.entrustYuanbao * _count + "元宝";
			_need.text = _template.entrustYuanbao * _count + LanguageManager.getWord("ssztl.common.yuanBao2");
			dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_ENTRUST_INFOUPDATE));
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_info.isEntrusting)
			{
				var t:Number = getTimer();
				if(t - _updateTime >= 1000)
				{
					var countDown:CountDownInfo = DateUtil.getCountDownByHour(GlobalData.systemDate.getSystemDate().getTime(),_info.entrustEndTime.getTime());
					var hour:int = countDown.hours >= 0 ? countDown.hours : 0;
					var second:int = countDown.seconds >= 0 ? countDown.seconds : 0;
					var minute:int = countDown.minutes >= 0 ? countDown.minutes : 0;
					_time.text = (hour < 10 ? "0"+hour : hour) + ":" + (minute < 10 ? "0"+minute : minute) + ":" + (second < 10 ? "0"+second : second);
					_updateTime = t;
				}
			}
		}
		
		public function click():void
		{
		}
		
		public function doubleClick():void
		{
			if(_doubleClickHandler != null)
			{
				_doubleClickHandler(this);
			}
		}
		
//		public function get needCopper():int
//		{
//			if(_combobox.selectedItem.value == 0)return _template.entrustCopper * _count;
//			return 0;
//		}
		
		public function get needYuanbao():int
		{
//			if(_combobox.selectedItem.value == 1)return _template.entrustYuanbao * _count;
			return _template.entrustYuanbao * _count;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			_checkBox.selected = _selected;
		}
		
		public function get itemInfo():TaskEntrustItemInfo
		{
			return _info;
		}
		
		public function get count():int
		{
			return _count;
		}
		
		public function get type():int
		{
//			return _combobox.selectedItem.value + 1;
			return 2;
		}
		
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_upBtn)
			{
				_upBtn.dispose();
				_upBtn = null;
			}
			if(_downBtn)
			{
				_downBtn.dispose();
				_downBtn = null;
			}
			_checkBox = null;
//			_combobox = null;
			_info = null;
			_template = null;
			super.dispose();
		}
	}
}