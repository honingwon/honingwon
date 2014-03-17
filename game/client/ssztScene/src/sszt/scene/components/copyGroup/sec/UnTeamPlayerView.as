package sszt.scene.components.copyGroup.sec
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.team.UnteamPlayerInfo;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class UnTeamPlayerView extends Sprite
	{
		private var _info:UnteamPlayerInfo;
		private var _mediator:CopyGroupMediator;
		private var _inviteBtn:MCacheAssetBtn1;
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
			
		public function UnTeamPlayerView(info:UnteamPlayerInfo,mediator:CopyGroupMediator)
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
			
			_levelLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.levelValue",_info.level),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelLabel.move(80,12);
//			addChild(_levelLabel);
			
			_inviteBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.invite"));
			_inviteBtn.move(165,5);
			addChild(_inviteBtn);
			
			_inviteBtn.addEventListener(MouseEvent.CLICK,inviteClickHandler);
		}
		
		private function inviteClickHandler(evt:MouseEvent):void
		{
			_mediator.invite(_info.serverId,_info.name);
		}
		
		public function dispose():void
		{
			_inviteBtn.removeEventListener(MouseEvent.CLICK,inviteClickHandler);
			_info = null;
			_mediator = null;
			if(_inviteBtn)
			{
				_inviteBtn.dispose();
				_inviteBtn = null;
			}
			_nameLabel = null;
			_levelLabel = null;
			if(parent) parent.removeChild(this);
		}
	}
}