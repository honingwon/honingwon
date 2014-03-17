package sszt.scene.components.copyIsland.beforeEnter
{
	import flash.display.Sprite;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.copyIsland.beforeEnter.CIBeforeItemInfo;
	
	public class CIBeforeEnterItemView extends Sprite
	{
		private var _info:CIBeforeItemInfo;
		private var _nameLabel:MAssetLabel;
		private var _tagLabel:MAssetLabel;
		public function CIBeforeEnterItemView()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			_nameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_nameLabel.move(50,2);
			addChild(_nameLabel);
			
			_tagLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.unvote"),MAssetLabel.LABELTYPE1);
			
			_tagLabel.move(100,2);
			addChild(_tagLabel);
		}
		
		private function updateLabel():void
		{
			if(_info)
			{
				_nameLabel.text = _info.name;
				if(_info.tag == 1)
				{
					_tagLabel.text = LanguageManager.getWord("ssztl.consign.agree");
				}
				else if(_info.tag == 2)
				{
					_tagLabel.text = LanguageManager.getWord("ssztl.consign.disagree");
				}
				else if(_info.tag == 3)
				{
					_tagLabel.text = LanguageManager.getWord("ssztl.consign.notMatchCondition");
				}
			}
			else
			{
				_nameLabel.text = "";
				_tagLabel.text = "";
			}
		}

		public function get info():CIBeforeItemInfo
		{
			return _info;
		}

		public function set info(value:CIBeforeItemInfo):void
		{
			_info = value;
			updateLabel();
		}
		
		public function dispose():void
		{
			_info = null;
			_nameLabel = null;
			_tagLabel = null;
			if(parent)parent.removeChild(this);
		}

	}
}