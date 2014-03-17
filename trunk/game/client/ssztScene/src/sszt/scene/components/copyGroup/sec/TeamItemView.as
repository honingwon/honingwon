package sszt.scene.components.copyGroup.sec
{
	import fl.controls.Label;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.data.team.BaseTeamInfo;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.ui.BorderAsset6;
	
	public class TeamItemView extends Sprite
	{
		private var _addBtn:MCacheAssetBtn1;
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _countLabel:MAssetLabel;
		private var _info:BaseTeamInfo;
		private var _mediator:CopyGroupMediator;
		
		public function TeamItemView(info:BaseTeamInfo,mediator:CopyGroupMediator)
		{
			_info = info;
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,30,210,2),new BackgroundType.LINE_1));
			//背景
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,210,32);
			graphics.endFill();
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameLabel.move(5,7);
			addChild(_nameLabel);
			_nameLabel.setHtmlValue(_info.name+"("+LanguageManager.getWord("ssztl.common.levelValue",_info.level)+")");
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_levelLabel.move(123,7);
			addChild(_levelLabel);
			
			_countLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE21);
			_countLabel.move(135,7);
			addChild(_countLabel);
			_countLabel.setHtmlValue(String(_info.emptyPos) +"/5");
			
			_addBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.scene.jion"));
			_addBtn.move(165,5);
			addChild(_addBtn);
			
			_addBtn.addEventListener(MouseEvent.CLICK,addClickHandler);
		}
		
		private function addClickHandler(evt:MouseEvent):void
		{
			if(_mediator.sceneInfo.teamData.leadId != 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.hasTeam"));
				return ;
			}
			if(_info.emptyPos == 5)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.teamFull"));
				return ;
			}
			_mediator.addTeam(_info.serverId,_info.name);
		}
		
		
		public function dispose():void
		{
			_addBtn.removeEventListener(MouseEvent.CLICK,addClickHandler);
			if(_addBtn)
			{
				_addBtn.dispose();
				_addBtn = null;
			}
			_nameLabel = null;
			_levelLabel = null;
			_countLabel = null;
			_info = null;
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}