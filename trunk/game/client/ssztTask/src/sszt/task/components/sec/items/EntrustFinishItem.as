package sszt.task.components.sec.items
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.DateUtil;
	import sszt.task.events.TaskInnerEvent;
	
	public class EntrustFinishItem extends MSprite
	{
		private var _info:TaskItemInfo;
		private var _checkbox:CheckBox;
		private var _nameField:MAssetLabel;
		private var _priceField:TextField;
		private var _price:int;
		private var _selected:Boolean;
		
		private const MONEY:int = 1;

//		private static var _asset:EntrustFinishItemAsset = new EntrustFinishItemAsset();
		
		private static var _asset:BitmapData = AssetUtil.getAsset("mhsm.task.EntrustFinishItemAsset") as BitmapData;
		
		public function EntrustFinishItem(info:TaskItemInfo)
		{
			_info = info;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			var bp:Bitmap = new Bitmap(_asset);
			bp.x = 217;
			bp.y = 5;
			addChild(bp);
			
			_nameField = new MAssetLabel(_info.template.title,MAssetLabel.LABELTYPE1,"left");
			_nameField.move(56,2);
			addChild(_nameField);
			
			var countDown:CountDownInfo = DateUtil.getCountDownByHour(GlobalData.systemDate.getSystemDate().getTime(),_info.entrustEndTime.getTime());
			_price = MONEY * (countDown.hours * 60 + countDown.minutes + 1);
			_priceField = new TextField();
			_priceField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
			_priceField.mouseEnabled = _priceField.mouseWheelEnabled = false;
			_priceField.x = 185;
			_priceField.y = 2;
			_priceField.width = 30;
			addChild(_priceField);
			_priceField.text = String(_price);
			
			_checkbox = new CheckBox();
			_checkbox.label = "";
			_checkbox.setSize(18,18);
			addChild(_checkbox);
			_checkbox.selected = _selected = true;
		}
		
		private function initEvent():void
		{
			_checkbox.addEventListener(Event.CHANGE,checkboxChangeHandler);
		}
		
		private function removeEvent():void
		{
			_checkbox.removeEventListener(Event.CHANGE,checkboxChangeHandler);
		}
		
		private function checkboxChangeHandler(e:Event):void
		{
			_selected = _checkbox.selected;
			dispatchEvent(new TaskInnerEvent(TaskInnerEvent.TASK_ENTRUSTFINISH_UPDATE));
		}
		
		public function get taskId():int
		{
			return _info.taskId;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function get price():int
		{
			return _price;
		}
		
		override public function dispose():void
		{
			removeEvent();
			_nameField = null;
			_priceField = null;
			_checkbox = null;
			_info = null;
			super.dispose();
		}
	}
}