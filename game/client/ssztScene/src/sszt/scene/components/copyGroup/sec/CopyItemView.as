package sszt.scene.components.copyGroup.sec
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyType;
	import sszt.core.manager.LanguageManager;
	import sszt.scene.components.copyGroup.CopyGroupPanel;
	
	public class CopyItemView extends Sprite
	{
		private var _info:CopyTemplateItem;
		private var _enabled:Boolean = true;
		private var _selected:Boolean;
		private var _recommendField:MAssetLabel;
		private var _copyNameField:MAssetLabel;
		private var _applyStateField:MAssetLabel;
		private var _countField:MAssetLabel;
		private var _isApply:Boolean;           //是否已报名
		
		
		public function CopyItemView(info:CopyTemplateItem)
		{
			_info = info;
			super();
			init();
			if(GlobalData.selfPlayer.level < _info.minLevel)
			{
				enabled = false;
				_enabled = false;
			}
		}
		
		public function get info():CopyTemplateItem
		{
			return _info;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(value)
			{
				_recommendField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff),0,_recommendField.length);
				_copyNameField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff),0,_copyNameField.length);
				_applyStateField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff),0,_applyStateField.length);
				_countField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff),0,_countField.length);
				mouseEnabled = mouseChildren = buttonMode = true;
			}else
			{
				_recommendField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x72777b),0,_recommendField.length);
				_copyNameField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x72777b),0,_copyNameField.length);
				_applyStateField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x72777b),0,_applyStateField.length);
				_countField.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0x72777b),0,_countField.length);
				mouseEnabled = mouseChildren =  buttonMode = false;
			}			
//			mouseEnabled = value;
		}
		
		private function init():void
		{		
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,330,21);
			graphics.endFill();
					
			_recommendField = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_recommendField.move(28,2);
			addChild(_recommendField);
			
			_copyNameField = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_copyNameField.move(125,2);
			addChild(_copyNameField);
			
			_applyStateField = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_applyStateField.move(232,2);
			addChild(_applyStateField);
			
			_countField = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_countField.move(295,2);
			addChild(_countField);
			
			setValue();
		}
		
		private function setValue():void
		{
			_recommendField.setValue(CopyType.getRecommondByType(_info.recommend));
			_copyNameField.setValue(_info.name);
			if(GlobalData.copyEnterCountList.applyId == _info.id) _applyStateField.setValue(LanguageManager.getWord("ssztl.scene.signUp"));
			else _applyStateField.setValue(LanguageManager.getWord("ssztl.scene.noSignUp"));
			var count:int = GlobalData.copyEnterCountList.getItemCount(_info.id);
			_countField.setValue(count + "/" + String(_info.dayTimes));
			if(count >= _info.dayTimes)
			{
				enabled = false;
				_enabled = false;
			}
		}
		
		public function set isApply(value:Boolean):void
		{
			if(_isApply == value) return;
			_isApply = value;

			if(_isApply) _applyStateField.setValue(LanguageManager.getWord("ssztl.scene.signUp"));
			else _applyStateField.setValue(LanguageManager.getWord("ssztl.scene.noSignUp"));
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected)
			{
				CopyGroupPanel.SelectBorder.move(-2,-3);
				addChild(CopyGroupPanel.SelectBorder);
			}else
			{
				if(CopyGroupPanel.SelectBorder.parent == this)
					removeChild(CopyGroupPanel.SelectBorder);
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function dispose():void
		{
			_recommendField = null;
			_copyNameField = null;
			_copyNameField = null;
			_applyStateField = null;
			_countField = null;
			if(parent) parent.removeChild(this);
		}
	}
}