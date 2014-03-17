package sszt.club.components.clubMain.pop.items
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.container.MSprite;
	
	import sszt.club.datas.contributeInfo.ClubContributeItemInfo;
	import sszt.constData.CareerType;
	import sszt.core.manager.LanguageManager;
	
	public class ClubContributeItem extends MSprite
	{
		private var _info:ClubContributeItemInfo;
		private var _nameField:TextField,_careerField:TextField,_copperField:TextField,_yuanbaoField:TextField;
		
		public function ClubContributeItem(info:ClubContributeItemInfo)
		{
			_info = info;
			super();
			initView();
		}
		
		private function initView():void
		{
			_nameField = new TextField();
			_nameField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_nameField.mouseEnabled = _nameField.mouseWheelEnabled = false;
			_nameField.width = 112;
			_nameField.height = 18;
			_nameField.x = 33;
			addChild(_nameField);
			_nameField.text = "[" + _info.serverId + "]" + _info.name;
			
			_careerField = new TextField();
			_careerField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_careerField.mouseEnabled = _careerField.mouseWheelEnabled = false;
			_careerField.width = 40;
			_careerField.height = 18;
			_careerField.x = 211;
			addChild(_careerField);
			_careerField.text = CareerType.getNameByCareer(_info.career);
			
			_copperField = new TextField();
			_copperField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_copperField.mouseEnabled = _copperField.mouseWheelEnabled = false;
			_copperField.width = 70;
			_copperField.height = 18;
			_copperField.x = 315;
			addChild(_copperField);
			_copperField.text = String(_info.copper);
			
			_yuanbaoField = new TextField();
			_yuanbaoField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			_yuanbaoField.mouseEnabled = _yuanbaoField.mouseWheelEnabled = false;
			_yuanbaoField.width = 70;
			_yuanbaoField.height = 18;
			_yuanbaoField.x = 456;
			addChild(_yuanbaoField);
			_yuanbaoField.text = String(_info.yuanbao);
		}
		
		override public function dispose():void
		{
			_info = null;
			super.dispose();
		}
	}
}