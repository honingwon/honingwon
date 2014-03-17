package sszt.task.components.sec.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskItemInfoUpdateEvent;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.task.events.TaskInnerEvent;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	public class TaskFollowItem extends MSprite
	{
		private var _textfield:RichTextField;
		private var _itemInfo:TaskItemInfo;
		private var _info:TaskTemplateInfo;
		private var _selected:Boolean;
		private var _state:int;
		
		private static var _bpdAsset:BitmapData;
		
		/*
		private static function getBpdAsset():BitmapData
		{
			if(!_bpdAsset)
			{
				_bpdAsset = AssetUtil.getAsset("mhsm.task.FollowPanelItemAsset") as BitmapData;
			}
			return _bpdAsset;
		}
		*/
		
		public function TaskFollowItem()
		{
			mouseEnabled = false;
			_selected = true;
			super();
			init();
		}
		
		private function init():void
		{
//			var bmp:Bitmap = new Bitmap(getBpdAsset());
//			bmp.x = 7;
//			bmp.y = 5;
//			addChild(bmp);
			var line:Bitmap = new MCacheSplit2Line();
			line.width = 260;
			addChild(line);
		}
		
		public function set info(value:TaskTemplateInfo):void
		{
			if(value == null)return;
			if(_info == value)return;
			_info = value;
			if(_textfield)
			{
				_textfield.dispose();
				_textfield = null;
			}
			_textfield = RichTextUtil.getTaskRichText(_info);
			_textfield.x = 18;
			_textfield.y = 5;
			addChild(_textfield);
		}
		
		public function set itemInfo(value:TaskItemInfo):void
		{
			if(value == null)return;
			if(_itemInfo == value)return;
			_itemInfo = value;
			_state = _itemInfo.state;
			taskInfoUpdateHandler(null);
			_itemInfo.addEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,taskInfoUpdateHandler);
		}
		
		private function taskInfoUpdateHandler(e:TaskItemInfoUpdateEvent):void
		{
			if(_itemInfo == null)return;
			if(_itemInfo.isFinish == true)return;
			var h:int = 0;
			if(_textfield)
			{
				h = _textfield.height;
				_textfield.dispose();
				_textfield = null;
			}
			_textfield = RichTextUtil.getTaskRichText(_itemInfo);
			_textfield.x = 18;
			_textfield.y = 5;
			addChild(_textfield);
			if(_textfield.height != h)dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_FOLLOWITEM_UPDATE));
			if(_state != _itemInfo.state)
			{
				dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_GROUP_UPDATE));
				_state = _itemInfo.state;
			}
		}
		
		override public function get height():Number
		{
			return _textfield.height;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_textfield)
			{
				_textfield.dispose();
				_textfield = null;
			}
			if(_itemInfo)
			{
				_itemInfo.removeEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,taskInfoUpdateHandler);
				_itemInfo = null;
			}
			_info = null;
		}
	}
}