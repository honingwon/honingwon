package sszt.club.components.clubScience
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.club.datas.detailInfo.ClubDetailInfo;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubSkillActiveSocketHandler;
	import sszt.club.socketHandlers.ClubSkillLearnSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.club.ClubSkillTemplate;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	
	public class ClubSkillDetail extends Sprite
	{
		private var _name:MAssetLabel;
		private var _effect:MAssetLabel;
		private var _upgradeEffect:MAssetLabel;
		
		private var _needLevel:MAssetLabel;
		private var _needMoney:MAssetLabel;
		private var _needAsset:MAssetLabel;
		
		private var _studyBtn:MCacheAsset1Btn;
		private var _upgradeBtn:MCacheAsset1Btn;
		private var _lightUpBtn:MCacheAsset1Btn;
		
		private var _template:ClubSkillTemplate;
		private var _level:int;
		private var _mediator:ClubMediator;
		
		public function ClubSkillDetail(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			_name = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_name.move(503,34);
			addChild(_name);
			_effect = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_effect.move(443,80);
			addChild(_effect);
			_upgradeEffect = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_upgradeEffect.move(443,168);
			addChild(_upgradeEffect);
			
			_needLevel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_needLevel.move(503,266);
			addChild(_needLevel);
			_needMoney = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_needMoney.move(530,284);
			addChild(_needMoney);
//			_needAsset = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
//			_needAsset.move(503,307);
//			addChild(_needAsset);
			
			_studyBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.club.learnSkill"));
			_studyBtn.move(561,361);
			addChild(_studyBtn);
			_upgradeBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.club.upgradeSkill"));
			_upgradeBtn.move(561,361);
			addChild(_upgradeBtn);
			_lightUpBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.club.lightSkill"));
			_lightUpBtn.move(322,361);
			addChild(_lightUpBtn);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_studyBtn.addEventListener(MouseEvent.CLICK,studyClickHandler);
			_upgradeBtn.addEventListener(MouseEvent.CLICK,upgradeClickHandler);
			_lightUpBtn.addEventListener(MouseEvent.CLICK,lightUpClickHandler);
		}
		
		private function removeEvent():void
		{
			_studyBtn.removeEventListener(MouseEvent.CLICK,studyClickHandler);
			_upgradeBtn.removeEventListener(MouseEvent.CLICK,upgradeClickHandler);
			_lightUpBtn.removeEventListener(MouseEvent.CLICK,lightUpClickHandler);
		}
		
		private function studyClickHandler(evt:MouseEvent):void
		{
//			return;
			if(_template == null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.selectSkillFirst"));
				return;
			}
			if(GlobalData.selfPlayer.nick != _mediator.clubInfo.clubDetailInfo.masterName)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.clubLeaderCanUpgrade"));
				return;
			}
			if(_mediator.clubInfo.clubDetailInfo.clubRich < _template.needMoney[_level])
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough"));
				return;
			}
			ClubSkillLearnSocketHandler.send(_template.templateId);
		}
		
		private function upgradeClickHandler(evt:MouseEvent):void
		{
//			return;
			if(_template == null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.selectSkillFirst"));
				return;
			}
			if(GlobalData.selfPlayer.nick != _mediator.clubInfo.clubDetailInfo.masterName)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.clubLeaderCanUpgrade"));
				return;
			}
			if(_mediator.clubInfo.clubDetailInfo.clubRich < _template.needMoney[_level])
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough"));
				return;
			}
			ClubSkillLearnSocketHandler.send(_template.templateId);
		}
		
		private function lightUpClickHandler(evt:MouseEvent):void
		{
//			QuickTips.show("功能未开放！");
//			return;
			if(_template == null)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.selectSkillFirst"));
				return;
			}
			if(_template.type == 2)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.passiveSkillNoNeedLight"));
				return;
			}
			if(_level == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.neverLearnSkill"));
				return;
			}

			if(GlobalData.selfPlayer.totalExploit < _template.needTotalExploit[_level - 1])
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.allContributeNeedAchieve",_template.needTotalExploit[_level - 1]));
				return;
			}
			if(GlobalData.selfPlayer.selfExploit < _template.needSelfExploit[_level - 1])
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.cannotLight"));
				return;
			}
			var buffItem:BuffItemInfo = GlobalData.selfScenePlayerInfo.getBuff(_template.buffList[_level - 1]);
			if(buffItem)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.club.skillLighted"));
				return;
			}
			ClubSkillActiveSocketHandler.send(_template.templateId);
		}
		
		public function setDetail(template:ClubSkillTemplate,level:int = 0):void
		{
			var value:Boolean = true;
			_template = template;
			_level = level;
			if(level == 0)
			{
				_upgradeBtn.visible = false;
				_studyBtn.visible = true;
			}else
			{
				_upgradeBtn.visible = true;
				_studyBtn.visible = false;
			}
			_name.setValue(template.name);
			if(level > 0) _effect.setValue(template.getEffectToString(level));			
			else _effect.setValue(template.getEffectToString(1));
			if(level >= template.totalLevel)
			{
				_upgradeEffect.setValue(LanguageManager.getWord("ssztl.club.skillAchieveMax"));
				_upgradeEffect.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_upgradeEffect.length);
				_needLevel.setValue("-");
				_needMoney.setValue("-");
//				_needAsset.setValue("-");
			}else
			{
				_upgradeEffect.setValue(template.getEffectToString(level + 1));
				_needLevel.setValue(template.needLevel[level]);
				_needMoney.setValue(template.needMoney[level]);
//				_needAsset.setValue(template.needAsset[level]);
			}
			if(_mediator.clubInfo.clubDetailInfo.clubLevel < template.needLevel[level])
			{
				value = false;
				_needLevel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needLevel.length);
			}else
			{
				_needLevel.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff),0,_needLevel.length);
			}
			if(_mediator.clubInfo.clubDetailInfo.clubRich < template.needMoney[level])
			{
				value = false;
				_needMoney.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needMoney.length);
			}else
			{
				_needMoney.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff),0,_needMoney.length);
			}
//			if(_mediator.clubInfo.clubDetailInfo.clubLiveness < template.needAsset[level])
//			{
//				value = false;
//				_needAsset.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff3000),0,_needAsset.length);
//			}else
//			{
//				_needAsset.setTextFormat(new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff),0,_needAsset.length);
//			}
			if(!value)
			{
				_studyBtn.enabled = false;
				_upgradeBtn.enabled = false;
			}else
			{
				_studyBtn.enabled = true;
				_upgradeBtn.enabled = true;
			}
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_name = null;
			_effect = null;
			_upgradeEffect = null;
			_needLevel = null;
			_needMoney = null;
			_needAsset = null;
			if(_studyBtn)
			{
				_studyBtn.dispose();
				_studyBtn = null;
			}
			if(_upgradeBtn)
			{
				_upgradeBtn.dispose();
				_upgradeBtn = null;
			}
			if(_lightUpBtn)
			{
				_lightUpBtn.dispose();
				_lightUpBtn = null;
			}
		}
	}
}