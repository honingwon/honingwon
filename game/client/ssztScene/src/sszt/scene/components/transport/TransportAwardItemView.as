package sszt.scene.components.transport
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.task.TaskStateTemplateInfo;
	import sszt.core.manager.LanguageManager;
	
	public class TransportAwardItemView extends Sprite
	{
		private var _qualityField:TextField;
		private var _expAwardField:TextField;
		private var _copperAwardField:TextField;
		
		private var _taskStateInfo:TaskStateTemplateInfo;
		private var _quality:int;
		public function TransportAwardItemView(taskStateInfo:TaskStateTemplateInfo,quality:int)
		{
			super();
			_taskStateInfo = taskStateInfo;
			_quality = quality;
			initView();
		}
		
		private function initView():void
		{
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_qualityField = new TextField();
			_qualityField.selectable = false;
			_qualityField.x = 11;
			_qualityField.y = 2;
			_qualityField.width = 67;
			_qualityField.height = 18;
			_qualityField.defaultTextFormat = format;
			_qualityField.textColor = CategoryType.getQualityColor(_quality);
			_qualityField.text = getQualityName();
			addChild(_qualityField);
			
			_expAwardField = new TextField();
			_expAwardField.selectable = false;
			_expAwardField.x = 79;
			_expAwardField.y = 2;
			_expAwardField.width = 96;
			_expAwardField.height = 18;
			_expAwardField.defaultTextFormat = format;
			_expAwardField.text = _taskStateInfo.awardExp.toString();
			addChild(_expAwardField);
			
			_copperAwardField = new TextField();
			_copperAwardField.selectable = false;
			_copperAwardField.x = 177;
			_copperAwardField.y = 2;
			_copperAwardField.width = 132;
			_copperAwardField.height = 18;
			_copperAwardField.defaultTextFormat = format;
			_copperAwardField.text = _taskStateInfo.awardCopper.toString();
			addChild(_copperAwardField);
		}
		
		private function getQualityName():String
		{
			switch (_quality)
			{
				case 0:
					return LanguageManager.getWord("ssztl.common.whiteQulity2");
				case 1:
					return LanguageManager.getWord("ssztl.common.greenQulity2");
				case 2:
					return LanguageManager.getWord("ssztl.common.blueQulity2");
				case 3:
					return LanguageManager.getWord("ssztl.common.purpleQulity2");
			}
			return LanguageManager.getWord("ssztl.common.whiteQulity2");

		}
		
		public function dispose():void
		{
			_taskStateInfo = null;
		}
	}
}