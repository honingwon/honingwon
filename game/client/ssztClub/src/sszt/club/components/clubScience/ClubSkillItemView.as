package sszt.club.components.clubScience
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubSkillEvent;
	import sszt.core.data.club.ClubSkillItemInfo;
	import sszt.core.data.club.ClubSkillTemplate;
	import sszt.core.data.skill.SkillTemplateDescriptList;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	
	public class ClubSkillItemView extends Sprite
	{
		private var _bg:Bitmap;
		private var _skillCell:ClubSkillCell;
		private var _selected:Boolean;
		private var _isLevelUp:Boolean;
		private var _isStudy:Boolean;
		private var _levelLabel:TextField;
		private var _descript:TextField;
		private var _skillInfo:ClubSkillItemInfo;
		private var _template:ClubSkillTemplate;
		
		public function ClubSkillItemView(template:ClubSkillTemplate)
		{
			_template = template;
			super();
			init();
		}
		
		private function init():void
		{
//			_bg = new Bitmap(new ScienceBgAsset());
			addChild(_bg);
			
			_skillCell = new ClubSkillCell();
			_skillCell.move(71,11);
			_skillCell.info = _template;
			addChild(_skillCell);
			
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffda5);
			_levelLabel = new TextField();
			_levelLabel.mouseEnabled = _levelLabel.mouseWheelEnabled = false;
			_levelLabel.x = 11;
			_levelLabel.y = 9;
			_levelLabel.defaultTextFormat = format;
			_levelLabel.setTextFormat(format);
			addChild(_levelLabel);
			_levelLabel.text = LanguageManager.getWord("ssztl.club.neverLearn");
			
			
			format = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff);
			_descript = new TextField();
			_descript.mouseEnabled = _descript.mouseWheelEnabled = false;
			_descript.x = 122;
			_descript.y = 13;
			_descript.defaultTextFormat = format;
			_descript.setTextFormat(format);
			addChild(_descript);
			if(_template.type == 2) _descript.text = LanguageManager.getWord("ssztl.club.passiveSkillNoNeedLight2");
			if(_template.type == 1) _descript.text = LanguageManager.getWord("ssztl.club.lightAdayContribute", _template.needSelfExploit[0]);
			
			isStudy = false;
			if(GlobalData.selfPlayer.clubLevel >= _template.needLevel[0]) isLevelUp = true;
			else isLevelUp = false;
		}
		
		public function set skillInfo(value:ClubSkillItemInfo):void
		{
			if(_skillInfo == value) return;
			if(_skillInfo) _skillInfo.removeEventListener(ClubSkillEvent.CLUB_SKILL_UPDATE,updateHandler);
			_skillInfo = value;
			if(_template.type == 1) _descript.text = LanguageManager.getWord("ssztl.club.lightAdayContribute", _template.needSelfExploit[_skillInfo.level - 1]);
			_levelLabel.text = LanguageManager.getWord("ssztl.club.skillLevel",_skillInfo.level);
			_skillInfo.addEventListener(ClubSkillEvent.CLUB_SKILL_UPDATE,updateHandler);
			isStudy = true;
		}
		
		private function updateHandler(evt:ClubSkillEvent):void
		{
			if(_template.type == 1) _descript.text = LanguageManager.getWord("ssztl.club.lightAdayContribute", _template.needSelfExploit[_skillInfo.level - 1]);
			_levelLabel.text = LanguageManager.getWord("ssztl.club.skillLevel",_skillInfo.level);
			dispatchEvent(new Event(ClubSciencePanel.CLUB_SKILL_UPDATE));
		}
		
		public function get templateId():int
		{
			return _template.templateId;
		}
		
		public function get skillInfo():ClubSkillItemInfo
		{
			return _skillInfo;
		}
		
		public function get template():ClubSkillTemplate
		{
			return _template;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected)
			{
				addChild(ClubSciencePanel.selectBg)
				ClubSciencePanel.selectBg.x = -4;
				ClubSciencePanel.selectBg.y = -5;
			}else
			{
				if(ClubSciencePanel.selectBg.parent == this)
					removeChild(ClubSciencePanel.selectBg);
			}
		}
		
		public function set isLevelUp(value:Boolean):void
		{
			_isLevelUp = value;
			if(_isLevelUp)
			{
				_bg.filters = [];
			}else
			{
				_bg.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}
		}
		
		public function get isLevelUp():Boolean
		{
			return _isLevelUp;
		}
		
		public function set isStudy(value:Boolean):void
		{
			_isStudy = value;
			if(_isStudy) _skillCell.locked = false;
			else _skillCell.locked = true;
		}
		
		public function get isStudy():Boolean
		{
			return _isStudy;
		}
		
		public function dispose():void
		{
			if(_skillInfo) _skillInfo.removeEventListener(ClubSkillEvent.CLUB_SKILL_UPDATE,updateHandler);
			_bg = null;
			_skillCell.dispose();
			_skillCell = null;
			_levelLabel = null;
			_descript = null;
			_skillInfo = null;
			_template = null;
		}
	}
}